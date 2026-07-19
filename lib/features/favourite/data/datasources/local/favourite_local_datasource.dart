import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/services/hive/hive_service.dart';

import 'package:sikhsha_sathi/features/favourite/data/datasources/favourite_datasource.dart';
import 'package:sikhsha_sathi/features/favourite/data/models/favourite_hive_model.dart';
import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';

// ================= PROVIDER =================

final favouriteLocalDatasourceProvider =
    Provider<IFavouriteLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);

  return FavouriteLocalDatasource(hiveService: hiveService);
});

// ================= DATASOURCE =================

class FavouriteLocalDatasource implements IFavouriteLocalDataSource {
  final HiveService _hiveService;

  FavouriteLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  List<FavouriteEntity> getCachedFavourites() {
    final models = _hiveService.getCachedFavourites();
    return FavouriteHiveModel.toEntityList(models);
  }

  @override
  Future<void> replaceCache(List<FavouriteEntity> favourites) async {
    final models =
        favourites.map((f) => FavouriteHiveModel.fromEntity(f)).toList();

    await _hiveService.replaceCachedFavourites(models);
  }

  @override
  Future<void> cacheFavourite(FavouriteEntity favourite) async {
    await _hiveService.cacheFavourite(
      FavouriteHiveModel.fromEntity(favourite),
    );
  }

  @override
  Future<void> removeCachedFavourite(String schoolId) async {
    await _hiveService.removeCachedFavourite(schoolId);
  }

  @override
  bool isFavouriteCached(String schoolId) {
    return _hiveService.isFavouriteCached(schoolId);
  }

  @override
  Future<void> clearCache() async {
    await _hiveService.clearFavouriteCache();
  }
}