import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

import '../state/auth_state.dart';

// Provider
final authViewModelProvider =
NotifierProvider<AuthViewModel, AuthState>(
() => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
late final RegisterUsecase _registerUsecase;
late final LoginUsecase _loginUsecase;

@override
AuthState build() {
_registerUsecase =
ref.read(registerUsecaseProvider);


_loginUsecase =
    ref.read(loginUsecaseProvider);

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

await Future.delayed(
  const Duration(seconds: 2),
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

await Future.delayed(
  const Duration(seconds: 2),
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

// ================= RESET =================

void resetState() {
state = const AuthState();
}
}
