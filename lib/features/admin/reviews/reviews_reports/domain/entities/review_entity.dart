import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String userName;
  final String spaceName; 
  final String dateLabel; 
  final String stars;
  final String text;
  final String? adminReply; 

  const ReviewEntity({
    required this.id,
    required this.userName,
    required this.spaceName,
    required this.dateLabel,
    required this.stars,
    required this.text,
    required this.adminReply,
  });

  @override
  List<Object?> get props => [id, userName, spaceName, dateLabel, stars, text, adminReply];
}
