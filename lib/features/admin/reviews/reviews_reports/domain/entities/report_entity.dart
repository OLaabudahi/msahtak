import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  final String id;
  final String subject;
  final String reason;

  const ReportEntity({
    required this.id,
    required this.subject,
    required this.reason,
  });

  @override
  List<Object?> get props => [id, subject, reason];
}
