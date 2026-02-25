import 'package:equatable/equatable.dart';

class FilterChipEntity extends Equatable {
  final String id; // unique (e.g. "quiet", "wifi_fast", "price_max_40")
  final String label;

  const FilterChipEntity({
    required this.id,
    required this.label,
  });

  @override
  List<Object?> get props => [id, label];
}