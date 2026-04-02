import '../entities/best_for_you_space.dart';
import '../entities/fit_score.dart';
import '../repos/best_for_you_repo.dart';

class GetBestForYouUseCase {
  final BestForYouRepo repo;
  GetBestForYouUseCase(this.repo);

  /// جلب المساحة المقترحة ودرجة التطابق للهدف المحدد
  Future<({BestForYouSpace space, FitScore fitScore})> call(
      String goal) async {
    final space = await repo.getBestSpace(goal);
    final fitScore = await repo.getFitScore(space.id, goal);
    return (space: space, fitScore: fitScore);
  }
}
