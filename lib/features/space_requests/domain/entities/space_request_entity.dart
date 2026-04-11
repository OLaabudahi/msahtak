import 'package:equatable/equatable.dart';

class SpaceRequestEntity extends Equatable {
  final String requestId;
  final String spaceName;
  final String spaceDescription;
  final String locationDescription;
  final String phoneNumber;
  final String whatsappNumber;
  final String contactName;
  final double pricePerDay;
  final int capacity;
  final String workingHours;
  final DateTime createdAt;

  const SpaceRequestEntity({
    required this.requestId,
    required this.spaceName,
    required this.spaceDescription,
    required this.locationDescription,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.contactName,
    required this.pricePerDay,
    required this.capacity,
    required this.workingHours,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        requestId,
        spaceName,
        spaceDescription,
        locationDescription,
        phoneNumber,
        whatsappNumber,
        contactName,
        pricePerDay,
        capacity,
        workingHours,
        createdAt,
      ];
}
