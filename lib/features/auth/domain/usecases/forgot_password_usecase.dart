import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/auth/data/repositories/auth_repository.dart';
import 'package:sikhsha_sathi/features/auth/domain/repositories/auth_repository.dart';

// ================= PROVIDER =================

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);

  return ForgotPasswordUsecase(authRepository: repository);
});

// ================= USECASE =================

class ForgotPasswordUsecase implements UsecaseWithParams<bool, String> {
  final IAuthRepository _authRepository;

  ForgotPasswordUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(String email) {
    return _authRepository.forgotPassword(email);
  }
}