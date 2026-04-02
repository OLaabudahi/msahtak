import 'package:equatable/equatable.dart';
import '../data/models/settings_model.dart';

class SettingsState extends Equatable {
  final bool loading;
  final String? error;

  final SettingsModel? settings;

  /// ✅ للإشعار باللوج آوت (Navigation)

  const SettingsState({
    required this.loading,
    required this.error,
    required this.settings,
  });

  factory SettingsState.initial() =>
      const SettingsState(loading: true, error: null, settings: null);

  SettingsState copyWith({
    bool? loading,
    String? error,
    SettingsModel? settings,
    bool? goToLogin,
  }) {
    return SettingsState(
      loading: loading ?? this.loading,
      error: error,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [loading, error, settings];
}
