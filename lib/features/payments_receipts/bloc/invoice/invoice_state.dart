import 'package:equatable/equatable.dart';

class InvoiceState extends Equatable {
  final bool loading;
  final String? savedPath;
  final String? error;
  final String? successKey;

  const InvoiceState({
    required this.loading,
    required this.savedPath,
    required this.error,
    required this.successKey,
  });

  factory InvoiceState.initial() => const InvoiceState(
        loading: false,
        savedPath: null,
        error: null,
        successKey: null,
      );

  InvoiceState copyWith({
    bool? loading,
    String? savedPath,
    String? error,
    String? successKey,
    bool clearMessages = false,
  }) {
    return InvoiceState(
      loading: loading ?? this.loading,
      savedPath: savedPath ?? this.savedPath,
      error: clearMessages ? null : error,
      successKey: clearMessages ? null : successKey,
    );
  }

  @override
  List<Object?> get props => [loading, savedPath, error, successKey];
}
