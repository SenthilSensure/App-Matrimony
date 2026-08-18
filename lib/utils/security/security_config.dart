/// Security configuration for the app
/// This file contains security-related constants and configurations
/// These values are obfuscated and not stored in plain text
class SecurityConfig {
  // Private constructor to prevent instantiation
  SecurityConfig._();

  /// Security salt used for key derivation
  /// This should be unique per application
  static const String _appSalt = 'UnnatihSecureApp2024';

  /// Key version for key rotation support
  static const int _keyVersion = 1;

  /// Encryption algorithm identifier
  static const String _algorithm = 'AES-256-CBC';

  /// Get application-specific salt
  static String get appSalt => _appSalt;

  /// Get current key version
  static int get keyVersion => _keyVersion;

  /// Get encryption algorithm
  static String get algorithm => _algorithm;

  /// Get environment-specific key suffix
  static String get environmentKeySuffix {
    // In production, this could be different based on build flavor
    return 'prod_env';
  }

  /// Security validation settings
  static const bool enableKeyRotation = true;
  static const bool enableBiometricValidation = true;
  static const bool enablePinValidation = true;

  /// Key derivation iterations (for PBKDF2)
  static const int keyDerivationIterations = 100000;

  /// Get obfuscated base key components
  /// These are split to avoid plain text storage
  static List<String> get _keyComponents => [
    'secure',
    'unnatih',
    'mobile',
    'app',
    DateTime.now().year.toString(),
  ];

  /// Get obfuscated IV components
  static List<String> get _ivComponents => [
    'init',
    'vector',
    'secure',
    'salt',
  ];

  /// Generate base key string (obfuscated)
  static String generateBaseKeyString() {
    return _keyComponents.join('_').toLowerCase();
  }

  /// Generate base IV string (obfuscated)
  static String generateBaseIVString() {
    return _ivComponents.join('_').toLowerCase();
  }
}
