import 'package:equatable/equatable.dart';

class FitScore extends Equatable {
  final double percentage; // 0.0 – 1.0
  final List<String> reasons;
  final String headsUp;

  const FitScore({
    required this.percentage,
    required this.reasons,
    required this.headsUp,
  });

  @override
  List<Object?> get props => [percentage, reasons, headsUp];
}
