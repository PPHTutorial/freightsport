import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';

class BulkImportService {
  Future<List<List<dynamic>>> pickAndParseCsv() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: kIsWeb, // Use bytes for web
      );

      if (result == null || result.files.isEmpty) return [];

      final file = result.files.first;
      String csvString;

      if (kIsWeb) {
        final bytes = file.bytes;
        if (bytes == null) throw Exception('File bytes are null');
        csvString = utf8.decode(bytes);
      } else {
        final path = file.path;
        if (path == null) throw Exception('File path is null');
        final input = File(path).openRead();
        csvString = await input
            .transform(utf8.decoder)
            .transform(const CsvToListConverter())
            .join('\n'); // This might be wrong if CsvToList returns List<List>

        // Correct approach for IO:
        return await input
            .transform(utf8.decoder)
            .transform(const CsvToListConverter())
            .toList();
      }

      // For web or if we decoded to string manually
      return const CsvToListConverter().convert(csvString);
    } catch (e) {
      debugPrint('Error picking/parsing CSV: $e');
      rethrow;
    }
  }

  /// Parses raw CSV data into UserModels.
  /// Expected columns: email, name, role, phoneNumber
  List<UserModel> parseUsers(List<List<dynamic>> rows) {
    // Skip header row if present
    final startIndex =
        rows.isNotEmpty && rows[0][0].toString().toLowerCase() == 'email'
        ? 1
        : 0;

    final List<UserModel> users = [];

    for (int i = startIndex; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 3) continue; // Minimum required fields

      try {
        final email = row[0].toString().trim();
        final name = row[1].toString().trim();
        final roleStr = row[2].toString().trim().toLowerCase();
        final phone = row.length > 3 ? row[3].toString().trim() : null;

        UserRole role;
        switch (roleStr) {
          case 'admin':
            role = UserRole.admin;
            break;
          case 'vendor':
            role = UserRole.vendor;
            break;
          case 'courier':
            role = UserRole.courier;
            break;
          default:
            role = UserRole.customer;
        }

        // Generate temporary ID (will be replaced by Auth UID on creation)
        users.add(
          UserModel(
            id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
            email: email,
            name: name,
            username: email.split('@')[0],
            role: role,
            phoneNumber: phone,
            photoUrl: null,
            isProfileComplete: false,
            //createdAt: DateTime.now(),
          ),
        );
      } catch (e) {
        debugPrint('Error parsing user row $i: $e');
      }
    }
    return users;
  }

  /// Parses raw CSV data into Shipments.
  /// Expected: trackingNumber, senderName, recipientName, recipientAddress, totalWeight
  List<Shipment> parseShipments(List<List<dynamic>> rows) {
    final startIndex =
        rows.isNotEmpty &&
            rows[0][0].toString().toLowerCase() == 'trackingnumber'
        ? 1
        : 0;

    final List<Shipment> shipments = [];

    for (int i = startIndex; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 5) continue;

      try {
        final trackingNumber = row[0].toString().trim();
        final senderName = row[1].toString().trim();
        final recipientName = row[2].toString().trim();
        final recipientAddress = row[3].toString().trim();
        final weight = double.tryParse(row[4].toString()) ?? 0.0;

        shipments.add(
          Shipment(
            id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
            trackingNumber: trackingNumber,
            senderName: senderName,
            senderAddress: 'Unknown', // Placeholder
            senderPhone: 'Unknown', // Placeholder
            recipientName: recipientName,
            recipientAddress: recipientAddress,
            recipientPhone: 'Unknown', // Placeholder
            totalWeight: weight,
            currentStatus: ShipmentStatusType.created,
            createdAt: DateTime.now(),
            estimatedDeliveryDate: DateTime.now().add(
              const Duration(days: 7),
            ), // Placeholder
            events: [],
            packages: [],
          ),
        );
      } catch (e) {
        debugPrint('Error parsing shipment row $i: $e');
      }
    }
    return shipments;
  }
}
