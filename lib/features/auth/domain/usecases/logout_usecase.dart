import 'package:dartz/dartz.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';

import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/auth/data/repositories/auth_repository.dart';

import 'package:sikhsha_sathi/features/auth/domain/repositories/auth_repository.dart';

// ================= PROVIDER =================

final logoutUsecaseProvider =
    Provider<LogoutUsecase>((ref) {

  final repository =
      ref.read(
    authRepositoryProvider,
  );

  return LogoutUsecase(
    authRepository: repository,
  );
});

// ================= USECASE =================

class LogoutUsecase
    implements
        UsecaseWithoutPrams<bool> {

  final IAuthRepository
      _authRepository;

  LogoutUsecase({
    required IAuthRepository
        authRepository,
  }) : _authRepository =
          authRepository;

  @override
  Future<Either<Failure, bool>>
      call() {

    return _authRepository
        .logout();
  }
}