import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/hub_model.dart';
import '../models/weekly_plan_model.dart';
import 'weekly_plan_remote_source.dart';

/// ✅ تنفيذ Firebase لـ WeeklyPlanRemoteSource
class WeeklyPlanFirebaseSource implements WeeklyPlanRemoteSource {
  @override
  Future<List<HubModel>> getHubs() async {
    final snap = await FirebaseFirestore.instance
        .collection('workspaces')
        .where('has_weekly_plan', isEqualTo: true)
        .limit(20)
        .get();

    if (snap.docs.isEmpty) {
      // fallback: إرجاع كل المساحات كـ hubs
      final allSnap = await FirebaseFirestore.instance
          .collection('workspaces')
          .limit(10)
          .get();
      return allSnap.docs
          .map((doc) => HubModel(
                id: doc.id,
                name: doc.data()['name'] as String? ?? 'Space',
              ))
          .toList();
    }

    return snap.docs
        .map((doc) => HubModel(
              id: doc.id,
              name: doc.data()['name'] as String? ?? 'Space',
            ))
        .toList();
  }

  @override
  Future<WeeklyPlanModel> getPlanDetails(String hubId) async {
    final doc = await FirebaseFirestore.instance
        .collection('workspaces')
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
