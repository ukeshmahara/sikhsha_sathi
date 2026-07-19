import 'package:dartz/dartz.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';
import 'package:sikhsha_sathi/features/inquiry/domain/entities/inquiry_entity.dart';

abstract interface class IInquiryRepository {
  Future<Either<Failure, InquiryEntity>> createInquiry({
    required String schoolId,
    required String message,
  });

  Future<Either<Failure, List<InquiryEntity>>> getMyInquiries();
}