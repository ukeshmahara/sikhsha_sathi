import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sikhsha_sathi/core/api/api_client.dart';
import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/core/services/storage/token_service.dart';
import 'package:sikhsha_sathi/features/profile/data/datasources/profile_datasource.dart';
import 'package:sikhsha_sathi/features/profile/domain/entities/profile_update_result.dart';

final profileRemoteDatasourceProvider =
    Provider<IProfileRemoteDataSource>(
  (ref) => ProfileRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  ),
);

class ProfileRemoteDatasource
    implements IProfileRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ProfileRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<String> uploadProfilePicture(
    File image,
  ) async {
    final fileName =
        image.path.split('/').last;

    final formData =
        FormData.fromMap({
      'profileImage':
          await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      ),
    });

    final token =
        _tokenService.getToken();

    final response =
        await _apiClient.patch(
      ApiEndpoints.profilePicture,
      data: formData,
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
        },
      ),
    );

    return response
        .data['data']['profileImage'];
  }

  // Same PATCH /auth/update endpoint as uploadProfilePicture, but for
  // fullName/phone/password instead of the image. The backend's Multer
  // middleware (uploadMiddleware.single) happily accepts a multipart
  // request with no file attached — req.file is just undefined then.
  @override
  Future<ProfileUpdateResult> updateProfile({
    String? fullName,
    String? phone,
    String? currentPassword,
    String? newPassword,
  }) async {
    final formData = FormData.fromMap({
      if (fullName != null) 'fullName': fullName,
      if (phone != null) 'phone': phone,
      if (currentPassword != null) 'currentPassword': currentPassword,
      if (newPassword != null) 'newPassword': newPassword,
    });

    final token = _tokenService.getToken();

    final response = await _apiClient.patch(
      ApiEndpoints.profilePicture, // same '/auth/update' endpoint
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return ProfileUpdateResult.fromJson(response.data['data']);
  }
}