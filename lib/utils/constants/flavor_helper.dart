import 'package:flutter/foundation.dart';

class FlavorHelper {
  static String getFlavor() {
    if (kDebugMode) {
      // In debug mode, we can use the FLAVOR environment variable
      return const String.fromEnvironment('FLAVOR', defaultValue: 'staging');
    } else {
      // In release mode, we need to use the build configuration
      // This will be set by the Android build.gradle
      return const String.fromEnvironment('FLAVOR', defaultValue: 'production');
    }
  }
} 