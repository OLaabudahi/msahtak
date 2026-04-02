import 'package:equatable/equatable.dart';

class AdminSpaceSummary extends Equatable {
  final String id;
  final String name;

  const AdminSpaceSummary({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
