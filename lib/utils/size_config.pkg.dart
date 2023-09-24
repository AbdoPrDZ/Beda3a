import 'package:flutter/material.dart';

class SizeConfig {
  late MediaQueryData _mediaQueryData;

  SizeConfig(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
  }

  Size get screenSize => _mediaQueryData.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  Orientation get orientation => _mediaQueryData.orientation;
  double get realScreenWidth =>
      orientation == Orientation.landscape ? screenHeight : screenWidth;
  double get realScreenHeight =>
      orientation == Orientation.landscape ? screenWidth : screenHeight;

  double percentOfScreenHeight(double percent) => percent * screenHeight;
  double percentOfScreenWidth(double percent) => percent * screenWidth;

  double percentOfRealScreenHeight(double percent) => percent * screenHeight;
  double percentOfRealScreenWidth(double percent) => percent * screenWidth;
}
