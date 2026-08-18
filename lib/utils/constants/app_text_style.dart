import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTextStyle {
  AppTextStyle._();

  // Helper method to adjust font size for web
  static double _adjustedFontSize(double fontSize) {
    return kIsWeb ? (fontSize - 4) : fontSize;
  }

  // BLACK
  static TextStyle black(double fontSize, FontWeight fw,
      {TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
      fontFamily: AppFonts.primaryFont,
      fontSize: _adjustedFontSize(fontSize).sp,
      fontStyle: FontStyle.normal,
      fontWeight: fw,
      color: AppColors.black,
      decoration: decoration,
    );
  }

  // GREY
  static TextStyle grey(double fontSize, FontWeight fw,
      {TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: _adjustedFontSize(fontSize).sp,
        fontStyle: FontStyle.normal,
        fontWeight: fw,
        color: AppColors.grey,
        decoration: decoration);
  }

  // LIGHT GREY
  static TextStyle lightGrey(double fontSize, FontWeight fw,
      {TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: _adjustedFontSize(fontSize).sp,
        fontStyle: FontStyle.normal,
        fontWeight: fw,
        color: AppColors.lightGrey,
        decoration: decoration);
  }

  // BLUE
  static TextStyle primary(double fontSize, FontWeight fw,
      {TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: _adjustedFontSize(fontSize).sp,
        fontStyle: FontStyle.normal,
        fontWeight: fw,
        color: AppColors.primaryColor,
        decoration: decoration);
  }

  // WHITE
  static TextStyle white(double fontSize, FontWeight fw,
      {TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: _adjustedFontSize(fontSize).sp,
        fontStyle: FontStyle.normal,
        fontWeight: fw,
        color: AppColors.white,
        decoration: decoration);
  }

  // GREEN
  static TextStyle green(double fontSize, FontWeight fw,
      {TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: _adjustedFontSize(fontSize).sp,
        fontStyle: FontStyle.normal,
        fontWeight: fw,
        color: AppColors.green,
        decoration: decoration);
  }

  // ORANGE
  static TextStyle orange(double fontSize, FontWeight fw,
      {TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: _adjustedFontSize(fontSize).sp,
        fontStyle: FontStyle.normal,
        fontWeight: fw,
        color: AppColors.orange,
        decoration: decoration);
  }

  // RED
  static TextStyle red(double fontSize, FontWeight fw,
      {TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: _adjustedFontSize(fontSize).sp,
        fontStyle: FontStyle.normal,
        fontWeight: fw,
        color: AppColors.red,
        decoration: decoration);
  }
}
