import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/hive_table_constant.dart';
import '../../domain/entities/auth_entity.dart';

part 'auth_hive_model.g.dart';

@HiveType(
  typeId: HiveTableConstant.authTypeId,
)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String? phoneNumber;

  AuthHiveModel({
    String? userId,
    required this.fullName,
    required this.email,
    required this.password,
    this.phoneNumber,
  }) : userId = userId ?? const Uuid().v4();

  // Entity -> Hive Model
  factory AuthHiveModel.fromEntity(
    AuthEntity entity,
  ) {
    return AuthHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
    );
  }

  // Hive Model -> Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
  }

  static List<AuthEntity> toEntityList(
    List<AuthHiveModel> models,
  ) {
    return models
        .map((model) => model.toEntity())
        .toList();
  }
}