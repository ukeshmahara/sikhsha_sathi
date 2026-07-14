import 'package:dartz/dartz.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';

abstract interface class IFavouriteRepository {
  Future<Either<Failure, List<FavouriteEntity>>> getFavourites();

  Future<Either<Failure, bool>> addFavourite(String schoolId);

  Future<Either<Failure, bool>> removeFavourite(String schoolId);

  Future<void> clearLocalCache();
}