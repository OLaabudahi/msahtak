import 'package:equatable/equatable.dart';

class FilterChipEntity extends Equatable {
  final String id;
  final String label;

  const FilterChipEntity({
    required this.id,
    required this.label,
  });

  @override
  List<Object?> get props => [id, label];
}
