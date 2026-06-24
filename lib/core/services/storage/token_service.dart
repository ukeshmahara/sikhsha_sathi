import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_session_service.dart';

// Provider
final tokenServiceProvider =
    Provider<TokenService>((ref) {
  final prefs =
      ref.read(sharedPreferencesProvider);

  return TokenService(
    prefs: prefs,
  );
});

class TokenService {
  final SharedPreferences _prefs;

  static const String _tokenKey =
      'auth_token';

  TokenService({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  // Save Token
  Future<void> saveToken(
    String token,
  ) async {
    await _prefs.setString(
      _tokenKey,
      token,
    );
  }

  // Get Token
  String? getToken() {
    return _prefs.getString(
      _tokenKey,
    );
  }

  // Remove Token
  Future<void> removeToken() async {
    await _prefs.remove(
      _tokenKey,
    );
  }
}