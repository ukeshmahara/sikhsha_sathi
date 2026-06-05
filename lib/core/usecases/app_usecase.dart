import 'package:dartz/dartz.dart';

import 'package:sikhsha_sathi/core/error/failures.dart';

abstract interface class UsecaseWithParams<
    SuccessType,
    Params> {

  Future<Either<Failure, SuccessType>>
      call(
    Params params,
  );
}

abstract interface class UsecaseWithoutPrams<
    SuccessType> {

  Future<Either<Failure, SuccessType>>
      call();
}