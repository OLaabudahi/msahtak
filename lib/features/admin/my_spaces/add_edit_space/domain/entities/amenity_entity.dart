import 'package:equatable/equatable.dart';

class AmenityEntity extends Equatable {
  final String id;
  final String name;
  final bool selected;

  
  final bool isCustom;

  const AmenityEntity({
    required this.id,
    required this.name,
    required this.selected,
    required this.isCustom,
  });

  @override
  List<Object?> get props => [id, name, selected, isCustom];
}


