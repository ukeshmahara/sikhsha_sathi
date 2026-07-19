import 'package:equatable/equatable.dart';

import 'package:sikhsha_sathi/features/inquiry/domain/entities/inquiry_entity.dart';

enum InquiryLoadStatus { initial, loading, loaded, error }
enum InquirySubmitStatus { idle, submitting, success, error }

class InquiryState extends Equatable {
  final InquiryLoadStatus loadStatus;
  final InquirySubmitStatus submitStatus;
  final List<InquiryEntity> inquiries;
  final String? errorMessage;

  const InquiryState({
    this.loadStatus = InquiryLoadStatus.initial,
    this.submitStatus = InquirySubmitStatus.idle,
    this.inquiries = const [],
    this.errorMessage,
  });

  InquiryState copyWith({
    InquiryLoadStatus? loadStatus,
    InquirySubmitStatus? submitStatus,
    List<InquiryEntity>? inquiries,
    String? errorMessage,
  }) {
    return InquiryState(
      loadStatus: loadStatus ?? this.loadStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      inquiries: inquiries ?? this.inquiries,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [loadStatus, submitStatus, inquiries, errorMessage];
}