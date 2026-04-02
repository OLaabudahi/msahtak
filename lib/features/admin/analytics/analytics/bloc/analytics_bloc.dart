import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/export_report_usecase.dart';
import '../domain/usecases/get_analytics_usecase.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAnalyticsUseCase getAnalytics;
  final ExportReportUseCase export;

  AnalyticsBloc({required this.getAnalytics, required this.export}) : super(AnalyticsState.initial()) {
    on<AnalyticsStarted>(_onStarted);
    on<AnalyticsExportPressed>(_onExport);
  }

  Future<void> _onStarted(AnalyticsStarted event, Emitter<AnalyticsState> emit) async {
    emit(state.copyWith(status: AnalyticsStatus.loading, error: null));
    try {
      final data = await getAnalytics();
      emit(state.copyWith(status: AnalyticsStatus.ready, data: data));
    } catch (e) {
      emit(state.copyWith(status: AnalyticsStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onExport(AnalyticsExportPressed event, Emitter<AnalyticsState> emit) async {
    await export();
  }
}


