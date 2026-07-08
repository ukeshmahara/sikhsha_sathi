import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_client.dart';
import 'package:sikhsha_sathi/core/api/api_endpoints.dart';

import 'package:sikhsha_sathi/features/favourite/data/datasources/favourite_datasource.dart';
import 'package:sikhsha_sathi/features/favourite/data/models/favourite_api_model.dart';

// ================= PROVIDER =================

final favouriteRemoteDatasourceProvider =
    Provider<IFavouriteRemoteDataSource>((ref) {
  return FavouriteRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

// ================= IMPLEMENTATION =================

class FavouriteRemoteDatasource implements IFavouriteRemoteDataSource {
  final ApiClient apiClient;

  FavouriteRemoteDatasource({required this.apiClient});

  @override
  Future<List<FavouriteApiModel>> getFavourites() async {
    final response = await apiClient.get(ApiEndpoints.favourites);

    final List<dynamic> data = response.data["data"] ?? [];

    return data.map((json) => FavouriteApiModel.fromJson(json)).toList();
  }

  @override
  Future<bool> addFavourite(String schoolId) async {
    final response = await apiClient.post(
      ApiEndpoints.favourites,
      data: {"schoolId": schoolId},
    );

    return response.data["success"] == true;
  }

  @override
  Future<bool> removeFavourite(String schoolId) async {
    final response = await apiClient.delete(
      '${ApiEndpoints.favourites}/$schoolId',
    );

    return response.data["success"] == true;
  }
}