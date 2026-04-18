import '../entities/insight_item.dart';
import '../repos/home_repo.dart';

class GetInsightsUseCase {
  final HomeRepo repo;

  const GetInsightsUseCase(this.repo);

  Future<List<InsightItem>> call({required String langCode}) {
    return repo.getInsights(langCode: langCode);
  }
}
