import 'package:bloc/bloc.dart';

import '../domain/repos/settings_repo.dart';
import '../data/repos/settings_repo_firebase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepo repo;

  SettingsBloc({SettingsRepo? repo})
    : repo = repo ?? SettingsRepoFirebase(),
      super(SettingsState.initial()) {
    on<SettingsStarted>(_onStarted);
    on<SettingsRefreshRequested>(_onRefresh);

    on<SettingsToggleNotifications>(_onToggleNotifications);
    on<SettingsToggleBookingReminders>(_onToggleReminders);
    on<SettingsSelectReminderTiming>(_onSelectTiming);
    on<SettingsSelectLanguage>(_onSelectLanguage);
    on<SettingsToggleDarkMode>(_onToggleDarkMode);
  }

  /// âœ… طھط­ظ…ظٹظ„ ط§ظ„ط¥ط¹ط¯ط§ط¯ط§طھ ط£ظˆظ„ ظ…ط§ طھظپطھط­ ط§ظ„طµظپط­ط©
  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null, goToLogin: false));
    try {
      final s = await repo.fetchSettings();
      emit(state.copyWith(loading: false, settings: s, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString(), settings: null));
    }
  }

  /// âœ… Refresh
  Future<void> _onRefresh(
    SettingsRefreshRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final s = await repo.fetchSettings();
      emit(state.copyWith(settings: s, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _persist(Emitter<SettingsState> emit, SettingsState next) async {
    emit(next);
    try {
      await repo.saveSettings(next.settings!);
    } catch (_) {
      // ظ…ط§ ظ…ظ†ظˆظ‚ظپ UI ظ„ظˆ ظپط´ظ„ ط§ظ„ط­ظپط¸طŒ ط¨ط³ ظ…ظ…ظƒظ† طھط¶ظٹظپظٹ toast ظ„ط§ط­ظ‚ط§ظ‹
    }
  }

  /// âœ… طھط´ط؛ظٹظ„/ط¥ظٹظ‚ط§ظپ ط¥ط´ط¹ط§ط±ط§طھ ط¹ط§ظ…ط©
  Future<void> _onToggleNotifications(
    SettingsToggleNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    final s = state.settings;
    if (s == null) return;
    await _persist(
      emit,
      state.copyWith(settings: s.copyWith(notificationsEnabled: event.value)),
    );
  }

  /// âœ… طھط´ط؛ظٹظ„/ط¥ظٹظ‚ط§ظپ طھط°ظƒظٹط± ط§ظ„ط­ط¬ط²
  Future<void> _onToggleReminders(
    SettingsToggleBookingReminders event,
    Emitter<SettingsState> emit,
  ) async {
    final s = state.settings;
    if (s == null) return;
    await _persist(
      emit,
      state.copyWith(
        settings: s.copyWith(bookingRemindersEnabled: event.value),
      ),
    );
  }

  /// âœ… ط§ط®طھظٹط§ط± طھظˆظ‚ظٹطھ ط§ظ„طھط°ظƒظٹط±
  Future<void> _onSelectTiming(
    SettingsSelectReminderTiming event,
    Emitter<SettingsState> emit,
  ) async {
    final s = state.settings;
    if (s == null) return;
    await _persist(
      emit,
      state.copyWith(settings: s.copyWith(reminderTiming: event.timing)),
    );
  }

  /// âœ… طھط؛ظٹظٹط± ط§ظ„ظ„ط؛ط©
  Future<void> _onSelectLanguage(
    SettingsSelectLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    final s = state.settings;
    if (s == null) return;
    await _persist(
      emit,
      state.copyWith(settings: s.copyWith(languageCode: event.languageCode)),
    );
  }

  /// âœ… Dark mode (ط­ط§ظ„ظٹط§ظ‹ UI ظپظ‚ط· - ظ…ظ…ظƒظ† طھط±ط¨ط·ظٹظ‡ ظ„ط§ط­ظ‚ط§ظ‹ ط¨ظ€ ThemeBloc)
  Future<void> _onToggleDarkMode(
    SettingsToggleDarkMode event,
    Emitter<SettingsState> emit,
  ) async {
    final s = state.settings;
    if (s == null) return;
    await _persist(
      emit,
      state.copyWith(settings: s.copyWith(darkMode: event.value)),
    );
  }
}


