import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Penyimpanan token auth memakai `flutter_secure_storage` (sesuai CLAUDE.md
/// §Stack & §Rule 2 — token TIDAK boleh di SharedPreferences).
class TokenStorage {
  static const String _tokenKey = 'auth_token';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  static Future<String?> getToken() => _storage.read(key: _tokenKey);

  static Future<void> clearToken() => _storage.delete(key: _tokenKey);

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
