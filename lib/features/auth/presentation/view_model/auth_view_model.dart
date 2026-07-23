import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/services/biometric/biometric_service.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';

import '../../data/datasources/local/auth_local_datasource.dart';
import '../../domain/usecases/get_current_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

import '../state/auth_state.dart';

// Provider
final authViewModelProvider =
NotifierProvider<AuthViewModel, AuthState>(
() => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
late RegisterUsecase _registerUsecase;
late LoginUsecase _loginUsecase;
late GetCurrentUserUsecase _getCurrentUserUsecase;
late BiometricService _biometricService;

@override
AuthState build() {
_registerUsecase =
ref.read(registerUsecaseProvider);


_loginUsecase =
    ref.read(loginUsecaseProvider);

_getCurrentUserUsecase =
    ref.read(getCurrentUserUsecaseProvider);

_biometricService =
    ref.read(biometricServiceProvider);

return const AuthState();

}

// ================= REGISTER =================

Future<void> register({
required String fullName,
required String email,
required String password,
required String phoneNumber,

}) async {
state = state.copyWith(
status: AuthStatus.loading,
);

final params = RegisterUsecaseParams(
  fullName: fullName,
  email: email,
  password: password,
  phoneNumber: phoneNumber,
);

final result =
    await _registerUsecase(params);

result.fold(
  (failure) {
    state = state.copyWith(
      status: AuthStatus.error,
      errorMessage: failure.message,
    );
  },
  (isRegistered) {
    if (isRegistered) {
      state = state.copyWith(
        status: AuthStatus.registered,
      );
    } else {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage:
            "Registration Failed",
      );
    }
  },
);

}

// ================= LOGIN =================

Future<void> login({
required String email,
required String password,
}) async {
state = state.copyWith(
status: AuthStatus.loading,
);

final params = LoginParams(
  email: email,
  password: password,
);

final result =
    await _loginUsecase(params);

result.fold(
  (failure) {
    state = state.copyWith(
      status: AuthStatus.error,
      errorMessage: failure.message,
    );
  },
  (user) {
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
    );
  },
);


}

// ================= BIOMETRIC LOGIN =================
// Restores the session bound to whichever account enabled fingerprint
// login on this device (see UserSessionService.isBiometricLoginEnabled
// for exactly how that binding is scoped, so a different account can't
// inherit it).
//
// Deliberately restores from the LOCAL device cache directly, not via
// GET /auth/whoami — after a logout, the auth token has been correctly
// cleared, so an online whoami call would simply fail with 401. The
// local cache is keyed by the bound account's userId regardless of
// whether there's currently an active session, so this works
// immediately after logging out of that same account.
//
// Note: this restores your identity/profile for DISPLAY purposes using
// only what's cached on-device. If you're offline, other screens that
// need to call the backend (Home, Search, etc.) will still need a real
// network connection before they can load anything, since no fresh
// token can be issued without contacting the server.

Future<void> loginWithBiometric() async {
  final session = ref.read(userSessionServiceProvider);

  if (!session.isBiometricLoginEnabled()) {
    state = state.copyWith(
      status: AuthStatus.error,
      errorMessage:
          "Fingerprint login is not enabled. Enable it from your Profile after logging in normally.",
    );
    return;
  }

  final canUseBiometrics =
      await _biometricService.canCheckBiometrics();

  if (!canUseBiometrics) {
    state = state.copyWith(
      status: AuthStatus.error,
      errorMessage:
          "Fingerprint is not available or not set up on this device.",
    );
    return;
  }

  final authenticated = await _biometricService.authenticate(
    reason: "Scan your fingerprint to log in",
  );

  if (!authenticated) {
    // user cancelled or failed the scan — don't show an error state,
    // just silently stay on the login screen
    return;
  }

  state = state.copyWith(status: AuthStatus.loading);

  final localDatasource = ref.read(authLocalDatasourceProvider);
  final cachedUser = await localDatasource.getCurrentUser();

  if (cachedUser == null) {
    state = state.copyWith(
      status: AuthStatus.error,
      errorMessage:
          "Could not find your saved account on this device. Please log in with your password.",
    );
    return;
  }

  await session.saveUserSession(
    userId: cachedUser.userId,
    email: cachedUser.email,
    fullName: cachedUser.fullName,
    phoneNumber: cachedUser.phoneNumber,
    profilePicture: cachedUser.profilePicture,
  );

  state = state.copyWith(
    status: AuthStatus.authenticated,
    user: cachedUser.toEntity(),
  );
}

// ================= RESET =================

void resetState() {
state = const AuthState();
}
}