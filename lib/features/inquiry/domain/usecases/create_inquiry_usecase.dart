import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/core/usecases/app_usecase.dart';

import 'package:sikhsha_sathi/features/inquiry/data/repositories/inquiry_repository.dart';
import 'package:sikhsha_sathi/features/inquiry/domain/entities/inquiry_entity.dart';
import 'package:sikhsha_sathi/features/inquiry/domain/repositories/inquiry_repository.dart';

// ================= PARAMS =================

class CreateInquiryParams {
  final String schoolId;
  final String message;

  const CreateInquiryParams({
    required this.schoolId,
    required this.message,
  });
}

// ================= PROVIDER =================

final createInquiryUsecaseProvider = Provider<CreateInquiryUsecase>((ref) {
  final repository = ref.read(inquiryRepositoryProvider);

  return CreateInquiryUsecase(inquiryRepository: repository);
});

// ================= USECASE =================

class CreateInquiryUsecase
    implements UsecaseWithParams<InquiryEntity, CreateInquiryParams> {
  final IInquiryRepository _inquiryRepository;

  CreateInquiryUsecase({required IInquiryRepository inquiryRepository})
      : _inquiryRepository = inquiryRepository;

  @override
  Future<Either<Failure, InquiryEntity>> call(CreateInquiryParams params) {
    return _inquiryRepository.createInquiry(
      schoolId: params.schoolId,
      message: params.message,
    );
  }
}