import 'package:dartz/dartz.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';

import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/auth/data/repositories/auth_repository.dart';

import 'package:sikhsha_sathi/features/auth/domain/entities/auth_entity.dart';

import 'package:sikhsha_sathi/features/auth/domain/repositories/auth_repository.dart';

// ================= PARAMS =================

class CurrentUserParams
    extends Equatable {

  const CurrentUserParams();

  @override
  List<Object?> get props => [];
}

// ================= PROVIDER =================

final getCurrentUserUsecaseProvider =
    Provider<GetCurrentUserUsecase>(
  (ref) {

    final repository =
        ref.read(
      authRepositoryProvider,
    );

    return GetCurrentUserUsecase(
      authRepository: repository,
    );
  },
);

// ================= USECASE =================

class GetCurrentUserUsecase
    implements
        UsecaseWithParams<
          AuthEntity,
          CurrentUserParams
        > {

  final IAuthRepository
      _authRepository;

  GetCurrentUserUsecase({
    required IAuthRepository
        authRepository,
  }) : _authRepository =
          authRepository;

  @override
  Future<Either<Failure, AuthEntity>>
      call(
    CurrentUserParams params,
  ) {

    return _authRepository
        .getCurrentUser();
  }
}