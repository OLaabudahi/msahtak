import '../../domain/entities/best_for_you_space.dart';
import '../../domain/entities/fit_score.dart';
import '../../domain/repos/best_for_you_repo.dart';
import '../sources/best_for_you_remote_source.dart';

class BestForYouRepoDummy implements BestForYouRepo {
  final BestForYouRemoteSource source;
  BestForYouRepoDummy(this.source);

  /// جلب المساحة الأفضل من المصدر
  @override
  Future<BestForYouSpace> getBestSpace(String goal) =>
      source.getBestSpace(goal);

  /// جلب درجة التطابق من المصدر
  @override
  Future<FitScore> getFitScore(String spaceId, String goal) =>
      source.getFitScore(spaceId, goal);

  /// جلب أعلى 5 مساحات قريبة من المصدر
  @override
  Future<List<BestForYouSpace>> getTopRatedNearby() =>
      source.getTopRatedNearby();
}
