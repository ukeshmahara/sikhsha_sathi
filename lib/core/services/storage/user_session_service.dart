import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final userSessionServiceProvider =
    Provider<UserSessionService>((ref) {
  final prefs =
      ref.read(sharedPreferencesProvider);

  return UserSessionService(
    prefs: prefs,
  );
});

class UserSessionService {
  final SharedPreferences _prefs;

  UserSessionService({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  static const String _isLoggedIn =
      "is_logged_in";

  static const String _userId =
      "user_id";

  static const String _email =
      "email";

  static const String _fullName =
      "full_name";

  static const String _phoneNumber =
      "phone_number";

  static const String _profilePicture =
      "profile_picture";

  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String fullName,
    String? phoneNumber,
    String? profilePicture,
  }) async {
    await _prefs.setBool(
      _isLoggedIn,
      true,
    );

    await _prefs.setString(
      _userId,
      userId,
    );

    await _prefs.setString(
      _email,
      email,
    );

    await _prefs.setString(
      _fullName,
      fullName,
    );

    if (phoneNumber != null) {
      await _prefs.setString(
        _phoneNumber,
        phoneNumber,
      );
    }

    if (profilePicture != null &&
        profilePicture.isNotEmpty) {
      await _prefs.setString(
        _profilePicture,
        profilePicture,
      );
    }
  }

  // ==========================
  // NEW METHOD
  // ==========================
  Future<void> saveProfilePicture(
    String profilePicture,
  ) async {
    await _prefs.setString(
      _profilePicture,
      profilePicture,
    );
  }

  bool isLoggedIn() {
    return _prefs.getBool(
          _isLoggedIn,
        ) ??
        false;
  }

  String? getUserId() {
    return _prefs.getString(
      _userId,
    );
  }

  String? getEmail() {
    return _prefs.getString(
      _email,
    );
  }

  String? getFullName() {
    return _prefs.getString(
      _fullName,
    );
  }

  String? getPhoneNumber() {
    return _prefs.getString(
      _phoneNumber,
    );
  }

  String? getProfilePicture() {
    return _prefs.getString(
      _profilePicture,
    );
  }

  Future<void> clearProfilePicture() async {
    await _prefs.remove(
      _profilePicture,
    );
  }

  Future<void> clearSession() async {
    await _prefs.remove(
      _isLoggedIn,
    );

    await _prefs.remove(
      _userId,
    );

    await _prefs.remove(
      _email,
    );

    await _prefs.remove(
      _fullName,
    );

    await _prefs.remove(
      _phoneNumber,
    );

    await _prefs.remove(
      _profilePicture,
    );
  }
}