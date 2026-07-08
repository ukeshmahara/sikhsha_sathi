import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/favourite/data/repositories/favourite_repository.dart';
import 'package:sikhsha_sathi/features/favourite/domain/repositories/favourite_repository.dart';

// ================= PROVIDER =================

final removeFavouriteUsecaseProvider = Provider<RemoveFavouriteUsecase>((ref) {
  final repository = ref.read(favouriteRepositoryProvider);

  return RemoveFavouriteUsecase(favouriteRepository: repository);
});

// ================= USECASE =================

class RemoveFavouriteUsecase implements UsecaseWithParams<bool, String> {
  final IFavouriteRepository _favouriteRepository;

  RemoveFavouriteUsecase({required IFavouriteRepository favouriteRepository})
      : _favouriteRepository = favouriteRepository;

  @override
  Future<Either<Failure, bool>> call(String schoolId) {
    return _favouriteRepository.removeFavourite(schoolId);
  }
}