import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/api/api_client.dart';
import 'package:sikhsha_sathi/core/api/api_endpoints.dart';

import 'package:sikhsha_sathi/features/inquiry/data/datasources/inquiry_datasource.dart';
import 'package:sikhsha_sathi/features/inquiry/data/models/inquiry_api_model.dart';

// ================= PROVIDER =================

final inquiryRemoteDatasourceProvider = Provider<IInquiryRemoteDataSource>((ref) {
  return InquiryRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

// ================= IMPLEMENTATION =================

class InquiryRemoteDatasource implements IInquiryRemoteDataSource {
  final ApiClient apiClient;

  InquiryRemoteDatasource({required this.apiClient});

  @override
  Future<InquiryApiModel> createInquiry({
    required String schoolId,
    required String message,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.inquiries,
      data: {
        "schoolId": schoolId,
        "message": message,
      },
    );

    return InquiryApiModel.fromJson(response.data["data"]);
  }

  @override
  Future<List<InquiryApiModel>> getMyInquiries() async {
    final response = await apiClient.get('${ApiEndpoints.inquiries}/my');

    final List<dynamic> data = response.data["data"] ?? [];

    return data.map((j) => InquiryApiModel.fromJson(j)).toList();
  }
}