import '../entities/report_entity.dart';
import '../repos/reviews_reports_repo.dart';

class GetReportsUseCase {
  final ReviewsReportsRepo repo;
  const GetReportsUseCase(this.repo);

  Future<List<ReportEntity>> call() => repo.getReports();
}


