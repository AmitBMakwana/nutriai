import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

/// Provider for [SecureStorageService].
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    webOptions: WebOptions(dbName: 'nutriai_secure', publicKey: 'nutriai_key'),
  );
  return SecureStorageService(storage);
});

/// Wrapper around FlutterSecureStorage for securely persisting authentication
/// tokens and credentials with resilient in-memory fallback for web/testing.
class SecureStorageService {
  final FlutterSecureStorage _storage;
  final Map<String, String> _memoryFallback = {};

  SecureStorageService(this._storage);

  /// Saves the Sanctum bearer authentication token.
  Future<void> saveToken(String token) async {
    _memoryFallback[AppConstants.tokenKey] = token;
    try {
      await _storage.write(key: AppConstants.tokenKey, value: token);
    } catch (e) {
      debugPrint('[SecureStorage] Write token failed, using memory fallback: $e');
    }
  }

  /// Retrieves the saved bearer token, or null if none exists.
  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: AppConstants.tokenKey);
      if (token != null && token.isNotEmpty) return token;
    } catch (e) {
      debugPrint('[SecureStorage] Read token failed, checking fallback: $e');
    }
    return _memoryFallback[AppConstants.tokenKey];
  }

  /// Deletes the saved bearer token.
  Future<void> deleteToken() async {
    _memoryFallback.remove(AppConstants.tokenKey);
    try {
      await _storage.delete(key: AppConstants.tokenKey);
    } catch (_) {}
  }

  /// Checks if a valid token is stored.
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Saves basic user details.
  Future<void> saveUserDetails({
    required String id,
    required String name,
    required String email,
  }) async {
    _memoryFallback[AppConstants.userIdKey] = id;
    _memoryFallback[AppConstants.userNameKey] = name;
    _memoryFallback[AppConstants.userEmailKey] = email;
    try {
      await _storage.write(key: AppConstants.userIdKey, value: id);
      await _storage.write(key: AppConstants.userNameKey, value: name);
      await _storage.write(key: AppConstants.userEmailKey, value: email);
    } catch (_) {}
  }

  /// Retrieves stored user details map.
  Future<Map<String, String?>> getUserDetails() async {
    try {
      final id = await _storage.read(key: AppConstants.userIdKey) ?? _memoryFallback[AppConstants.userIdKey];
      final name = await _storage.read(key: AppConstants.userNameKey) ?? _memoryFallback[AppConstants.userNameKey];
      final email = await _storage.read(key: AppConstants.userEmailKey) ?? _memoryFallback[AppConstants.userEmailKey];
      return {'id': id, 'name': name, 'email': email};
    } catch (_) {
      return {
        'id': _memoryFallback[AppConstants.userIdKey],
        'name': _memoryFallback[AppConstants.userNameKey],
        'email': _memoryFallback[AppConstants.userEmailKey],
      };
    }
  }

  /// Clears all keys stored in secure storage.
  Future<void> clearAll() async {
    _memoryFallback.clear();
    try {
      await _storage.deleteAll();
    } catch (_) {}
  }
}
