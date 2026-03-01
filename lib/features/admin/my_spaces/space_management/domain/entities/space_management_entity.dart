import 'package:equatable/equatable.dart';

class SpaceManagementEntity extends Equatable {
  final String id;
  final String name;
  final bool hidden;

  const SpaceManagementEntity({
    required this.id,
    required this.name,
    required this.hidden,
  });

  @override
  List<Object?> get props => [id, name, hidden];
}
