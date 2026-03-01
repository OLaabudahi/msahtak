import 'package:equatable/equatable.dart';

class AmenityEntity extends Equatable {
  final String id;
  final String name;
  final bool selected;

  const AmenityEntity({required this.id, required this.name, required this.selected});

  @override
  List<Object?> get props => [id, name, selected];
}
