import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/firestore_api.dart';

abstract class HomeSource {
  Future<List<Map<String, dynamic>>> fetchSpaces();

  Future<List<Map<String, dynamic>>> fetchInsights({required String langCode});

  Future<List<Map<String, dynamic>>> fetchUserBookings(String uid);
}

class HomeFirebaseSource implements HomeSource {
  HomeFirebaseSource(this.api);

  final FirestoreApi api;

  static const String _seedKey = 'insights_seeded_v1';

  @override
  Future<List<Map<String, dynamic>>> fetchSpaces() {
    return api.getCollection(collection: 'spaces');
  }



  @override
  Future<List<Map<String, dynamic>>> fetchUserBookings(String uid) async {
    final byUser = await api.queryWhereEqual(
      collection: 'bookings',
      field: 'userId',
      value: uid,
      limit: 400,
    );
    final byLegacyUser = await api.queryWhereEqual(
      collection: 'bookings',
      field: 'user_id',
      value: uid,
      limit: 400,
    );

    final merged = <String, Map<String, dynamic>>{};
    for (final row in [...byUser, ...byLegacyUser]) {
      final id = (row['id'] ?? '').toString();
      if (id.isEmpty) continue;
      merged[id] = row;
    }
    return merged.values.toList(growable: false);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchInsights({required String langCode}) async {
    await _seedInsightsOnce();
    final rows = await api.getCollection(collection: 'insights');
    rows.sort((a, b) {
      final ai = (a['sortOrder'] as num?)?.toInt() ?? 999;
      final bi = (b['sortOrder'] as num?)?.toInt() ?? 999;
      return ai.compareTo(bi);
    });

    return rows
        .map((row) {
          final titleAr = (row['title_ar'] ?? row['titleAr'] ?? '').toString();
          final titleEn = (row['title_en'] ?? row['titleEn'] ?? '').toString();
          final subtitleAr =
              (row['subtitle_ar'] ?? row['subtitleAr'] ?? '').toString();
          final subtitleEn =
              (row['subtitle_en'] ?? row['subtitleEn'] ?? '').toString();

          final useArabic = langCode.toLowerCase().startsWith('ar');
          final title = useArabic
              ? (titleAr.isNotEmpty ? titleAr : titleEn)
              : (titleEn.isNotEmpty ? titleEn : titleAr);
          final subtitle = useArabic
              ? (subtitleAr.isNotEmpty ? subtitleAr : subtitleEn)
              : (subtitleEn.isNotEmpty ? subtitleEn : subtitleAr);

          return {
            ...row,
            'title': title,
            'subtitle': subtitle,
          };
        })
        .where((e) => (e['title'] as String).isNotEmpty)
        .toList(growable: false);
  }

  Future<void> _seedInsightsOnce() async {
    final sp = await SharedPreferences.getInstance();
    final seeded = sp.getBool(_seedKey) ?? false;
    if (seeded) return;

    const defaults = [
      {
        'id': 'ins_best_for_you',
        'sortOrder': 1,
        'title_ar': 'الأنسب لك',
        'subtitle_ar': 'ابحث عن المساحة التي تناسب هدفك.',
        'title_en': 'Best For You',
        'subtitle_en': 'Find the space that matches your goal.',
        'imageUrl':
            'https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=1200&auto=format&fit=crop',
      },
      {
        'id': 'ins_offers',
        'sortOrder': 2,
        'title_ar': 'عروض حصرية',
        'subtitle_ar': 'عروض حصرية على أفضل المساحات.',
        'title_en': 'Exclusive Deals',
        'subtitle_en': 'Exclusive deals on top spaces.',
        'imageUrl':
            'https://images.unsplash.com/photo-1556761175-4b46a572b786?w=1200&auto=format&fit=crop',
      },
      {
        'id': 'ins_weekly_plan',
        'sortOrder': 3,
        'title_ar': 'تجهيزاتك القادمة',
        'subtitle_ar': 'جهّز زياراتك القادمة بخطة أوفر.',
        'title_en': 'Your Upcoming Setup',
        'subtitle_en': 'Prepare your next visits with a better plan.',
        'imageUrl':
            'https://images.unsplash.com/photo-1497215842964-222b430dc094?w=1200&auto=format&fit=crop',
      },
      {
        'id': 'ins_4',
        'sortOrder': 4,
        'title_ar': 'قائمة تحضير الاجتماع',
        'subtitle_ar': 'لا تفوتك الأساسيات.',
        'title_en': 'Meeting-ready checklist',
        'subtitle_en': "Don't miss the essentials.",
        'imageUrl':
            'https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=1200&auto=format&fit=crop',
      },
    ];

    for (final row in defaults) {
      final id = row['id']!;
      await api.create(
        collection: 'insights',
        docId: id,
        data: row,
      );
    }

    await sp.setBool(_seedKey, true);
  }
}
