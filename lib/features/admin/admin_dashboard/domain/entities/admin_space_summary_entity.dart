import 'package:equatable/equatable.dart';

class AdminSpaceSummaryEntity extends Equatable {
  final String id;
  final String name;

  const AdminSpaceSummaryEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

