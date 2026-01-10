import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class LocationService {
  /// Determines the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      debugPrint('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        debugPrint('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      debugPrint(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      debugPrint('Error getting GPS location: $e');
      return null;
    }
  }

  /// Fallback: Get location details from IP address using a public API.
  /// Returns a Map with 'city', 'country', 'lat', 'lon', etc.
  static Future<Map<String, dynamic>?> getIpLocation() async {
    try {
      final response = await http.get(Uri.parse('http://ip-api.com/json'));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching IP location: $e');
    }
    return null;
  }

  /// Get simplified address/location data (GPS priority, then IP fallback)
  static Future<LocationData> getBestLocation() async {
    // 1. Try GPS
    final position = await determinePosition();
    if (position != null) {
      String city = '';
      String country = '';
      String countryCode = '';
      String zip = '';
      String region = '';
      String street = '';
      String suburb = '';

      try {
        // Use Geocoding to get precise details
        // Note: We need to import 'package:geocoding/geocoding.dart'
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          city = place.locality ?? place.subAdministrativeArea ?? '';
          country = place.country ?? '';
          countryCode = place.isoCountryCode ?? '';
          zip = place.postalCode ?? '';
          region = place.administrativeArea ?? '';
          street = place.street ?? '';
          suburb = place.subLocality ?? '';
        }
      } catch (e) {
        debugPrint('Geocoding error: $e. Falling back to IP.');
        // Fallback to IP if geocoding fails (e.g. no internet or excessive requests)
        final ipData = await getIpLocation();
        city = ipData?['city'] ?? '';
        country = ipData?['country'] ?? '';
        countryCode = ipData?['countryCode'] ?? '';
        zip = ipData?['zip'] ?? '';
        region = ipData?['regionName'] ?? '';
      }

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        city: city,
        country: country,
        countryCode: countryCode,
        zip: zip,
        region: region,
        street: street,
        suburb: suburb,
      );
    }

    // 2. Fallback to IP only
    final ipData = await getIpLocation();
    if (ipData != null) {
      return LocationData(
        latitude: ipData['lat'] as double? ?? 0.0,
        longitude: ipData['lon'] as double? ?? 0.0,
        city: ipData['city'] ?? '',
        country: ipData['country'] ?? '',
        countryCode: ipData['countryCode'] ?? '',
        zip: ipData['zip'] ?? '',
        region: ipData['regionName'] ?? '',
      );
    }

    return LocationData();
  }
}

class LocationData {
  final double? latitude;
  final double? longitude;
  final String city;
  final String country;
  final String countryCode;
  final String zip;
  final String region;
  final String street;
  final String suburb;

  LocationData({
    this.latitude,
    this.longitude,
    this.city = '',
    this.country = '',
    this.countryCode = '',
    this.zip = '',
    this.region = '',
    this.street = '',
    this.suburb = '',
  });

  String get formattedAddress {
    final parts = [
      street,
      suburb,
      city,
      region,
      country,
    ].where((s) => s.isNotEmpty).toList();
    return parts.join(', ');
  }
}
