import '../../domain/entities/report_entity.dart';

class ReportModel {
  final String id;
  final String subject;
  final String reason;

  const ReportModel({
    required this.id,
    required this.subject,
    required this.reason,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: (json['id'] ?? '').toString(),
        subject: (json['subject'] ?? '').toString(),
        reason: (json['reason'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {'id': id, 'subject': subject, 'reason': reason};

  ReportModel toEntityModel() => ReportModel(id: id, subject: subject, reason: reason);
}
