import '../../domain/entities/space_request_entity.dart';

class SpaceRequestModel extends SpaceRequestEntity {
SpaceRequestModel({
required super.idRequest,
required super.nameSpace,
required super.descriptionSpace,
required super.locationDes,
required super.phoneNo,
required super.whatsAppNo,
required super.contactName,
required super.pricePerDay,
required super.capacity,
required super.workingHours,
required super.createdAt,
});

Map<String, dynamic> toMap() {
return {
"idRequest": idRequest,
"nameSpace": nameSpace,
"descriptionSpace": descriptionSpace,
"locationDes": locationDes,
"phoneNo": phoneNo,
"whatsAppNo": whatsAppNo,
"contactName": contactName,
"pricePerDay": pricePerDay,
"capacity": capacity,
"workingHours": workingHours,
"createdAt": createdAt,
};
}
}


