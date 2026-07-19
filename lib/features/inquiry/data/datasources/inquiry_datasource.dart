import 'package:sikhsha_sathi/features/inquiry/data/models/inquiry_api_model.dart';

abstract interface class IInquiryRemoteDataSource {
  Future<InquiryApiModel> createInquiry({
    required String schoolId,
    required String message,
  });

  Future<List<InquiryApiModel>> getMyInquiries();
}