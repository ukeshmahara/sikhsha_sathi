import 'package:sikhsha_sathi/features/favourite/data/models/favourite_api_model.dart';
import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';

abstract interface class IFavouriteLocalDataSource {
  List<FavouriteEntity> getCachedFavourites();

  Future<void> replaceCache(List<FavouriteEntity> favourites);

  Future<void> cacheFavourite(FavouriteEntity favourite);

  Future<void> removeCachedFavourite(String schoolId);

  bool isFavouriteCached(String schoolId);
}

abstract interface class IFavouriteRemoteDataSource {
  Future<List<FavouriteApiModel>> getFavourites();

  Future<bool> addFavourite(String schoolId);

  Future<bool> removeFavourite(String schoolId);
}