class AppFonts {
  AppFonts._();

  static String primaryFont = 'Poppins';

  // Method to update font dynamically
  static void updatePrimaryFont(String? fontName) {
    if (fontName != null && fontName.isNotEmpty) {
      primaryFont = fontName;
    } else {
      primaryFont = 'Poppins';
    }
  }
}
