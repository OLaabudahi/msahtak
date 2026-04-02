import 'package:equatable/equatable.dart';

class KpiEntity extends Equatable {
  final String id;
  final String title;
  final String value;
  final String delta; 

  const KpiEntity({
    required this.id,
    required this.title,
    required this.value,
    required this.delta,
  });

  @override
  List<Object?> get props => [id, title, value, delta];
}


