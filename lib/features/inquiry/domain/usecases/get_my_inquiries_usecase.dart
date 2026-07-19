import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/inquiry/data/repositories/inquiry_repository.dart';
import 'package:sikhsha_sathi/features/inquiry/domain/entities/inquiry_entity.dart';
import 'package:sikhsha_sathi/features/inquiry/domain/repositories/inquiry_repository.dart';

// ================= PROVIDER =================

final getMyInquiriesUsecaseProvider = Provider<GetMyInquiriesUsecase>((ref) {
  final repository = ref.read(inquiryRepositoryProvider);

  return GetMyInquiriesUsecase(inquiryRepository: repository);
});

// ================= USECASE =================

class GetMyInquiriesUsecase
    implements UsecaseWithoutPrams<List<InquiryEntity>> {
  final IInquiryRepository _inquiryRepository;

  GetMyInquiriesUsecase({required IInquiryRepository inquiryRepository})
      : _inquiryRepository = inquiryRepository;

  @override
  Future<Either<Failure, List<InquiryEntity>>> call() {
    return _inquiryRepository.getMyInquiries();
  }
}