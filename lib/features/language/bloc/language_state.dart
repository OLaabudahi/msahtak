import 'package:equatable/equatable.dart';

class LanguageState extends Equatable {
  const LanguageState({required this.loading, required this.code, this.error});

  final bool loading;
  final String code;
  final String? error;

  LanguageState copyWith({bool? loading, String? code, String? error}) {
    return LanguageState(
      loading: loading ?? this.loading,
      code: code ?? this.code,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, code, error];
}
