import 'package:equatable/equatable.dart';

class OfferEntity extends Equatable {
  final String id;
  final String title;
  final String percent;
  final String duration;
  final String terms;
  final bool enabled;

  const OfferEntity({
    required this.id,
    required this.title,
    required this.percent,
    required this.duration,
    required this.terms,
    required this.enabled,
  });

  @override
  List<Object?> get props => [id, title, percent, duration, terms, enabled];
}
