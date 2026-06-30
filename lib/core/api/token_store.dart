import 'package:shared_preferences/shared_preferences.dart';

abstract interface class TokenStore {
  Future<String?> readAccessToken();
  Future<void> writeAccessToken(String token);
  Future<void> clearAccessToken();
}

class SharedPreferencesTokenStore implements TokenStore {
  const SharedPreferencesTokenStore(this._preferences);

  static const _accessTokenKey = 'mogusync.accessToken';

  final SharedPreferences _preferences;

  @override
  Future<String?> readAccessToken() async {
    return _preferences.getString(_accessTokenKey);
  }

  @override
  Future<void> writeAccessToken(String token) async {
    await _preferences.setString(_accessTokenKey, token);
  }

  @override
  Future<void> clearAccessToken() async {
    await _preferences.remove(_accessTokenKey);
  }
}
