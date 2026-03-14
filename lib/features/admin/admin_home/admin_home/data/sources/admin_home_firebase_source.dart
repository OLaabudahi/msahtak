import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_home_source.dart';
import '../models/kpi_model.dart';

/// مصدر Firebase للوحة تحكم الأدمن — يحسب KPIs من bookings/workspaces
class AdminHomeFirebaseSource implements AdminHomeSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<String>> fetchSpaces() async {
    final all = await _db.collection('workspaces').get();
    return all.docs.map((d) {
      return d.data()['spaceName'] as String? ?? d.data()['name'] as String? ?? d.id;
    }).toList();
  }

  @override
  Future<List<KpiModel>> fetchKpis({required String spaceId}) async {
    // حجوزات اليوم
    final todayStart = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    final todayEnd   = todayStart.add(const Duration(days: 1));

    final todaySnap = await _db
        .collection('bookings')
        .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
        .where('startDate', isLessThan: Timestamp.fromDate(todayEnd))
        .get();
    final todayCount = todaySnap.docs.length;

    // الطلبات المعلقة
    final pendingSnap = await _db
        .collection('bookings')
        .where('status', isEqualTo: 'pending')
        .get();
    final pendingCount = pendingSnap.docs.length;

    // إيرادات الأسبوع — فلترة client-side لتجنب composite index
    final weekStart = DateTime.now().subtract(const Duration(days: 7));
    final weekSnap = await _db
        .collection('bookings')
        .where('status', isEqualTo: 'approved')
        .get();
    final weekRevenue = weekSnap.docs.fold<num>(0, (sum, doc) {
      final d = doc.data();
      final ts = d['createdAt'] as Timestamp?;
      if (ts != null && ts.toDate().isBefore(weekStart)) return sum;
      final price = d['total_price'] ?? d['totalPrice'] ?? d['totalAmount'] ?? 0;
      return sum + (price as num);
    });

    // عدد المساحات النشطة — فلترة client-side
    final spacesSnap = await _db.collection('workspaces').get();
    final activeSpaces = spacesSnap.docs.where((d) {
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
