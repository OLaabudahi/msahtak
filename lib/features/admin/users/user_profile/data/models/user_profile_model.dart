import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel {
  final String id;
  final String name;
  final String avatar;
  final String internalRating;
  final String noShowCount;
  final List<String> bookingHistory;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.internalRating,
    required this.noShowCount,
    required this.bookingHistory,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        avatar: (json['avatar'] ?? '').toString(),
        internalRating: (json['internalRating'] ?? '').toString(),
        noShowCount: (json['noShowCount'] ?? '').toString(),
        bookingHistory: (json['bookingHistory'] as List?)?.map((e) => e.toString()).toList(growable: false) ?? const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'internalRating': internalRating,
        'noShowCount': noShowCount,
        'bookingHistory': bookingHistory,
      };

  UserProfileEntity toEntity() => UserProfileEntity(
        id: id,
        name: name,
        avatar: avatar,
        internalRating: internalRating,
        noShowCount: noShowCount,
        bookingHistory: bookingHistory,
      );
}


