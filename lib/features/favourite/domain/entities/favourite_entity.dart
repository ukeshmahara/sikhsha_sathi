import 'package:equatable/equatable.dart';

import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

class FavouriteEntity extends Equatable {
  final String? id; // favourite record id (from backend)
  final SchoolEntity school;

  const FavouriteEntity({
    this.id,
    required this.school,
  });

  @override
  List<Object?> get props => [id, school];
}