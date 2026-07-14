import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/services/biometric/biometric_service.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';

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
// Requires the user to have logged in successfully at least once before
// (so a valid token + session is already cached), and to have opted in
// via the toggle in Profile. This does NOT create a new session — it
// just unlocks the one that's already saved on the device using
// GET /auth/whoami with the cached token.

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

  final result = await _getCurrentUserUsecase(const CurrentUserParams());

  result.fold(
    (failure) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage:
            "Session check failed: ${failure.message}",
      );
    },
    (user) async {
      // biometric login goes through GET /auth/whoami, which never
      // touches UserSessionService the way a normal password login does
      // (that happens inside auth_remote_datasource.dart's login()) —
      // without this, ProfileTab/HomeTab keep showing whatever was left
      // over from before logout (or nothing at all).
      await session.saveUserSession(
        userId: user.userId ?? "",
        email: user.email,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
        profilePicture: user.profilePicture,
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );
    },
  );
}

// ================= RESET =================

void resetState() {
state = const AuthState();
}
}