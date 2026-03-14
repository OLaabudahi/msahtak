import '../entities/analytics_entity.dart';
import '../repos/analytics_repo.dart';

class GetAnalyticsUseCase {
  final AnalyticsRepo repo;
  const GetAnalyticsUseCase(this.repo);

  Future<AnalyticsEntity> call() => repo.getAnalytics();
}
