import 'package:flutter/cupertino.dart';

class AppThemeColor {
  static const Color dullWhiteColor = Color(0xFFE5E5E5);
  static const Color pureWhiteColor = Color(0xFFFFFFFF);
  static const Color pureBlackColor = Color(0xFF000000);
  static const Color dullBlackColor = Color(0x40000000);
  static const Color darkColor = Color(0xFF801126);
  static const Color darkBlueColor = Color(0xFF000758);
  static const Color transparentBlueColor = Color(0x94000758);
  static const Color orangeColor = Color(0xFFE38F5B);
  static const Color greenColor = Color(0xFF88C738);
  static const Color dullBlueColor = Color(0xFF73ABE4);
  static const Color lightBlueColor = Color(0xFFF3F8FC);
  static const Color dullFontColor = Color(0xFF646060);

  static const Color backGroundColor = Color(0xFFFFFFFF);
  static const Color cardBackGroundColor = Color(0x90cddbea);
  static const Color grayColor = Color(0xFF60676C);
  static const Color lightGrayColor = Color(0x60B8BBBE);

  static const Gradient backgroundGradient1 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.8, 1),
    colors: <Color>[
      Color(0xffFFFFFF),
      Color(0xffDEDEE7),
    ], // Gradient from https://learnui.design/tools/gradient-generator.html
    tileMode: TileMode.mirror,
  );

  static const Gradient backgroundGradient2 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.8, 1),
    colors: <Color>[
      Color(0x80FFFFFF),
      Color(0x67FFFFFF),
    ], // Gradient from https://learnui.design/tools/gradient-generator.html
    tileMode: TileMode.mirror,
  );
}
