import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/hub_model.dart';
import '../models/weekly_plan_model.dart';
import 'weekly_plan_remote_source.dart';

/// ✅ تنفيذ Firebase لـ WeeklyPlanRemoteSource
class WeeklyPlanFirebaseSource implements WeeklyPlanRemoteSource {
  @override
  Future<List<HubModel>> getHubs() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // إذا كان المستخدم مسجل دخول، نجيب مساحاته من آخر أسبوع
    if (uid != null) {
      var bookingsSnap = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: uid)
          .limit(200)
          .get();

      // محاولة بديلة مع user_id إذا ما في نتائج
      if (bookingsSnap.docs.isEmpty) {
        bookingsSnap = await FirebaseFirestore.instance
            .collection('bookings')
            .where('user_id', isEqualTo: uid)
            .limit(200)
            .get();
      }

      if (bookingsSnap.docs.isNotEmpty) {
        final seenIds = <String>{};
        final workspaceIds = <String>[];
        for (final doc in bookingsSnap.docs) {
          final d = doc.data();
          final wsId = d['workspaceId'] as String? ??
              d['spaceId'] as String? ??
              d['workspace_id'] as String? ??
              '';
          if (wsId.isNotEmpty && seenIds.add(wsId)) {
            workspaceIds.add(wsId);
          }
        }

        final hubs = <HubModel>[];
        for (final wsId in workspaceIds) {
          try {
            final wsDoc = await FirebaseFirestore.instance
                .collection('spaces')
                .doc(wsId)
                .get();
            if (wsDoc.exists) {
              final name = wsDoc.data()?['name'] as String? ??
                  wsDoc.data()?['spaceName'] as String? ??
                  'Space';
              hubs.add(HubModel(id: wsId, name: name));
            }
          } catch (_) {}
        }

        if (hubs.isNotEmpty) return hubs;
      }
    }

    // fallback: مساحات تحتوي على has_weekly_plan=true
    final snap = await FirebaseFirestore.instance
        .collection('spaces')
        .where('has_weekly_plan', isEqualTo: true)
        .limit(20)
        .get();

    if (snap.docs.isNotEmpty) {
      return snap.docs
          .map((doc) => HubModel(
                id: doc.id,
                name: doc.data()['name'] as String? ?? 'Space',
              ))
          .toList();
    }

    // آخر fallback: كل المساحات
    final allSnap = await FirebaseFirestore.instance
        .collection('spaces')
        .limit(10)
        .get();
    return allSnap.docs
        .map((doc) => HubModel(
              id: doc.id,
              name: doc.data()['name'] as String? ?? 'Space',
            ))
        .toList();
  }

  @override
  Future<WeeklyPlanModel> getPlanDetails(String hubId) async {
    final doc = await FirebaseFirestore.instance
        .collection('spaces')
        .doc(hubId)
        .get();
    final d = doc.data() ?? {};

    return WeeklyPlanModel(
      hubId: hubId,
      hubName: d['name'] as String? ?? 'Space',
      pricePerWeek: (d['price_per_week'] as num?)?.toInt() ??
          (d['pricePerWeek'] as num?)?.toInt() ??
          0,
      features: (d['features'] as List?)?.cast<String>() ?? const [],
      tip: d['weekly_tip'] as String? ?? d['tip'] as String? ?? '',
    );
  }

  @override
  Future<void> activatePlan(String hubId) async {
    // TODO: تسجيل في Firestore users/{uid}/plans
  }
}
