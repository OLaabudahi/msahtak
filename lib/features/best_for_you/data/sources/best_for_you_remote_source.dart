import '../../domain/entities/fit_score.dart';
import '../models/best_for_you_space_model.dart';

/// ظˆط§ط¬ظ‡ط© ظ…طµط¯ط± ط§ظ„ط¨ظٹط§ظ†ط§طھ â€“ ط§ط³طھط¨ط¯ظ„ FakeBestForYouSource ط¨ظ€ RealBestForYouSource ط¹ظ†ط¯ ط±ط¨ط· API
abstract class BestForYouRemoteSource {
  Future<BestForYouSpaceModel> getBestSpace(String goal);
  Future<FitScore> getFitScore(String spaceId, String goal);

  /// ط¬ظ„ط¨ ط£ط¹ظ„ظ‰ 5 ظ…ط³ط§ط­ط§طھ طھظ‚ظٹظٹظ…ط§ظ‹ ط¶ظ…ظ† 100 ظ…طھط± ظ…ظ† ط§ظ„ظ…ظˆظ‚ط¹ ط§ظ„ط­ط§ظ„ظٹ
  Future<List<BestForYouSpaceModel>> getTopRatedNearby();
}

class FakeBestForYouSource implements BestForYouRemoteSource {
  static const _space = BestForYouSpaceModel(
    id: 'space_a',
    name: 'Space A â€“ Study Friendly',
    location: 'City Center â€¢ Quiet â€¢ Fast Wi-Fi',
    distance: '1.2 km',
    pricePerDay: 35,
    rating: 4.8,
  );

  static const _fitScores = {
    'Study': FitScore(
      percentage: 0.92,
      reasons: [
        'Quietness is high (similar users)',
        'Wi-Fi stability is strong',
        'Plenty of power outlets',
      ],
      headsUp: 'Can get a bit crowded after 7 PM.',
    ),
    'Work': FitScore(
      percentage: 0.85,
      reasons: [
        'Fast & reliable internet',
        'Standing desks available',
        'Private booths for calls',
      ],
      headsUp: 'Limited parking on weekday mornings.',
    ),
    'Meeting': FitScore(
      percentage: 0.78,
      reasons: [
        'Conference room available',
        'Whiteboard in every room',
        'Good catering nearby',
      ],
      headsUp: 'Book meeting rooms in advance.',
    ),
    'Relax': FitScore(
      percentage: 0.70,
      reasons: [
        'Comfortable lounge area',
        'Natural lighting',
        'Cafأ© on ground floor',
      ],
      headsUp: 'Can be noisy during lunch hours.',
    ),
  };

  /// ط¬ظ„ط¨ ط§ظ„ظ…ط³ط§ط­ط© ط§ظ„ط£ظپط¶ظ„ ظ„ظ„ظ‡ط¯ظپ â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.get('/best-for-you?goal=X') ط¹ظ†ط¯ ط±ط¨ط· API
  @override
  Future<BestForYouSpaceModel> getBestSpace(String goal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _space;
  }

  /// ط¬ظ„ط¨ ط¯ط±ط¬ط© ط§ظ„طھط·ط§ط¨ظ‚ â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.get('/fit-score?spaceId=X&goal=Y') ط¹ظ†ط¯ ط±ط¨ط· API
  @override
  Future<FitScore> getFitScore(
      String spaceId, String goal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _fitScores[goal] ?? _fitScores['Study']!;
  }

  @override
  Future<List<BestForYouSpaceModel>> getTopRatedNearby() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [_space];
  }
}


