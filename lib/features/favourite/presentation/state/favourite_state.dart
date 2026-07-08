import 'package:equatable/equatable.dart';

import 'package:sikhsha_sathi/features/favourite/domain/entities/favourite_entity.dart';

enum FavouriteStatus { initial, loading, loaded, error }

class FavouriteState extends Equatable {
  final FavouriteStatus status;
  final List<FavouriteEntity> favourites;
  final String? errorMessage;

  const FavouriteState({
    this.status = FavouriteStatus.initial,
    this.favourites = const [],
    this.errorMessage,
  });

  bool isFavourite(String schoolId) {
    return favourites.any((f) => f.school.id == schoolId);
  }

  FavouriteState copyWith({
    FavouriteStatus? status,
    List<FavouriteEntity>? favourites,
    String? errorMessage,
  }) {
    return FavouriteState(
      status: status ?? this.status,
      favourites: favourites ?? this.favourites,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, favourites, errorMessage];
}