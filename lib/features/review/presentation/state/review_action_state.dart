import 'package:equatable/equatable.dart';

enum ReviewActionStatus { idle, submitting, success, error }

class ReviewActionState extends Equatable {
  final ReviewActionStatus status;
  final String? errorMessage;

  const ReviewActionState({
    this.status = ReviewActionStatus.idle,
    this.errorMessage,
  });

  ReviewActionState copyWith({
    ReviewActionStatus? status,
    String? errorMessage,
  }) {
    return ReviewActionState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}