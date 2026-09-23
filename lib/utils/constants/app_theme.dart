import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class ThemeNotifier extends ChangeNotifier {
  String _fontFamily = 'Poppins';
  Color _primaryColor = AppColors.primaryColor;
  Color _buttonColor = AppColors.buttonColor;
  Color _bgColor = AppColors.backgroundColor;

  String get fontFamily => _fontFamily;
  Color get primaryColor => _primaryColor;
  Color get buttonColor => _buttonColor;
  Color get bgColor => _bgColor;

  void updateTheme({
    String? fontName,
    String? themeColor,
    String? buttonColor,
    String? bgColor,
  }) {
    bool hasChanges = false;

    if (fontName != null && fontName.isNotEmpty && fontName != _fontFamily) {
      _fontFamily = fontName;
      AppFonts.updatePrimaryFont(fontName);
      hasChanges = true;
    }

    if (themeColor != null && themeColor.isNotEmpty) {
      try {
        String cleanHex = themeColor.replaceAll('#', '');
        if (cleanHex.length == 6) {
          cleanHex = 'FF$cleanHex';
        }
        Color newColor = Color(int.parse(cleanHex, radix: 16));
        if (newColor != _primaryColor) {
          _primaryColor = newColor;
          hasChanges = true;
        }
      } catch (e) {
        // Handle error
      }
    }

    if (buttonColor != null && buttonColor.isNotEmpty) {
      try {
        String cleanHex = buttonColor.replaceAll('#', '');
        if (cleanHex.length == 6) {
          cleanHex = 'FF$cleanHex';
        }
        Color newColor = Color(int.parse(cleanHex, radix: 16));
        if (newColor != _buttonColor) {
          _buttonColor = newColor;
          hasChanges = true;
        }
      } catch (e) {
        // Handle error
      }
    }

    // Add background color update
    if (bgColor != null && bgColor.isNotEmpty) {
      try {
        String cleanHex = bgColor.replaceAll('#', '');
        if (cleanHex.length == 6) {
          cleanHex = 'FF$cleanHex';
        }
        Color newColor = Color(int.parse(cleanHex, radix: 16));
        if (newColor != _bgColor) {
          _bgColor = newColor;
          hasChanges = true;
        }
      } catch (e) {
        // Handle error
      }
    }

    if (hasChanges) {
      AppColors.updateThemeColors(
        themeColor: themeColor,
        buttonColor: buttonColor,
        bgColor: bgColor,
      );
      notifyListeners();
    }
  }

  // Method to update all theme properties at once
  void updateAllThemeProperties({
    required String? fontName,
    required String? themeColor,
    required String? buttonColor,
    required String? bgColor,
  }) {
    updateTheme(
      fontName: fontName,
      themeColor: themeColor,
      buttonColor: buttonColor,
      bgColor: bgColor,
    );
  }
}