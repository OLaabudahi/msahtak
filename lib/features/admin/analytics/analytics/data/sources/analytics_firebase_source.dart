import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'analytics_source.dart';
import '../models/analytics_model.dart';

/// مصدر Firebase للتحليلات — يجمع من bookings و spaces و reviews
class AnalyticsFirebaseSource implements AnalyticsSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<AnalyticsModel> fetchAnalytics() async {
    final now = DateTime.now();

    // جلب الحجوزات والمساحات والتقييمات بالتوازي
    final results = await Future.wait([
      _db.collection('bookings').get(),
      _db.collection('spaces').get(),
      _db.collection('reviews').get(),
    ]);

    final bookingsDocs = results[0].docs;
    final spacesDocs = results[1].docs;
    final reviewsDocs = results[2].docs;

    // إجمالي الإيرادات من الحجوزات المدفوعة
    double totalRevenue = 0;
    for (final doc in bookingsDocs) {
      final d = doc.data() as Map<String, dynamic>;
      final status = (d['status'] as String? ?? '').toLowerCase();
      if (status == 'paid' || status == 'confirmed') {
        totalRevenue += (d['totalAmount'] as num? ?? 0).toDouble();
      }
    }

    // نسبة الإشغال (محجوز / إجمالي)
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

    // متوسط التقييم
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

    // إيرادات آخر 7 أيام
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

    // أفضل المساحات حسب الإيراد
    final spaceBookingCount = <String, int>{};
    final spaceRevenue = <String, double>{};
    final spaceRatings = <String, List<double>>{};

    final spaceNameById = <String, String>{};
    for (final doc in spacesDocs) {
      final d = doc.data() as Map<String, dynamic>;
      final name = (d['name'] ?? d['spaceName'] ?? doc.id).toString();
      spaceNameById[doc.id] = name;
    }

    for (final doc in bookingsDocs) {
      final data = doc.data() as Map<String, dynamic>;
      final status = (data['status'] as String? ?? '').toLowerCase();
      final spaceId = (data['spaceId'] ?? '').toString();
      final spaceName = (data['spaceName'] ??
              spaceNameById[spaceId] ??
              (spaceId.isEmpty ? '' : spaceId))
          .toString();
      if (spaceName.isNotEmpty) {
        spaceBookingCount[spaceName] = (spaceBookingCount[spaceName] ?? 0) + 1;
        if (status == 'paid' || status == 'confirmed') {
          spaceRevenue[spaceName] =
              (spaceRevenue[spaceName] ?? 0) +
              (data['totalAmount'] as num? ?? 0).toDouble();
        }
      }
    }

    for (final doc in reviewsDocs) {
      final data = doc.data() as Map<String, dynamic>;
      final spaceId = (data['spaceId'] ?? '').toString();
      final spaceName = (data['spaceName'] ??
              spaceNameById[spaceId] ??
              (spaceId.isEmpty ? '' : spaceId))
          .toString();
      final rating = double.tryParse(
        data['rating']?.toString() ?? data['stars']?.toString() ?? '',
      );
      if (spaceName.isEmpty || rating == null) continue;
      spaceRatings.putIfAbsent(spaceName, () => <double>[]).add(rating);
    }

    final topSpaces = (spaceRevenue.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(5)
        .map((entry) {
          final name = entry.key;
          final bookings = spaceBookingCount[name] ?? 0;
          final ratings = spaceRatings[name] ?? const <double>[];
          final avg = ratings.isEmpty
              ? '0.0'
              : (ratings.reduce((a, b) => a + b) / ratings.length)
                    .toStringAsFixed(1);
          final revenue = entry.value.toStringAsFixed(0);
          return '$name|$avg|$bookings|$revenue';
        })
        .toList();

    return AnalyticsModel(
      occupancy: occupancy,
      revenue: '\$${totalRevenue.toStringAsFixed(0)}',
      avgRating: avgRating,
      weekLabels: weekLabels,
      weekValues: weekValues,
      topSpaces: topSpaces.isEmpty ? ['No data|0.0|0|0'] : topSpaces,
    );
  }

  @override
  Future<void> exportReport() async {
    // يمكن تنفيذه لاحقاً
  }
}
