import 'package:cloud_firestore/cloud_firestore.dart';
import 'calendar_source.dart';
import '../models/day_availability_model.dart';

/// مصدر Firebase لتوافر الأيام — يحفظ في calendar_availability/{spaceId}/days/{dayId}
class CalendarFirebaseSource implements CalendarSource {
  CalendarFirebaseSource({required this.spaceId});

  final String spaceId;
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _days =>
      _db.collection('calendar_availability').doc(spaceId).collection('days');

  @override
  Future<DayAvailabilityModel> fetchDay({required String dayId}) async {
    final doc = await _days.doc(dayId).get();
    if (!doc.exists) {
      return DayAvailabilityModel(dayId: dayId, closed: false, specialHours: '');
    }
    final d = doc.data()!;
    return DayAvailabilityModel(
      dayId: dayId,
      closed: d['closed'] as bool? ?? false,
      specialHours: d['specialHours'] as String? ?? '',
    );
  }

  @override
  Future<void> saveDay({required DayAvailabilityModel day}) async {
    await _days.doc(day.dayId).set({
      'closed': day.closed,
      'specialHours': day.specialHours,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
