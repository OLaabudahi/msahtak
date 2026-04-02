import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/settings_model.dart';
import '../../domain/repos/settings_repo.dart';


class SettingsRepoFirebase implements SettingsRepo {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  @override
  Future<SettingsModel> fetchSettings() async {
    final uid = _uid;
    if (uid == null) return _defaults();

    final doc = await _db.collection('users').doc(uid).collection('settings').doc('preferences').get();
    if (!doc.exists) return _defaults();

    final d = doc.data()!;
    return SettingsModel(
      notificationsEnabled: d['notificationsEnabled'] as bool? ?? true,
      bookingRemindersEnabled: d['bookingRemindersEnabled'] as bool? ?? true,
      reminderTiming: d['reminderTiming'] as String? ?? '30 min',
      languageCode: d['languageCode'] as String? ?? 'en',
      darkMode: d['darkMode'] as bool? ?? false,
    );
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    final uid = _uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).collection('settings').doc('preferences').set({
      'notificationsEnabled': settings.notificationsEnabled,
      'bookingRemindersEnabled': settings.bookingRemindersEnabled,
      'reminderTiming': settings.reminderTiming,
      'languageCode': settings.languageCode,
      'darkMode': settings.darkMode,
    }, SetOptions(merge: true));
  }

  SettingsModel _defaults() => const SettingsModel(
        notificationsEnabled: true,
        bookingRemindersEnabled: true,
        reminderTiming: '30 min',
        languageCode: 'en',
        darkMode: false,
      );
}
