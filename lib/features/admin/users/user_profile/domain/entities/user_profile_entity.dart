import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String name;
  final String avatar;
  final String internalRating;
  final String noShowCount;
  final List<String> bookingHistory;

  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.internalRating,
    required this.noShowCount,
    required this.bookingHistory,
  });

  @override
  List<Object?> get props => [id, name, avatar, internalRating, noShowCount, bookingHistory];
}
