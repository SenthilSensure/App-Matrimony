import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTextStyle {
  AppTextStyle._();

  /// Font size handling:
  /// - Mobile: responsive `.sp` so text scales with the device.
  /// - Web: fixed logical pixels (slightly smaller) so text stays stable
  ///   on large desktop screens instead of becoming huge/tiny.
  static double _fontSize(double fontSize) {
    if (kIsWeb) {
      return (fontSize - 1).clamp(12.0, 34.0);
    }
    return fontSize.sp;
  }

  static TextStyle _style(
    double fontSize,
    FontWeight fw,
    Color color,
    TextDecoration decoration,
  ) {
    return TextStyle(
      fontFamily: AppFonts.primaryFont,
      fontSize: _fontSize(fontSize),
      fontStyle: FontStyle.normal,
      fontWeight: fw,
      color: color,
      decoration: decoration,
      height: 1.3,
    );
  }

  // BLACK
  static TextStyle black(double fontSize, FontWeight fw,
          {TextDecoration decoration = TextDecoration.none}) =>
      _style(fontSize, fw, AppColors.black, decoration);

  // GREY
  static TextStyle grey(double fontSize, FontWeight fw,
          {TextDecoration decoration = TextDecoration.none}) =>
      _style(fontSize, fw, AppColors.grey, decoration);

  // LIGHT GREY
  static TextStyle lightGrey(double fontSize, FontWeight fw,
          {TextDecoration decoration = TextDecoration.none}) =>
      _style(fontSize, fw, AppColors.lightGrey, decoration);

  // PRIMARY
  static TextStyle primary(double fontSize, FontWeight fw,
          {TextDecoration decoration = TextDecoration.none}) =>
      _style(fontSize, fw, AppColors.primaryColor, decoration);

  // WHITE
  static TextStyle white(double fontSize, FontWeight fw,
          {TextDecoration decoration = TextDecoration.none}) =>
      _style(fontSize, fw, AppColors.white, decoration);

  // GREEN
  static TextStyle green(double fontSize, FontWeight fw,
          {TextDecoration decoration = TextDecoration.none}) =>
      _style(fontSize, fw, AppColors.green, decoration);

  // ORANGE
  static TextStyle orange(double fontSize, FontWeight fw,
          {TextDecoration decoration = TextDecoration.none}) =>
      _style(fontSize, fw, AppColors.orange, decoration);

  // RED
  static TextStyle red(double fontSize, FontWeight fw,
          {TextDecoration decoration = TextDecoration.none}) =>
      _style(fontSize, fw, AppColors.red, decoration);
}
