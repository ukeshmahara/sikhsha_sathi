import 'package:equatable/equatable.dart';

import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

class CompareState extends Equatable {
  final SchoolEntity? school1;
  final SchoolEntity? school2;

  const CompareState({
    this.school1,
    this.school2,
  });

  bool get isComplete => school1 != null && school2 != null;

  CompareState copyWith({
    SchoolEntity? school1,
    SchoolEntity? school2,
    bool clearSchool1 = false,
    bool clearSchool2 = false,
  }) {
    return CompareState(
      school1: clearSchool1 ? null : (school1 ?? this.school1),
      school2: clearSchool2 ? null : (school2 ?? this.school2),
    );
  }

  @override
  List<Object?> get props => [school1, school2];
}