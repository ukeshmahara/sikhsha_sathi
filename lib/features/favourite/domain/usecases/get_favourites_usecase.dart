import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/favourite/data/repositories/favourite_repository.dart';
import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';
import 'package:sikhsha_sathi/features/favourite/domain/repositories/favourite_repository.dart';

// ================= PROVIDER =================

final getFavouritesUsecaseProvider = Provider<GetFavouritesUsecase>((ref) {
  final repository = ref.read(favouriteRepositoryProvider);

  return GetFavouritesUsecase(favouriteRepository: repository);
});

// ================= USECASE =================

class GetFavouritesUsecase
    implements UsecaseWithoutPrams<List<FavouriteEntity>> {
  final IFavouriteRepository _favouriteRepository;

  GetFavouritesUsecase({required IFavouriteRepository favouriteRepository})
      : _favouriteRepository = favouriteRepository;

  @override
  Future<Either<Failure, List<FavouriteEntity>>> call() {
    return _favouriteRepository.getFavourites();
  }
}