import '../../domain/entities/usage_booking_entity.dart';
import '../../domain/entities/usage_space_entity.dart';
import '../../domain/repos/profile_usage_repo.dart';
import '../sources/profile_usage_source.dart';

class ProfileUsageRepoFirebase implements ProfileUsageRepo {
  final ProfileUsageSource source;

  ProfileUsageRepoFirebase(this.source);

  @override
  Future<List<UsageBookingEntity>> getUserBookings() async {
    final rows = await source.getUserBookings();

    return rows.map((row) {
      DateTime? _toDate(dynamic value) {
        if (value == null) return null;
        if (value is DateTime) return value;
        if (value is String) return DateTime.tryParse(value);
        if (value is Map && value['_seconds'] is int) {
          return DateTime.fromMillisecondsSinceEpoch((value['_seconds'] as int) * 1000);
        }
        if (value.runtimeType.toString() == 'Timestamp') {
          return value.toDate() as DateTime?;
        }
        return null;
      }

      return UsageBookingEntity(
        id: (row['id'] ?? '').toString(),
        spaceId: (row['spaceId'] ?? row['space_id'] ?? '').toString(),
        planType: (row['planType'] ?? row['plan_type'] ?? 'day').toString(),
        startDate: _toDate(row['startDate'] ?? row['start_date']),
        endDate: _toDate(row['endDate'] ?? row['end_date']),
      );
    }).where((b) => b.spaceId.isNotEmpty).toList(growable: false);
  }

  @override
  Future<List<UsageSpaceEntity>> getSpacesByIds(List<String> ids) async {
    final rows = await source.getSpacesByIds(ids);

    return rows.map((row) {
      final offersRaw = (row['offers'] as List?) ?? const [];
      final featuresRaw = (row['tags'] as List?) ?? (row['features'] as List?) ?? const [];

      return UsageSpaceEntity(
        id: (row['id'] ?? '').toString(),
        name: (row['name'] ?? row['spaceName'] ?? 'Space').toString(),
        pricePerDay: ((row['pricePerDay'] ?? row['price_per_day'] ?? 0) as num?)?.toInt() ?? 0,
        offers: offersRaw.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList(growable: false),
        features: featuresRaw.map((e) => e.toString()).toList(growable: false),
      );
    }).toList(growable: false);
  }
}
