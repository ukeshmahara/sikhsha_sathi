import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/favourite/data/repositories/favourite_repository.dart';
import 'package:sikhsha_sathi/features/favourite/domain/repositories/favourite_repository.dart';

// ================= PROVIDER =================

final addFavouriteUsecaseProvider = Provider<AddFavouriteUsecase>((ref) {
  final repository = ref.read(favouriteRepositoryProvider);

  return AddFavouriteUsecase(favouriteRepository: repository);
});

// ================= USECASE =================

class AddFavouriteUsecase implements UsecaseWithParams<bool, String> {
  final IFavouriteRepository _favouriteRepository;

  AddFavouriteUsecase({required IFavouriteRepository favouriteRepository})
      : _favouriteRepository = favouriteRepository;

  @override
  Future<Either<Failure, bool>> call(String schoolId) {
    return _favouriteRepository.addFavourite(schoolId);
  }
}