import '../../domain/entities/analytics_entity.dart';
import '../../domain/repos/analytics_repo.dart';
import '../sources/analytics_source.dart';

class AnalyticsRepoImpl implements AnalyticsRepo {
  final AnalyticsSource source;
  const AnalyticsRepoImpl(this.source);

  @override
  Future<AnalyticsEntity> getAnalytics() async {
    final m = await source.fetchAnalytics();
    return m.toEntity();
  }

  @override
  Future<void> exportReport() => source.exportReport();
}
