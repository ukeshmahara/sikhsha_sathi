import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/inquiry/domain/usecases/create_inquiry_usecase.dart';
import 'package:sikhsha_sathi/features/inquiry/domain/usecases/get_my_inquiries_usecase.dart';
import 'package:sikhsha_sathi/features/inquiry/presentation/state/inquiry_state.dart';

final inquiryViewModelProvider =
    NotifierProvider<InquiryViewModel, InquiryState>(InquiryViewModel.new);

class InquiryViewModel extends Notifier<InquiryState> {
  late CreateInquiryUsecase _createInquiryUsecase;
  late GetMyInquiriesUsecase _getMyInquiriesUsecase;

  @override
  InquiryState build() {
    _createInquiryUsecase = ref.read(createInquiryUsecaseProvider);
    _getMyInquiriesUsecase = ref.read(getMyInquiriesUsecaseProvider);
    return const InquiryState();
  }

  Future<void> loadMyInquiries() async {
    state = state.copyWith(loadStatus: InquiryLoadStatus.loading);

    final result = await _getMyInquiriesUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        loadStatus: InquiryLoadStatus.error,
        errorMessage: failure.message,
      ),
      (inquiries) => state = state.copyWith(
        loadStatus: InquiryLoadStatus.loaded,
        inquiries: inquiries,
      ),
    );
  }

  Future<bool> submitInquiry({
    required String schoolId,
    required String message,
  }) async {
    state = state.copyWith(
      submitStatus: InquirySubmitStatus.submitting,
      errorMessage: null,
    );

    final result = await _createInquiryUsecase(
      CreateInquiryParams(schoolId: schoolId, message: message),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          submitStatus: InquirySubmitStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(submitStatus: InquirySubmitStatus.success);
        // refresh so the new question shows immediately
        loadMyInquiries();
        return true;
      },
    );
  }
}