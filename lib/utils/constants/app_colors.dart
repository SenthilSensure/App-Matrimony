import 'dart:ui';

class AppColors {
  // Theme derived from the app icon (assets/matri_match.jpg)
  // rose pink + gold on a soft white background
  static Color primaryColor = const Color(0xFFD6376E);
  static Color backgroundColor = const Color(0xFFFFF6F9);
  static Color buttonColor = const Color(0xFFE2457B);

  static const Color accentColor = Color(0xFFF2BF64); // gold from the icon
  static const Color softPink = Color(0xFFFCD7E5);
  static const Color border = Color(0xFFE0D7DB);

  static const Color black = Color(0xFF1F1B1D);
  static const Color lightGrey = Color(0xFFF1E9ED);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFED0730);
  static const Color green = Color(0xFF3F9325);
  static const Color orange = Color(0xFFF18B40);
  static const Color grey = Color(0xFF8D8A8C);

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
        primaryColor = const Color(0xFFD6376E);
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
        AppColors.buttonColor = const Color(0xFFE2457B);
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
        backgroundColor = const Color(0xFFFFF6F9);
      }
    }
  }
}