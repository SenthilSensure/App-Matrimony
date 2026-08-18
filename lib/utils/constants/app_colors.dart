import 'dart:ui';

class AppColors {
  static Color primaryColor = const Color(0xFF082469);
  static Color backgroundColor = const Color(0xFFF5F5F5);
  static Color buttonColor = const Color(0xFF082469);

  static const Color black = Color(0xFF000000);
  static const Color lightGrey = Color(0xFFEBEDF6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFED0730);
  static const Color green = Color(0xFF3F9325);
  static const Color orange = Color(0xFFF18B40);
  static const Color grey = Color(0xFFACA9A9);

  // Method to update colors dynamically
  static void updateThemeColors({
    String? themeColor,
    String? buttonColor,
    String? bgColor, // Add background color parameter
  }) {
    if (themeColor != null && themeColor.isNotEmpty) {
      try {
        String cleanHex = themeColor.replaceAll('#', '');
        if (cleanHex.length == 6) {
          cleanHex = 'FF$cleanHex';
        }
        primaryColor = Color(int.parse(cleanHex, radix: 16));
      } catch (e) {
        primaryColor = const Color(0xFF082469);
      }
    }

    if (buttonColor != null && buttonColor.isNotEmpty) {
      try {
        String cleanHex = buttonColor.replaceAll('#', '');
        if (cleanHex.length == 6) {
          cleanHex = 'FF$cleanHex';
        }
        AppColors.buttonColor = Color(int.parse(cleanHex, radix: 16));
      } catch (e) {
        AppColors.buttonColor = const Color(0xFF082469);
      }
    }

    // Add background color update
    if (bgColor != null && bgColor.isNotEmpty) {
      try {
        String cleanHex = bgColor.replaceAll('#', '');
        if (cleanHex.length == 6) {
          cleanHex = 'FF$cleanHex';
        }
        backgroundColor = Color(int.parse(cleanHex, radix: 16));
      } catch (e) {
        backgroundColor = const Color(0xFFF5F5F5);
      }
    }
  }
}