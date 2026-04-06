import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../core/services/firestore_api.dart';
import '../../../../../../services/local_storage_service.dart';

import 'admin_home_source.dart';
import '../models/kpi_model.dart';
import '../../domain/entities/admin_space_item.dart';
import '../../domain/entities/admin_activity_item.dart';

class AdminHomeFirebaseSource implements AdminHomeSource {
  final FirestoreApi _api = FirestoreApi();
  final LocalStorageService _storage = LocalStorageService();

  /// =========================
  /// SPACES (🔥 أهم جزء)
  /// =========================
  @override
  Future<List<AdminSpaceItem>> fetchSpaces() async {
    final adminId = await _storage.getUserId();

    final spaces = await _api.getCollection(collection: 'spaces');

    final filtered = spaces.where((space) {
      final ownerId = space['adminId'] ?? space['ownerId'] ?? '';
      return ownerId == adminId;
    }).toList();

    return filtered.map((space) {
      final name =
          space['spaceName'] ??
              space['name'] ??
              'No Name';

      return AdminSpaceItem(
        id: space['id'],
        name: name,
      );
    }).toList();
  }

  /// =========================
  /// ACTIVITY
  /// =========================
  @override
  Future<List<AdminActivityItem>> fetchRecentActivity() async {
    final adminId = await _storage.getUserId();

    final bookings = await _api.getCollection(collection: 'bookings');

    final filtered = bookings.where((b) {
      final ownerId = b['adminId'] ?? b['ownerId'] ?? '';
      return ownerId == adminId;
    }).toList();

    filtered.sort((a, b) {
      final aDate = (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
      final bDate = (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
      return bDate.compareTo(aDate);
    });

    return filtered.take(5).map((d) {
      final userName =
          d['userName'] ??
              d['user_name'] ??
              'User';

      final spaceName =
          d['spaceName'] ??
              d['workspaceName'] ??
              'Space';

      final status = d['status'] ?? 'pending';

      final ts = d['createdAt'] as Timestamp?;
      final createdAt = ts?.toDate() ?? DateTime.now();

      return AdminActivityItem(
        userName: userName,
        spaceName: spaceName,
        status: status,
        createdAt: createdAt,
      );
    }).toList();
  }

  /// =========================
  /// KPI
  /// =========================
  @override
  Future<List<KpiModel>> fetchKpis({required String spaceId}) async {
    final adminId = await _storage.getUserId();

    final bookings = await _api.getCollection(collection: 'bookings');
    final spaces = await _api.getCollection(collection: 'spaces');

    /// فلترة حسب الأدمن
    final filteredBookings = bookings.where((b) {
      final ownerId = b['adminId'] ?? b['ownerId'] ?? '';
      return ownerId == adminId;
    }).toList();

    /// اليوم
    final todayStart = DateTime.now()
        .copyWith(hour: 0, minute: 0, second: 0);

    final todayCount = filteredBookings.where((b) {
      final ts = b['startDate'] as Timestamp?;
      final date = ts?.toDate();
      return date != null && date.isAfter(todayStart);
    }).length;

    /// pending
    final pendingCount = filteredBookings
        .where((b) => b['status'] == 'pending')
        .length;

    /// revenue
    final weekStart = DateTime.now().subtract(const Duration(days: 7));

    final weekRevenue = filteredBookings.fold<num>(0, (sum, b) {
      final ts = b['createdAt'] as Timestamp?;
      final date = ts?.toDate();

      if (date == null || date.isBefore(weekStart)) return sum;

      final price =
          b['total_price'] ??
              b['totalPrice'] ??
              b['totalAmount'] ??
              0;

      return sum + price;
    });

    /// active spaces
    final activeSpaces = spaces.where((s) {
      final ownerId = s['adminId'] ?? s['ownerId'] ?? '';
      final isActive = s['isActive'] ?? true;
      return ownerId == adminId && isActive;
    }).length;

    return [
      KpiModel(
        id: 'today',
        title: 'kpiTodayTitle',
        value: '$todayCount',
        delta: 'kpiTodayDelta',
      ),
      KpiModel(
        id: 'pending',
        title: 'kpiPendingTitle',
        value: '$pendingCount',
        delta: pendingCount > 0 ? 'kpiNeedsReview' : 'kpiAllClear',
      ),
      KpiModel(
        id: 'spaces',
        title: 'kpiSpacesTitle',
        value: '$activeSpaces',
        delta: 'kpiSpacesDelta',
      ),
      KpiModel(
        id: 'revenue',
        title: 'kpiRevenueTitle',
        value: '${weekRevenue.toStringAsFixed(0)} ₪',
        delta: 'kpiRevenueDelta',
      ),
    ];
  }
}