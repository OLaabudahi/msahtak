import 'package:equatable/equatable.dart';

class UsageBookingEntity extends Equatable {
  final String id;
  final String spaceId;
  final String planType;
  final DateTime? startDate;
  final DateTime? endDate;

  const UsageBookingEntity({
    required this.id,
    required this.spaceId,
    required this.planType,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [id, spaceId, planType, startDate, endDate];
}
