import 'dart:ui' as ui;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LuminanceUtils {
  /// Calculates the average luminance of the top portion of an image.
  /// Standard relative luminance formula: Y' = 0.2126R + 0.7152G + 0.0722B
  static Future<double> calculateTopLuminance(String imageUrl) async {
    try {
      final file = await DefaultCacheManager().getSingleFile(imageUrl);
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // We only care about the top section where the header sits (e.g., top 15%)
      final scanHeight = (image.height * 0.15).toInt().clamp(10, image.height);
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );

      if (byteData == null) return 0.5;

      double totalLuminance = 0;
      int count = 0;

      // Subsample for performance (every 4th pixel in the top section)
      for (int y = 0; y < scanHeight; y += 4) {
        for (int x = 0; x < image.width; x += 4) {
          final offset = (y * image.width + x) * 4;
          if (offset + 3 >= byteData.lengthInBytes) break;

          final r = byteData.getUint8(offset);
          final g = byteData.getUint8(offset + 1);
          final b = byteData.getUint8(offset + 2);

          // Relative luminance formula
          final lux = (0.2126 * r + 0.7152 * g + 0.0722 * b) / 255.0;
          totalLuminance += lux;
          count++;
        }
      }

      return count > 0 ? totalLuminance / count : 0.5;
    } catch (e) {
      print('Error calculating luminance: $e');
      return 0.5; // Default to neutral if error
    }
  }

  static bool isBright(double luminance) => luminance > 0.6;
}
