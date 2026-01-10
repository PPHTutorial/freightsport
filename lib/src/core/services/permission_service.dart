import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  /// Request all required permissions for the app/onboarding.
  /// Returns true if essential permissions (Location) are granted.
  static Future<bool> requestOnboardingPermissions(BuildContext context) async {
    // Request multiple permissions at once
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      // For Android 13+ (SDK 33), storage permissions are granular.
      // We request photos/media mainly.
      Permission.photos,
      Permission.storage, // For older Android
    ].request();

    // Check Location specifically as it's critical for the next step
    final locationGranted = statuses[Permission.location]?.isGranted ?? false;

    // Optional: Log or handle other statuses
    if (!locationGranted && context.mounted) {
      // If permanently denied, show a dialog to open settings
      if (statuses[Permission.location]?.isPermanentlyDenied ?? false) {
        _showSettingsDialog(context);
      }
    }

    return locationGranted;
  }

  static Future<void> _showSettingsDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
          'Location permission is required to auto-fill your address and track shipments. '
          'Please enable it in the app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
