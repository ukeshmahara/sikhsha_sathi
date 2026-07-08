import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/add_favourite_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/get_favourites_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/domain/usecases/remove_favourite_usecase.dart';
import 'package:sikhsha_sathi/features/favourite/presentation/state/favourite_state.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

// ================= PROVIDER =================

final favouriteViewModelProvider =
    NotifierProvider<FavouriteViewModel, FavouriteState>(
  FavouriteViewModel.new,
);

// ================= VIEWMODEL =================

class FavouriteViewModel extends Notifier<FavouriteState> {
  late final GetFavouritesUsecase _getFavouritesUsecase;
  late final AddFavouriteUsecase _addFavouriteUsecase;
  late final RemoveFavouriteUsecase _removeFavouriteUsecase;

  @override
  FavouriteState build() {
    _getFavouritesUsecase = ref.read(getFavouritesUsecaseProvider);
    _addFavouriteUsecase = ref.read(addFavouriteUsecaseProvider);
    _removeFavouriteUsecase = ref.read(removeFavouriteUsecaseProvider);

    return const FavouriteState();
  }

  Future<void> loadFavourites() async {
    state = state.copyWith(status: FavouriteStatus.loading, errorMessage: null);

    final result = await _getFavouritesUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: FavouriteStatus.error,
        errorMessage: failure.message,
      ),
      (favourites) => state = state.copyWith(
        status: FavouriteStatus.loaded,
        favourites: favourites,
      ),
    );
  }

  // Takes the full SchoolEntity (not just the id) so a successful add/remove
  // can update the list locally and instantly — no second API round trip,
  // no lag waiting for a full refetch, no chance of the heart icon going
  // stale if that refetch happens to fail or run slowly.
  Future<bool> toggleFavourite(SchoolEntity school) async {
    final schoolId = school.id;

    if (schoolId == null) return false;

    final alreadyFavourited = state.isFavourite(schoolId);

    if (alreadyFavourited) {
      final result = await _removeFavouriteUsecase(schoolId);

      return result.fold(
        (failure) {
          state = state.copyWith(errorMessage: failure.message);
          return false;
        },
        (_) {
          final updated = state.favourites
              .where((f) => f.school.id != schoolId)
              .toList();

          state = state.copyWith(favourites: updated, errorMessage: null);
          return true;
        },
      );
    } else {
      final result = await _addFavouriteUsecase(schoolId);

      return result.fold(
        (failure) {
          state = state.copyWith(errorMessage: failure.message);
          return false;
        },
        (_) {
          final updated = [
            ...state.favourites,
            FavouriteEntity(school: school),
          ];

          state = state.copyWith(favourites: updated, errorMessage: null);
          return true;
        },
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}