import '../../domain/entities/space_location_entity.dart';

class SpaceLocationModel {
  final double lat;
  final double lng;

  const SpaceLocationModel({required this.lat, required this.lng});

  factory SpaceLocationModel.fromJson(Map<String, dynamic> json) => SpaceLocationModel(
        lat: (json['lat'] as num?)?.toDouble() ?? 0,
        lng: (json['lng'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};

  SpaceLocationEntity toEntity() => SpaceLocationEntity(lat: lat, lng: lng);

  static SpaceLocationModel fromEntity(SpaceLocationEntity e) => SpaceLocationModel(lat: e.lat, lng: e.lng);
}


