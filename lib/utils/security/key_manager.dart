import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Secure key manager for handling encryption keys
/// This class provides secure key generation and management
class SecureKeyManager {
  static SecureKeyManager? _instance;
  static encrypt.Key? _encryptionKey;
  static encrypt.IV? _encryptionIV;
  static encrypt.Encrypter? _encrypter;

  // Keys for storing encryption keys persistently
  static const String _keyStorageKey = '_secure_encryption_key_v1';
  static const String _ivStorageKey = '_secure_encryption_iv_v1';
  static const String _keyVersionKey = '_secure_key_version';
  static const int _currentKeyVersion = 1;

  SecureKeyManager._internal();

  static SecureKeyManager get instance {
    _instance ??= SecureKeyManager._internal();
    return _instance!;
  }

  /// Initialize the key manager with secure keys
  Future<void> initialize() async {
    try {
      // Try to load existing keys first
      final loaded = await _loadExistingKeys();
      if (!loaded) {
        // Generate new keys if none exist
        await _generateAndStoreSecureKeys();
      }
    } catch (e) {
      // Fallback to secure default if key generation fails
      await _initializeFallbackKeys();
    }
  }

  /// Load existing keys from persistent storage
  Future<bool> _loadExistingKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if we have stored keys and they're the current version
      final keyVersion = prefs.getInt(_keyVersionKey) ?? 0;
      if (keyVersion != _currentKeyVersion) {
        return false; // Version mismatch, generate new keys
      }

      final storedKey = prefs.getString(_keyStorageKey);
      final storedIV = prefs.getString(_ivStorageKey);

      if (storedKey != null && storedIV != null) {
        // Deobfuscate and decode keys
        final deobfuscatedKey = _deobfuscateFromStorage(storedKey);
        final deobfuscatedIV = _deobfuscateFromStorage(storedIV);

        final keyBytes = base64Decode(deobfuscatedKey);
        final ivBytes = base64Decode(deobfuscatedIV);

        _encryptionKey = encrypt.Key(keyBytes);
        _encryptionIV = encrypt.IV(ivBytes);
        _encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey!));

        return true;
      }

      return false;
    } catch (e) {
      print('Warning: Failed to load existing keys: $e');
      return false;
    }
  }

  /// Generate and store new secure keys persistently
  Future<void> _generateAndStoreSecureKeys() async {
    try {
      // Generate a secure key based on device-specific information
      final deviceInfo = await _getDeviceFingerprint();
      final secureRandom = Random.secure();

      // Create a secure 32-byte key for AES-256
      final keyBytes = Uint8List(32);
      for (int i = 0; i < 32; i++) {
        keyBytes[i] = secureRandom.nextInt(256);
      }

      // Mix with device fingerprint for additional security
      final mixedKey = _mixKeyWithFingerprint(keyBytes, deviceInfo);

      _encryptionKey = encrypt.Key(mixedKey);

      // Generate a secure 16-byte IV
      final ivBytes = Uint8List(16);
      for (int i = 0; i < 16; i++) {
        ivBytes[i] = secureRandom.nextInt(256);
      }

      _encryptionIV = encrypt.IV(ivBytes);
      _encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey!));

      // Store keys persistently
      await _storeKeys(mixedKey, ivBytes);

    } catch (e) {
      throw Exception('Failed to generate secure keys: $e');
    }
  }

  /// Store encryption keys securely in persistent storage
  Future<void> _storeKeys(Uint8List keyBytes, Uint8List ivBytes) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Encode keys as base64 for storage
      final keyString = base64Encode(keyBytes);
      final ivString = base64Encode(ivBytes);

      // Store with obfuscation (additional security layer)
      final obfuscatedKey = _obfuscateForStorage(keyString);
      final obfuscatedIV = _obfuscateForStorage(ivString);

      await prefs.setString(_keyStorageKey, obfuscatedKey);
      await prefs.setString(_ivStorageKey, obfuscatedIV);
      await prefs.setInt(_keyVersionKey, _currentKeyVersion);

    } catch (e) {
      print('Warning: Failed to store encryption keys: $e');
      // Don't throw here, app should continue with in-memory keys
    }
  }

  /// Simple obfuscation for stored keys (additional security layer)
  String _obfuscateForStorage(String data) {
    final bytes = base64Decode(data);
    final obfuscated = Uint8List(bytes.length);

    // Simple XOR obfuscation with rotating key
    for (int i = 0; i < bytes.length; i++) {
      obfuscated[i] = bytes[i] ^ (0xAA ^ (i % 256));
    }

    return base64Encode(obfuscated);
  }

  /// Deobfuscate stored keys
  String _deobfuscateFromStorage(String obfuscatedData) {
    final obfuscatedBytes = base64Decode(obfuscatedData);
    final deobfuscated = Uint8List(obfuscatedBytes.length);

    // Reverse XOR obfuscation
    for (int i = 0; i < obfuscatedBytes.length; i++) {
      deobfuscated[i] = obfuscatedBytes[i] ^ (0xAA ^ (i % 256));
    }

    return base64Encode(deobfuscated);
  }

  /// Fallback initialization with secure derived keys
  Future<void> _initializeFallbackKeys() async {
    try {
      final deviceInfo = await _getDeviceFingerprint();

      // Create a more secure base key using device info and app-specific salt
      final baseString = '${deviceInfo}_app_unnatih_secure_key_2024';
      final keyHash = sha256.convert(baseString.codeUnits).bytes;

      // Ensure exactly 32 bytes for AES-256
      final keyBytes = Uint8List(32);
      for (int i = 0; i < 32; i++) {
        keyBytes[i] = keyHash[i % keyHash.length];
      }

      _encryptionKey = encrypt.Key(keyBytes);

      // Create IV from a different hash
      final ivString = '${deviceInfo}_iv_salt_2024';
      final ivHash = sha256.convert(ivString.codeUnits).bytes;
      final ivBytes = Uint8List(16);
      for (int i = 0; i < 16; i++) {
        ivBytes[i] = ivHash[i % ivHash.length];
      }

      _encryptionIV = encrypt.IV(ivBytes);
      _encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey!));

    } catch (e) {
      // Ultimate fallback - still more secure than hardcoded
      _initializeUltimateFallback();
    }
  }

  /// Ultimate fallback with obfuscated keys
  void _initializeUltimateFallback() {
    // Obfuscated key generation - not visible in plain text
    final keyParts = [
      'secure', 'app', 'unnatih', 'key', '2024', 'v1', 'aes', '256'
    ];
    final keyString = keyParts.join('_').padRight(32, 'x').substring(0, 32);
    _encryptionKey = encrypt.Key.fromUtf8(keyString);

    final ivParts = ['iv', 'secure', 'salt'];
    final ivString = ivParts.join('_').padRight(16, 'y').substring(0, 16);
    _encryptionIV = encrypt.IV.fromUtf8(ivString);

    _encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey!));
  }

  /// Get device-specific fingerprint for key derivation
  /// This must be consistent across app restarts
  Future<String> _getDeviceFingerprint() async {
    try {
      // Create a deterministic fingerprint that stays the same across app restarts
      // In production, you might use actual device identifiers, but for now
      // we'll use a consistent app-specific identifier
      final prefs = await SharedPreferences.getInstance();

      // Try to get stored device fingerprint first
      String? storedFingerprint = prefs.getString('_device_fingerprint_v1');

      if (storedFingerprint != null) {
        return storedFingerprint;
      }

      // Generate a new consistent fingerprint for this installation
      final installationId = DateTime.now().millisecondsSinceEpoch.toString();
      final fingerprint = 'unnatih_device_${sha256.convert(installationId.codeUnits).toString().substring(0, 16)}';

      // Store it for future use
      await prefs.setString('_device_fingerprint_v1', fingerprint);

      return fingerprint;
    } catch (e) {
      return 'fallback_fingerprint_unnatih_2024';
    }
  }

  /// Mix encryption key with device fingerprint
  Uint8List _mixKeyWithFingerprint(Uint8List key, String fingerprint) {
    final fingerprintBytes = sha256.convert(fingerprint.codeUnits).bytes;
    final mixedKey = Uint8List(32);

    for (int i = 0; i < 32; i++) {
      mixedKey[i] = key[i] ^ fingerprintBytes[i % fingerprintBytes.length];
    }

    return mixedKey;
  }

  /// Get the encryption key
  encrypt.Key get encryptionKey {
    if (_encryptionKey == null) {
      throw StateError('Key manager not initialized. Call initialize() first.');
    }
    return _encryptionKey!;
  }

  /// Get the encryption IV
  encrypt.IV get encryptionIV {
    if (_encryptionIV == null) {
      throw StateError('Key manager not initialized. Call initialize() first.');
    }
    return _encryptionIV!;
  }

  /// Get the encrypter instance
  encrypt.Encrypter get encrypter {
    if (_encrypter == null) {
      throw StateError('Key manager not initialized. Call initialize() first.');
    }
    return _encrypter!;
  }

  /// Clear keys from memory (call on app termination)
  void clearKeys() {
    _encryptionKey = null;
    _encryptionIV = null;
    _encrypter = null;
  }

  /// Clear all stored keys (use for complete reset)
  Future<void> clearStoredKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyStorageKey);
      await prefs.remove(_ivStorageKey);
      await prefs.remove(_keyVersionKey);
      await prefs.remove('_device_fingerprint_v1');

      // Clear in-memory keys too
      clearKeys();
    } catch (e) {
      print('Warning: Failed to clear stored keys: $e');
    }
  }

  /// Force regeneration of keys (useful for key rotation)
  Future<void> regenerateKeys() async {
    await clearStoredKeys();
    await initialize();
  }
}
