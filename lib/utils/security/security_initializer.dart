import '../security/key_manager.dart';
import '../storage/app_preference.dart';

/// Security initialization helper for the app
class SecurityInitializer {
  SecurityInitializer._();

  /// Initialize all security components
  static Future<void> initialize() async {
    try {
      // Initialize the secure key manager first
      await SecureKeyManager.instance.initialize();

      // Initialize app preferences with secure keys
      await AppSharedPref.instance.initSetup();

      // Perform data migration check
      await _performDataMigrationCheck();

    } catch (e) {
      // Log error but don't crash the app
      print('Security initialization error: $e');
      rethrow;
    }
  }


  /// Perform data migration and corruption check
  static Future<void> _performDataMigrationCheck() async {
    try {
      // Test access to critical data to trigger migration if needed
      final prefs = AppSharedPref.instance;

      // These calls will trigger migration for any old encrypted data
      prefs.token; // Will trigger migration if old format
      prefs.getUser; // Will handle corrupted data gracefully

      print('Data migration check completed successfully');
    } catch (e) {
      print('Warning during data migration: $e');
      // Don't rethrow - migration issues shouldn't crash the app
    }
  }

  /// Clean up security components (call on app termination)
  static void cleanup() {
    try {
      SecureKeyManager.instance.clearKeys();
    } catch (e) {
      print('Security cleanup error: $e');
    }
  }
}
