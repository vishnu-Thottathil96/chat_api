import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> storeTokens(
      {required String refreshToken, required String accessToken}) async {
    await _storage.write(key: 'refreshToken', value: refreshToken);
    await _storage.write(key: 'accessToken', value: accessToken);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  static Future<void> deleteAllTokens() async {
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'accessToken');
  }
}
