import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract interface class IProfileRepository {

  Future<Either<Failure, String>>
      uploadProfilePicture(
    File image,
  );
}