import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'analytics_source.dart';
import '../models/analytics_model.dart';


class AnalyticsFirebaseSource implements AnalyticsSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<AnalyticsModel> fetchAnalytics() async {
    final now = DateTime.now();

    
    final results = await Future.wait([
      _db.collection('bookings').get(),
      _db.collection('spaces').get(),
      _db.collection('reviews').get(),
    ]);

    final bookingsDocs = results[0].docs;
    final spacesDocs = results[1].docs;
    final reviewsDocs = results[2].docs;

    
    double totalRevenue = 0;
    for (final doc in bookingsDocs) {
      final d = doc.data() as Map<String, dynamic>;
      final status = (d['status'] as String? ?? '').toLowerCase();
      if (status == 'paid' || status == 'confirmed') {
        totalRevenue += (d['totalAmount'] as num? ?? 0).toDouble();
      }
    }

    
    final totalSpaces = spacesDocs.length;
    final bookedSpaces = bookingsDocs
        .where((d) {
          final s = (d.data()['status'] as String? ?? '').toLowerCase();
          return s == 'confirmed' || s == 'paid';
        })
        .map((d) => d.data()['spaceId'])
        .toSet()
        .length;
    final occupancy = totalSpaces > 0
        ? '${((bookedSpaces / totalSpaces) * 100).toStringAsFixed(0)}%'
        : '0%';

    
    double ratingSum = 0;
    int ratingCount = 0;
    for (final doc in reviewsDocs) {
      final r = double.tryParse(doc.data()['rating']?.toString() ?? doc.data()['stars']?.toString() ?? '');
      if (r != null) {
        ratingSum += r;
        ratingCount++;
      }
    }
    final avgRating = ratingCount > 0 ? (ratingSum / ratingCount).toStringAsFixed(1) : '-';

    
    final weekLabels = <String>[];
    final weekValues = <String>[];
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final label = DateFormat('E').format(day);
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      double dayRevenue = 0;
      for (final doc in bookingsDocs) {
        final d = doc.data() as Map<String, dynamic>;
        final ts = d['createdAt'];
        if (ts == null) continue;
        final dt = (ts as Timestamp).toDate();
        if (dt.isAfter(dayStart) && dt.isBefore(dayEnd)) {
          dayRevenue += (d['totalAmount'] as num? ?? 0).toDouble();
        }
      }

      weekLabels.add(label);
      weekValues.add(dayRevenue.toStringAsFixed(0));
    }

    
    final spaceBookingCount = <String, int>{};
    for (final doc in bookingsDocs) {
      final spaceName = doc.data()['spaceName'] as String? ?? '';
      if (spaceName.isNotEmpty) {
        spaceBookingCount[spaceName] = (spaceBookingCount[spaceName] ?? 0) + 1;
      }
    }
    final topSpaces = (spaceBookingCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(3)
        .map((e) => e.key)
        .toList();

    return AnalyticsModel(
      occupancy: occupancy,
      revenue: '\$${totalRevenue.toStringAsFixed(0)}',
      avgRating: avgRating,
      weekLabels: weekLabels,
      weekValues: weekValues,
      topSpaces: topSpaces.isEmpty ? ['No data'] : topSpaces,
    );
  }

  @override
  Future<void> exportReport() async {
    
  }
}
