import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Security utilities for additional cryptographic operations
class SecurityUtils {
  SecurityUtils._();

  /// Generate a secure random string
  static String generateSecureRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }

  /// Generate a secure hash from input string
  static String generateSecureHash(String input, {String? salt}) {
    final saltValue = salt ?? generateSecureRandomString(16);
    final saltedInput = '$input$saltValue';
    final bytes = utf8.encode(saltedInput);
    final digest = sha256.convert(bytes);
    return '${digest.toString()}:$saltValue';
  }

  /// Verify a hash against input
  static bool verifyHash(String input, String hashedValue) {
    try {
      final parts = hashedValue.split(':');
      if (parts.length != 2) return false;

      final salt = parts[1];

      final expectedHash = generateSecureHash(input, salt: salt);
      return expectedHash == hashedValue;
    } catch (e) {
      return false;
    }
  }

  /// Generate a secure PIN hash for storage
  static String hashPin(String pin) {
    return generateSecureHash(pin);
  }

  /// Verify PIN against stored hash
  static bool verifyPin(String pin, String storedHash) {
    return verifyHash(pin, storedHash);
  }

  /// Generate device fingerprint (basic implementation)
  static String generateDeviceFingerprint({
    String? deviceId,
    String? appVersion,
    String? buildNumber,
  }) {
    final components = [
      deviceId ?? 'unknown_device',
      appVersion ?? '1.0.0',
      buildNumber ?? '1',
      DateTime.now().millisecondsSinceEpoch.toString(),
    ];

    final combined = components.join('_');
    return sha256.convert(utf8.encode(combined)).toString();
  }

  /// Secure data wipe (overwrite memory)
  static void secureWipeString(String data) {
    // Note: In Dart, strings are immutable, but this can be used as a marker
    // for future implementation of secure memory handling
    // In production, consider using FFI for true memory wiping
  }

  /// Generate a secure session token
  static String generateSessionToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = generateSecureRandomString(32);
    final combined = '$timestamp:$random';
    return base64Url.encode(utf8.encode(combined));
  }

  /// Validate session token (basic expiry check)
  static bool isSessionTokenValid(String token, {Duration? maxAge}) {
    try {
      final decoded = utf8.decode(base64Url.decode(token));
      final parts = decoded.split(':');
      if (parts.length != 2) return false;

      final timestamp = int.parse(parts[0]);
      final tokenAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final maxAgeMs = (maxAge ?? const Duration(hours: 24)).inMilliseconds;

      return tokenAge <= maxAgeMs;
    } catch (e) {
      return false;
    }
  }

  /// Generate biometric challenge
  static String generateBiometricChallenge() {
    return generateSecureRandomString(64);
  }

  /// Obfuscate sensitive data for logging
  static String obfuscateForLogging(String sensitiveData) {
    if (sensitiveData.isEmpty) return '';
    if (sensitiveData.length <= 4) return '*' * sensitiveData.length;

    final start = sensitiveData.substring(0, 2);
    final end = sensitiveData.substring(sensitiveData.length - 2);
    final middle = '*' * (sensitiveData.length - 4);

    return '$start$middle$end';
  }

  /// Secure comparison to prevent timing attacks
  static bool secureStringCompare(String a, String b) {
    if (a.length != b.length) return false;

    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }

    return result == 0;
  }
}
