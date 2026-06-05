import 'package:dartz/dartz.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';

import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/auth/data/repositories/auth_repository.dart';

import 'package:sikhsha_sathi/features/auth/domain/entities/auth_entity.dart';

import 'package:sikhsha_sathi/features/auth/domain/repositories/auth_repository.dart';

// ================= PARAMS =================

class LoginParams extends Equatable {

  final String email;

  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}

// ================= PROVIDER =================

final loginUsecaseProvider =
    Provider<LoginUsecase>((ref) {

  final repository =
      ref.read(
    authRepositoryProvider,
  );

  return LoginUsecase(
    authRepository: repository,
  );
});

// ================= USECASE =================

class LoginUsecase
    implements
        UsecaseWithParams<
          AuthEntity,
          LoginParams
        > {

  final IAuthRepository
      _authRepository;

  LoginUsecase({
    required IAuthRepository
        authRepository,
  }) : _authRepository =
          authRepository;

  @override
  Future<Either<Failure, AuthEntity>>
      call(
    LoginParams params,
  ) {

    return _authRepository.login(
      params.email,
      params.password,
    );
  }
}