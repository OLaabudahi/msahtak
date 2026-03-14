import 'package:equatable/equatable.dart';

class PolicySectionEntity extends Equatable {
  final String id;
  final String title;
  final List<String> bullets;

  const PolicySectionEntity({
    required this.id,
    required this.title,
    required this.bullets,
  });

  @override
  List<Object?> get props => [id, title, bullets];
}
