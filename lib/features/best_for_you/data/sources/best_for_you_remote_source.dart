import '../../domain/entities/fit_score.dart';
import '../models/best_for_you_space_model.dart';

/// واجهة مصدر البيانات – استبدل FakeBestForYouSource بـ RealBestForYouSource عند ربط API
abstract class BestForYouRemoteSource {
  Future<BestForYouSpaceModel> getBestSpace(String goal);
  Future<FitScore> getFitScore(String spaceId, String goal);

  /// جلب أعلى 5 مساحات تقييماً ضمن 100 متر من الموقع الحالي
  Future<List<BestForYouSpaceModel>> getTopRatedNearby();
}

class FakeBestForYouSource implements BestForYouRemoteSource {
  static const _space = BestForYouSpaceModel(
    id: 'space_a',
    name: 'Space A – Study Friendly',
    location: 'City Center • Quiet • Fast Wi-Fi',
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
        'Café on ground floor',
      ],
      headsUp: 'Can be noisy during lunch hours.',
    ),
  };

  /// جلب المساحة الأفضل للهدف – استبدل بـ http.get('/best-for-you?goal=X') عند ربط API
  @override
  Future<BestForYouSpaceModel> getBestSpace(String goal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _space;
  }

  /// جلب درجة التطابق – استبدل بـ http.get('/fit-score?spaceId=X&goal=Y') عند ربط API
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
