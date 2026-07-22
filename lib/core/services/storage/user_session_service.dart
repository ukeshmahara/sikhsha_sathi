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

  // The specific account fingerprint login is bound to on this device.
  // Set/cleared ONLY by the explicit toggle in Profile — never touched
  // by clearSession() — so it correctly survives a logout for the SAME
  // account, but never gets read as "enabled" for a DIFFERENT account.
  static const String _biometricUserId =
      "biometric_user_id";

  // Whoever most recently completed a real login on this device
  // (normal password login, or a successful biometric restore).
  // Also survives clearSession() — this is what we compare against
  // _biometricUserId to decide whether to actually show the
  // fingerprint button on the Login screen.
  static const String _lastLoggedInUserId =
      "last_logged_in_user_id";

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

    // track this as the most recent successful login on this device,
    // regardless of how it happened (password or biometric restore)
    await _prefs.setString(
      _lastLoggedInUserId,
      userId,
    );
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

  // Called by Profile's fingerprint toggle. Enabling binds fingerprint
  // login to THIS specific account (userId required) — so it can never
  // be silently inherited by a different account that logs in later on
  // the same device. Disabling un-binds it entirely.
  Future<void> setBiometricLoginEnabled(
    bool enabled, {
    String? userId,
  }) async {
    if (enabled && userId != null) {
      await _prefs.setString(_biometricUserId, userId);
    } else {
      await _prefs.remove(_biometricUserId);
    }
  }

  // True only when fingerprint is bound to the SAME account that most
  // recently logged in on this device. This is what makes the button:
  //  - correctly reappear after the SAME account logs back out and in
  //  - correctly stay hidden for a DIFFERENT account that never
  //    enabled it themselves
  bool isBiometricLoginEnabled() {
    final boundUserId = _prefs.getString(_biometricUserId);
    final lastUserId = _prefs.getString(_lastLoggedInUserId);

    return boundUserId != null && boundUserId == lastUserId;
  }

  String? getBiometricUserId() {
    return _prefs.getString(_biometricUserId);
  }

  // Clears the ACTIVE session only — deliberately does NOT touch
  // _biometricUserId or _lastLoggedInUserId, since both need to persist
  // through logout for fingerprint login to work at all afterward.
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