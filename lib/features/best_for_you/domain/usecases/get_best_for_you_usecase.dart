import '../entities/best_for_you_space.dart';
import '../entities/fit_score.dart';
import '../repos/best_for_you_repo.dart';

class GetBestForYouUseCase {
  final BestForYouRepo repo;
  GetBestForYouUseCase(this.repo);

  /// ط¬ظ„ط¨ ط§ظ„ظ…ط³ط§ط­ط© ط§ظ„ظ…ظ‚طھط±ط­ط© ظˆط¯ط±ط¬ط© ط§ظ„طھط·ط§ط¨ظ‚ ظ„ظ„ظ‡ط¯ظپ ط§ظ„ظ…ط­ط¯ط¯
  Future<({BestForYouSpace space, FitScore fitScore})> call(
      String goal) async {
    final space = await repo.getBestSpace(goal);
    final fitScore = await repo.getFitScore(space.id, goal);
    return (space: space, fitScore: fitScore);
  }
}


