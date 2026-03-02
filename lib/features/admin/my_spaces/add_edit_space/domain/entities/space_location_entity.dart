import 'package:equatable/equatable.dart';

class SpaceLocationEntity extends Equatable {
  final double lat;
  final double lng;

  const SpaceLocationEntity({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}
