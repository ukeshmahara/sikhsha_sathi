import 'package:sikhsha_sathi/features/inquiry/domain/entities/inquiry_entity.dart';

class InquiryApiModel {
  final String id;
  final String schoolId;
  final String schoolName;
  final String message;
  final String? reply;
  final InquiryStatus status;
  final DateTime createdAt;

  InquiryApiModel({
    required this.id,
    required this.schoolId,
    required this.schoolName,
    required this.message,
    this.reply,
    required this.status,
    required this.createdAt,
  });

  InquiryEntity toEntity() {
    return InquiryEntity(
      id: id,
      schoolId: schoolId,
      schoolName: schoolName,
      message: message,
      reply: reply,
      status: status,
      createdAt: createdAt,
    );
  }

  static InquiryStatus _parseStatus(String? value) {
    switch (value) {
      case 'responded':
        return InquiryStatus.responded;
      case 'closed':
        return InquiryStatus.closed;
      default:
        return InquiryStatus.pending;
    }
  }

  factory InquiryApiModel.fromJson(Map<String, dynamic> json) {
    // schoolId may come back populated as { "_id": "...", "name": "..." }
    // on GET /inquiries/my, or as a plain string id on POST /inquiries
    // (create doesn't populate).
    final schoolField = json["schoolId"];
    String schoolId;
    String schoolName;

    if (schoolField is Map<String, dynamic>) {
      schoolId = schoolField["_id"] ?? '';
      schoolName = schoolField["name"] ?? '';
    } else {
      schoolId = schoolField?.toString() ?? '';
      schoolName = '';
    }

    return InquiryApiModel(
      id: json["_id"] ?? json["id"] ?? '',
      schoolId: schoolId,
      schoolName: schoolName,
      message: json["message"] ?? '',
      reply: json["adminReply"],
      status: _parseStatus(json["status"]),
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
    );
  }
}