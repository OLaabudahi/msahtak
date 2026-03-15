import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_home_source.dart';
import '../models/kpi_model.dart';
import '../../domain/entities/admin_space_item.dart';
import '../../domain/entities/admin_activity_item.dart';
import '../../../../_shared/admin_session.dart';

/// مصدر Firebase للوحة تحكم الأدمن — يحسب KPIs من bookings/workspaces
class AdminHomeFirebaseSource implements AdminHomeSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<AdminSpaceItem>> fetchSpaces() async {
    final all = await _db.collection('workspaces').get();
    final assigned = AdminSession.assignedSpaceIds;
    return all.docs
        .where((d) => assigned.isEmpty || assigned.contains(d.id))
        .map((d) {
          final name = d.data()['spaceName'] as String? ?? d.data()['name'] as String? ?? d.id;
          return AdminSpaceItem(id: d.id, name: name);
        })
        .toList();
  }

  @override
  Future<List<AdminActivityItem>> fetchRecentActivity() async {
    final assigned = AdminSession.assignedSpaceIds;
    final snap = await _db
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .limit(assigned.isEmpty ? 5 : 20)
        .get();

    final filtered = assigned.isEmpty
        ? snap.docs
        : snap.docs.where((doc) {
            final d = doc.data();
            final spaceId = (d['workspaceId'] ?? d['spaceId'] ?? d['space_id'] ?? '') as String;
            return assigned.contains(spaceId);
          }).take(5).toList();

    return filtered.map((doc) {
      final d = doc.data();
      final userName = d['userName'] as String? ?? d['user_name'] as String? ?? d['guestName'] as String? ?? 'User';
      final spaceName = d['spaceName'] as String? ?? d['workspaceName'] as String? ?? 'Space';
      final status = d['status'] as String? ?? 'pending';
      final ts = d['createdAt'] as Timestamp?;
      final createdAt = ts?.toDate() ?? DateTime.now();
      return AdminActivityItem(userName: userName, spaceName: spaceName, status: status, createdAt: createdAt);
    }).toList();
  }

  @override
  Future<List<KpiModel>> fetchKpis({required String spaceId}) async {
    final assigned = AdminSession.assignedSpaceIds;

    bool inScope(DocumentSnapshot<Map<String, dynamic>> doc) {
      if (assigned.isEmpty) return true;
      final d = doc.data() ?? {};
      final sid = (d['workspaceId'] ?? d['spaceId'] ?? d['space_id'] ?? '') as String;
      return assigned.contains(sid);
    }

    // حجوزات اليوم
    final todayStart = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    final todayEnd   = todayStart.add(const Duration(days: 1));

    final todaySnap = await _db
        .collection('bookings')
        .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
        .where('startDate', isLessThan: Timestamp.fromDate(todayEnd))
        .get();
    final todayCount = todaySnap.docs.where(inScope).length;

    // الطلبات المعلقة
    final pendingSnap = await _db
        .collection('bookings')
        .where('status', isEqualTo: 'pending')
        .get();
    final pendingCount = pendingSnap.docs.where(inScope).length;

    // إيرادات الأسبوع — تشمل كل الحالات الموافق عليها
    final weekStart = DateTime.now().subtract(const Duration(days: 7));
    final weekStatuses = ['approved', 'approved_waiting_payment', 'payment_under_review', 'confirmed', 'paid'];
    final weekSnaps = await Future.wait(weekStatuses.map((s) => _db.collection('bookings').where('status', isEqualTo: s).get()));
    final allWeekDocs = weekSnaps.expand((s) => s.docs).where(inScope).toList();
    final weekRevenue = allWeekDocs.fold<num>(0, (sum, doc) {
      final d = doc.data();
      final ts = d['createdAt'] as Timestamp?;
      if (ts != null && ts.toDate().isBefore(weekStart)) return sum;
      final price = d['total_price'] as num? ?? d['totalPrice'] as num? ?? d['totalAmount'] as num? ?? 0;
      return sum + price;
    });

    // عدد المساحات النشطة — فلترة client-side
    final spacesSnap = await _db.collection('workspaces').get();
    final activeSpaces = spacesSnap.docs.where((d) {
      if (assigned.isNotEmpty && !assigned.contains(d.id)) return false;
      return d.data()['isActive'] as bool? ?? true;
    }).length;

    return [
      KpiModel(
        id: 'today',
        title: 'Today Bookings',
        value: '$todayCount',
        delta: 'bookings today',
      ),
      KpiModel(
        id: 'pending',
        title: 'Pending Requests',
        value: '$pendingCount',
        delta: pendingCount > 0 ? 'Needs review' : 'All clear',
      ),
      KpiModel(
        id: 'spaces',
        title: 'Active Spaces',
        value: '$activeSpaces',
        delta: 'total spaces',
      ),
      KpiModel(
        id: 'revenue',
        title: 'Weekly Revenue',
        value: '\$${weekRevenue.toStringAsFixed(0)}',
        delta: 'last 7 days',
      ),
    ];
  }
}
