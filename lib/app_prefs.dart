import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/constants/constants.dart';

const String TOKEN = "token";
const String REFRESH_TOKEN = "refresh_token";
const String EXPIRES_IN = 'expiresIn';

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  final FlutterSecureStorage _secureStorage;

  AppPreferences(this._sharedPreferences, this._secureStorage);

  Future<void> setExpiresIn(int expiresIn) async {
    await _sharedPreferences.setInt(EXPIRES_IN, expiresIn);
  }

  Future<int> getExpiresIn() async {
    return _sharedPreferences.getInt(EXPIRES_IN) ?? Constants.zero;
  }

  Future<void> setToken(String token) async {
    await _secureStorage.write(key: TOKEN, value: token);
  }

  Future<String> getToken() async {
    return await _secureStorage.read(key: TOKEN) ?? Constants.empty;
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: REFRESH_TOKEN, value: refreshToken);
  }

  Future<String> getRefreshToken() async {
    return await _secureStorage.read(key: REFRESH_TOKEN) ?? Constants.empty;
  }
}
