import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/luminance_utils.dart';

/// Provides the calculated luminance for a given image URL.
/// Results are cached automatically by Riverpod.
final luminanceProvider = FutureProvider.family<double, String>((
  ref,
  imageUrl,
) async {
  if (imageUrl.isEmpty) return 0.5;
  return await LuminanceUtils.calculateTopLuminance(imageUrl);
});
