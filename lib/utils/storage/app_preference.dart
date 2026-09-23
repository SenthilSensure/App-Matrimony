import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../security/key_manager.dart';

class AppSharedPref {
  final String _token = "Token";
  final String _deviceToken = "DeviceToken";
  final String _isLoggedIn = "LoggedIn";
  final String _appTour = "AppTour";
  final String _userData = "UserData";
  // Add theme-related keys
  final String _themeColor = "ThemeColor";
  final String _buttonColor = "ButtonColor";
  final String _fontName = "FontName";
  final String _bgColor = "BgColor";
  static SharedPreferences? _preferences;

  // Secure key manager for encryption
  static SecureKeyManager get _keyManager => SecureKeyManager.instance;

  AppSharedPref._privateConstructor();

  static final AppSharedPref instance = AppSharedPref._privateConstructor();

  static Future<AppSharedPref> getInstance() async {
    return AppSharedPref.instance;
  }

  initSetup() async {
    _preferences = await SharedPreferences.getInstance();
    // Initialize secure key manager - this will now load existing keys or create new ones
    await _keyManager.initialize();
  }

  String _encryptValue(String value) {
    try {
      final encrypted = _keyManager.encrypter.encrypt(value, iv: _keyManager.encryptionIV);
      return encrypted.base64;
    } catch (e) {
      print('Warning: Encryption failed, key manager may not be initialized: $e');
      // Return the value as-is if encryption fails (fallback)
      return value;
    }
  }

  String _decryptValue(String value) {
    try {
      // First try with new secure key manager
      final decrypted = _keyManager.encrypter.decrypt64(value, iv: _keyManager.encryptionIV);
      return decrypted;
    } catch (e) {
      print('Warning: New key decryption failed: $e');
      // If new decryption fails, try with legacy keys for backward compatibility
      try {
        return _decryptWithLegacyKeys(value);
      } catch (e2) {
        print('Warning: Legacy key decryption failed: $e2');
        // If both fail, check if it's already plain text or malformed encrypted data
        return _handleLegacyData(value);
      }
    }
  }

  /// Decrypt using legacy hardcoded keys for backward compatibility
  String _decryptWithLegacyKeys(String value) {
    try {
      // Legacy hardcoded keys (only for migration)
      final legacyKey = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows!');
      final legacyIV = encrypt.IV.fromUtf8('8bytesiv12345678');
      final legacyEncrypter = encrypt.Encrypter(encrypt.AES(legacyKey));

      final decrypted = legacyEncrypter.decrypt64(value, iv: legacyIV);

      // Successfully decrypted with legacy keys, now re-encrypt with new keys for future use
      _migrateEncryptedData(value, decrypted);

      return decrypted;
    } catch (e) {
      throw Exception('Legacy decryption failed');
    }
  }

  /// Handle potentially corrupted or plain text legacy data
  String _handleLegacyData(String value) {
    // Check if the value looks like encrypted data (base64)
    if (_isLikelyEncryptedData(value)) {
      // If it looks encrypted but can't be decrypted, it might be corrupted
      print('Warning: Found potentially corrupted encrypted data, returning empty string');
      return '';
    }

    // If it doesn't look encrypted, treat as plain text (very old data)
    return value;
  }

  /// Check if a string looks like encrypted base64 data
  bool _isLikelyEncryptedData(String value) {
    if (value.isEmpty) return false;

    // Check if it's a reasonable length for encrypted data
    if (value.length < 20) return false;

    // Check if it contains only base64 characters
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
    if (!base64Pattern.hasMatch(value)) return false;

    // If it passes basic checks, assume it's encrypted
    return true;
  }

  /// Migrate old encrypted data to new encryption format
  void _migrateEncryptedData(String oldEncrypted, String decrypted) {
    try {
      // Re-encrypt with new secure keys
      final newEncrypted = _encryptValue(decrypted);

      // Find which preference key this belongs to and update it
      _migrateSinglePreference(_token, oldEncrypted, newEncrypted);
      _migrateSinglePreference(_deviceToken, oldEncrypted, newEncrypted);
      _migrateSinglePreference(_themeColor, oldEncrypted, newEncrypted);
      _migrateSinglePreference(_buttonColor, oldEncrypted, newEncrypted);
      _migrateSinglePreference(_fontName, oldEncrypted, newEncrypted);
      _migrateSinglePreference(_bgColor, oldEncrypted, newEncrypted);
      _migrateSinglePreference(_appTour, oldEncrypted, newEncrypted);
      _migrateSinglePreference(_isLoggedIn, oldEncrypted, newEncrypted);
      _migrateSinglePreference(_userData, oldEncrypted, newEncrypted);

    } catch (e) {
      print('Warning: Failed to migrate encrypted data: $e');
    }
  }

  /// Migrate a single preference if it matches the old encrypted value
  void _migrateSinglePreference(String key, String oldEncrypted, String newEncrypted) {
    try {
      final currentValue = _preferences?.getString(key);
      if (currentValue == oldEncrypted) {
        _preferences?.setString(key, newEncrypted);
        print('Migrated preference: $key');
      }
    } catch (e) {
      // Silently ignore migration errors for individual preferences
    }
  }

  void _saveToDisk<T>(String key, T content) {
    if (content is String) {
      final encrypted = _encryptValue(content);
      _preferences?.setString(key, encrypted);
    }
    if (content is bool) {
      _preferences?.setBool(key, content);
    }
    if (content is int) {
      _preferences?.setInt(key, content);
    }
    if (content is double) {
      _preferences?.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences?.setStringList(key, content);
    }
  }

  dynamic _getFromDisk(String key) {
    var value = _preferences!.get(key);
    if (value is String) {
      return _decryptValue(value);
    }
    return value;
  }

  // Token
  set token(String value) {
    _saveToDisk(_token, value);
  }

  String get token {
    var data = _getFromDisk(_token);
    if (data != null) {
      return data;
    }
    return '';
  }

  // Device Token
  set deviceToken(String value) {
    _saveToDisk(_deviceToken, value);
  }

  String get deviceToken {
    var data = _getFromDisk(_deviceToken);
    if (data != null) {
      return data;
    }
    return '';
  }

  // Add theme color getters and setters
  set themeColor(String value) {
    _saveToDisk(_themeColor, value);
  }

  String get themeColor {
    var data = _getFromDisk(_themeColor);
    if (data != null) {
      return data;
    }
    return '';
  }

  // Button Color
  set buttonColor(String value) {
    _saveToDisk(_buttonColor, value);
  }

  String get buttonColor {
    var data = _getFromDisk(_buttonColor);
    if (data != null) {
      return data;
    }
    return '';
  }

  // Font Name
  set fontName(String value) {
    _saveToDisk(_fontName, value);
  }

  String get fontName {
    var data = _getFromDisk(_fontName);
    if (data != null) {
      return data;
    }
    return '';
  }

  // Background Color
  set bgColor(String value) {
    _saveToDisk(_bgColor, value);
  }

  String get bgColor {
    var data = _getFromDisk(_bgColor);
    if (data != null) {
      return data;
    }
    return '';
  }

  // App Tour
  set isAppTour(bool value) {
    _saveToDisk(_appTour, value);
  }

  bool get isAppTour {
    var data = _getFromDisk(_appTour);
    if (data != null) {
      return data;
    }
    return false;
  }

  // Login  ('Y' = logged in, 'N' = logged out)
  static const String yes = 'Y';
  static const String no = 'N';

  set loginFlag(String value) {
    _saveToDisk(_isLoggedIn, value);
  }

  String get loginFlag {
    var data = _getFromDisk(_isLoggedIn);
    if (data is String && data.isNotEmpty) {
      return data;
    }
    // Backward compatibility with the old boolean flag
    if (data is bool) {
      return data ? yes : no;
    }
    return no;
  }

  set isLogin(bool value) {
    loginFlag = value ? yes : no;
  }

  bool get isLogin => loginFlag == yes;

  // User Details
  set addUser(CustomerData userData) {
    _saveToDisk(_userData, json.encode(userData.toJson()));
  }

  CustomerData? get getUser {
    try {
      String? userData = _getFromDisk(_userData);
      if (userData != null && userData.isNotEmpty) {
        // Additional validation to ensure we have valid JSON data
        if (_isValidJsonString(userData)) {
          return CustomerData.fromJson(jsonDecode(userData));
        } else {
          print('Warning: Invalid JSON data found for user data, clearing corrupted data');
          // Clear corrupted user data
          _preferences?.remove(_userData);
          return null;
        }
      }
      return null;
    } catch (e) {
      print('Error loading user data: $e');
      // Clear corrupted data and return null to prevent app crash
      try {
        _preferences?.remove(_userData);
        print('Cleared corrupted user data');
      } catch (clearError) {
        print('Warning: Could not clear corrupted user data: $clearError');
      }
      return null;
    }
  }

  /// Validate if a string contains valid JSON
  bool _isValidJsonString(String jsonString) {
    if (jsonString.isEmpty) return false;

    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Intended Route for web navigation restoration
  final String _intendedRoute = "IntendedRoute";

  set intendedRoute(String value) {
    _saveToDisk(_intendedRoute, value);
  }

  String get intendedRoute {
    var data = _getFromDisk(_intendedRoute);
    if (data != null) {
      return data;
    }
    return '';
  }

  void clearIntendedRoute() {
    _preferences?.remove(_intendedRoute);
  }

  void callLogout() {
    _preferences?.remove(_token);
    _preferences?.remove(_deviceToken);
    _preferences?.remove(_userData);
    _preferences?.remove(_isLoggedIn);
    loginFlag = no;
  }
}

class CustomerData {
  String? name;
  String? email;
  String? phone;
  String? dob;
  String? gender;

  CustomerData({this.name, this.email, this.phone, this.dob, this.gender});

  CustomerData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    dob = json['dob'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['dob'] = dob;
    data['gender'] = gender;
    return data;
  }
}
