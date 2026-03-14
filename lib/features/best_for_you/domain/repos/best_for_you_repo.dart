import '../entities/best_for_you_space.dart';
import '../entities/fit_score.dart';

abstract class BestForYouRepo {
  /// جلب أفضل مساحة للمستخدم بناءً على الهدف
  Future<BestForYouSpace> getBestSpace(String goal);

  /// جلب درجة التطابق للمساحة مع الهدف المحدد
  Future<FitScore> getFitScore(String spaceId, String goal);

  /// جلب أعلى 5 مساحات تقييماً ضمن 100 متر
  Future<List<BestForYouSpace>> getTopRatedNearby();
}
