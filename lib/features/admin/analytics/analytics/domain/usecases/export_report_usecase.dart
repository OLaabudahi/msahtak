import '../repos/analytics_repo.dart';

class ExportReportUseCase {
  final AnalyticsRepo repo;
  const ExportReportUseCase(this.repo);

  Future<void> call() => repo.exportReport();
}
