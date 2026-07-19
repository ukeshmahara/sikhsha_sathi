import 'package:equatable/equatable.dart';

enum InquiryStatus { pending, responded, closed }

class InquiryEntity extends Equatable {
  final String id;
  final String schoolId;
  final String schoolName;
  final String message;
  final String? reply;
  final InquiryStatus status;
  final DateTime createdAt;

  const InquiryEntity({
    required this.id,
    required this.schoolId,
    required this.schoolName,
    required this.message,
    this.reply,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, schoolId, schoolName, message, reply, status, createdAt];
}