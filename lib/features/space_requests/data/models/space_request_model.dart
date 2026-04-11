import '../../domain/entities/space_request_entity.dart';

class SpaceRequestModel extends SpaceRequestEntity {
  const SpaceRequestModel({
    required super.requestId,
    required super.spaceName,
    required super.spaceDescription,
    required super.locationDescription,
    required super.phoneNumber,
    required super.whatsappNumber,
    required super.contactName,
    required super.pricePerDay,
    required super.capacity,
    required super.workingHours,
    required super.createdAt,
  });

  factory SpaceRequestModel.fromEntity(SpaceRequestEntity entity) {
    return SpaceRequestModel(
      requestId: entity.requestId,
      spaceName: entity.spaceName,
      spaceDescription: entity.spaceDescription,
      locationDescription: entity.locationDescription,
      phoneNumber: entity.phoneNumber,
      whatsappNumber: entity.whatsappNumber,
      contactName: entity.contactName,
      pricePerDay: entity.pricePerDay,
      capacity: entity.capacity,
      workingHours: entity.workingHours,
      createdAt: entity.createdAt,
    );
  }

  /// Keep Firestore keys backward compatible with existing web data contracts.
  Map<String, dynamic> toMap() {
    return {
      'idRequest': requestId,
      'nameSpace': spaceName,
      'descriptionSpace': spaceDescription,
      'locationDes': locationDescription,
      'phoneNo': phoneNumber,
      'whatsAppNo': whatsappNumber,
      'contactName': contactName,
      'pricePerDay': pricePerDay,
      'capacity': capacity,
      'workingHours': workingHours,
      'createdAt': createdAt,
    };
  }
}
