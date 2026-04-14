import 'package:equatable/equatable.dart';

class UsageSpaceEntity extends Equatable {
  final String id;
  final String name;
  final int pricePerDay;
  final List<Map<String, dynamic>> offers;
  final List<String> features;

  const UsageSpaceEntity({
    required this.id,
    required this.name,
    required this.pricePerDay,
    required this.offers,
    required this.features,
  });

  @override
  List<Object?> get props => [id, name, pricePerDay, offers, features];
}
