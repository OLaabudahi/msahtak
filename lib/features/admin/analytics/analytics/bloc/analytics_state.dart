import 'package:equatable/equatable.dart';
import '../domain/entities/analytics_entity.dart';

enum AnalyticsStatus { initial, loading, ready, failure }

class AnalyticsState extends Equatable {
  final AnalyticsStatus status;
  final AnalyticsEntity? data;
  final String? error;

  const AnalyticsState({
    required this.status,
    required this.data,
    required this.error,
  });

  factory AnalyticsState.initial() => const AnalyticsState(status: AnalyticsStatus.initial, data: null, error: null);

  AnalyticsState copyWith({AnalyticsStatus? status, AnalyticsEntity? data, String? error}) {
    return AnalyticsState(status: status ?? this.status, data: data ?? this.data, error: error);
  }

  @override
  List<Object?> get props => [status, data, error];
}


