import 'package:equatable/equatable.dart';

enum SpaceAvailability { available, hidden }

class SpaceEntity extends Equatable {
  final String id;
  final String name;
  final String rating;
  final SpaceAvailability availability;
  final String cover; // url or placeholder key

  const SpaceEntity({
    required this.id,
    required this.name,
    required this.rating,
    required this.availability,
    required this.cover,
  });

  @override
  List<Object?> get props => [id, name, rating, availability, cover];
}


