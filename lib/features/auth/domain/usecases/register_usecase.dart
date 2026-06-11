import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/auth/data/repositories/auth_repository.dart';

import 'package:sikhsha_sathi/features/auth/domain/entities/auth_entity.dart';
import 'package:sikhsha_sathi/features/auth/domain/repositories/auth_repository.dart';

// ================= PARAMS =================

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        fullName,
        email,
        password,
        phoneNumber,
      ];
}

// ================= PROVIDER =================

final registerUsecaseProvider =
    Provider<RegisterUsecase>((ref) {
  final repository =
      ref.read(authRepositoryProvider);

  return RegisterUsecase(
    authRepository: repository,
  );
});

// ================= USECASE =================

class RegisterUsecase
    implements
        UsecaseWithParams<
          bool,
          RegisterUsecaseParams
        > {
  final IAuthRepository
      _authRepository;

  RegisterUsecase({
    required IAuthRepository
        authRepository,
  }) : _authRepository =
          authRepository;

  @override
  Future<Either<Failure, bool>>
      call(
    RegisterUsecaseParams params,
  ) {
    final entity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      phoneNumber: params.phoneNumber,
    );

    return _authRepository
        .register(entity);
  }
}