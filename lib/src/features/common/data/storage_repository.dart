import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart'; // For Colors
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';

final storageRepositoryProvider = Provider((ref) {
  return StorageRepository(FirebaseStorage.instance, ref);
});

class StorageRepository {
  final FirebaseStorage _storage;
  final Ref _ref;
  final ImagePicker _picker = ImagePicker();

  StorageRepository(this._storage, this._ref);

  /// Picks a file and processes it (cropping/compressing if it's an image).
  /// Returns the local [File] if successful.
  Future<File?> pickAndProcessFile({
    FileType fileType = FileType.image,
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    try {
      // 0. Check Permissions
      debugPrint(
        'Checking permissions for type: $fileType, source: $imageSource',
      );
      if (fileType == FileType.image) {
        if (imageSource == ImageSource.camera) {
          final cameraStatus = await Permission.camera.request();
          if (cameraStatus.isPermanentlyDenied) {
            openAppSettings();
            return null;
          }
        } else {
          final photosStatus = await Permission.photos.request();
          if (photosStatus.isPermanentlyDenied) {
            // Try to be graceful, maybe they have limited access
          }
        }
      } else {
        final storageStatus = await Permission.storage.request();
        if (storageStatus.isDenied && !storageStatus.isPermanentlyDenied) {
          await [Permission.photos, Permission.videos].request();
        }
      }

      File? fileToProcess;

      if (fileType == FileType.image) {
        // Image Logic: Pick -> Crop -> Compress
        debugPrint('Picking image from $imageSource...');
        final XFile? pickedImage = await _picker.pickImage(
          source: imageSource,
          imageQuality: 100,
        );

        if (pickedImage == null) {
          debugPrint('No image picked.');
          return null;
        }

        fileToProcess = File(pickedImage.path);
        debugPrint('Image picked: ${fileToProcess.path}');

        // Crop
        final croppedFile = await _cropImage(fileToProcess);
        if (croppedFile == null) {
          debugPrint('Cropping cancelled or failed.');
          return null;
        }
        fileToProcess = croppedFile;
        debugPrint('Image cropped: ${fileToProcess.path}');

        // Compress
        final compressedFile = await _compressImage(fileToProcess);
        if (compressedFile != null) {
          fileToProcess = compressedFile;
          debugPrint('Image compressed: ${fileToProcess.path}');
        }
      } else {
        // Generic File Logic (PDF, Doc, etc.)
        debugPrint('Picking generic file...');
        final result = await FilePicker.platform.pickFiles(type: fileType);

        if (result == null || result.files.single.path == null) {
          debugPrint('No file picked.');
          return null;
        }

        fileToProcess = File(result.files.single.path!);
        final extension = p.extension(fileToProcess.path).toLowerCase();

        // If the generic file picked is an image, trigger cropping/compression
        if (['.jpg', '.jpeg', '.png'].contains(extension)) {
          debugPrint(
            'Generic picker picked an image, triggering crop/compress...',
          );
          final croppedFile = await _cropImage(fileToProcess);
          if (croppedFile != null) {
            fileToProcess = croppedFile;
            debugPrint('Image cropped (from generic): ${fileToProcess.path}');

            final compressedFile = await _compressImage(fileToProcess);
            if (compressedFile != null) {
              fileToProcess = compressedFile;
              debugPrint(
                'Image compressed (from generic): ${fileToProcess.path}',
              );
            }
          }
        }
      }

      return fileToProcess;
    } catch (e, stack) {
      debugPrint('Pick/Process error: $e');
      debugPrint('Stack trace: $stack');
      return null;
    }
  }

  /// Uploads a local file to Firebase Storage.
  /// [pathPrefix] is the folder (e.g., 'profile_images', 'kyc_documents').
  /// Returns the download URL if successful.
  Future<String?> uploadFile({
    required File file,
    required String pathPrefix,
  }) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      debugPrint(
        'DEBUG: Upload failed - No authenticated user found in AuthRepository.',
      );
      return null;
    }

    try {
      if (!file.existsSync()) {
        debugPrint(
          'DEBUG: Upload failed - Local file does not exist at: ${file.path}',
        );
        return null;
      }

      final String extension = p.extension(file.path).toLowerCase().isEmpty
          ? '.jpg'
          : p.extension(file.path).toLowerCase();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${user.id}_$timestamp$extension';

      // Rules require: users/{userId}/{allPaths=**}
      final storagePath = 'users/${user.id}/$pathPrefix/$fileName';
      debugPrint(
        'DEBUG: Attempting upload to Storage: $storagePath (Auth UID: ${user.id})',
      );

      final ref = _storage.ref().child(storagePath);
      final uploadTask = ref.putFile(file);

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('DEBUG: Storage Upload Success! URL: $downloadUrl');
      return downloadUrl;
    } catch (e, stack) {
      debugPrint('DEBUG: Storage Upload Task Error: $e');
      debugPrint('DEBUG: Stack trace: $stack');
      return null;
    }
  }

  /// Legacy helper for one-shot pick & upload (used by Profile Screen for now)
  Future<String?> pickAndUploadFile({
    required String pathPrefix,
    FileType fileType = FileType.image,
    ImageSource imageSource = ImageSource.gallery,
    void Function(File file)? onFileSelected,
  }) async {
    final file = await pickAndProcessFile(
      fileType: fileType,
      imageSource: imageSource,
    );
    if (file == null) return null;

    onFileSelected?.call(file);
    return uploadFile(file: file, pathPrefix: pathPrefix);
  }

  Future<File?> _cropImage(File imageFile) async {
    try {
      debugPrint('Launching cropper for: ${imageFile.path}');
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        // Use compress format to ensure we get a JPG back for easier handling
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop & Rotate',
            toolbarColor: AppTheme.primaryBlue,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: AppTheme.accentOrange,
            statusBarColor: AppTheme.primaryBlue,
            backgroundColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
            title: 'Crop & Rotate',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );
      if (croppedFile != null) {
        debugPrint('Cropping success: ${croppedFile.path}');
        return File(croppedFile.path);
      }
      debugPrint('Cropping returned null (cancelled).');
      return null;
    } catch (e) {
      debugPrint('Cropping activity failure: $e');
      return null;
    }
  }

  Future<File?> _compressImage(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = p.join(
        tempDir.path,
        '${p.basenameWithoutExtension(file.path)}_compressed.jpg',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 75,
        minWidth: 1024,
        minHeight: 1024,
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      debugPrint('Compression error: $e');
      return file;
    }
  }
}
