import 'package:equatable/equatable.dart';

class PlanOption extends Equatable {
  final String id;
  final String name;
  final String priceLabel;
  final bool isBest;

  const PlanOption({
    required this.id,
    required this.name,
    required this.priceLabel,
    this.isBest = false,
  });

  @override
  List<Object?> get props => [id, name, priceLabel, isBest];
}


