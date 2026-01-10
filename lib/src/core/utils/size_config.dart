import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  // Reference design size (iPhone 13/14 equivalent)
  static const double designWidth = 390;
  static const double designHeight = 844;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    print("Screen Size: $screenWidth x $screenHeight");

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  // Get the proportionate height as per screen size
  static double h(double inputHeight) {
    // (inputHeight / designHeight) * screenHeight
    return (inputHeight / designHeight) * screenHeight;
  }

  // Get the proportionate width as per screen size
  static double w(double inputWidth) {
    // (inputWidth / designWidth) * screenWidth
    return (inputWidth / designWidth) * screenWidth;
  }

  // Get the proportionate font size
  static double sp(double fontSize) {
    // Simple scaling based on width
    return (fontSize / designWidth) * screenWidth;
  }
}

// Extensions for easier usage
extension SizeConfigExtension on num {
  double get h => SizeConfig.h(toDouble());
  double get w => SizeConfig.w(toDouble());
  double get sp => SizeConfig.sp(toDouble());
}
