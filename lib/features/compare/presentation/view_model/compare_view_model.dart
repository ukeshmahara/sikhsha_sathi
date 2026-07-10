import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/compare/presentation/state/compare_state.dart';
import 'package:sikhsha_sathi/features/school/domain/entities/school_entity.dart';

// ================= PROVIDER =================

final compareViewModelProvider =
    NotifierProvider<CompareViewModel, CompareState>(CompareViewModel.new);

// ================= VIEWMODEL =================

class CompareViewModel extends Notifier<CompareState> {
  @override
  CompareState build() {
    return const CompareState();
  }

  void selectSchool1(SchoolEntity school) {
    state = state.copyWith(school1: school);
  }

  void selectSchool2(SchoolEntity school) {
    state = state.copyWith(school2: school);
  }

  void removeSchool1() {
    state = state.copyWith(clearSchool1: true);
  }

  void removeSchool2() {
    state = state.copyWith(clearSchool2: true);
  }

  void reset() {
    state = const CompareState();
  }
}