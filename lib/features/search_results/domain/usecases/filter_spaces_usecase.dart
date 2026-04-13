import '../entities/space_entity.dart';

class FilterSpacesUseCase {
  const FilterSpacesUseCase();

  List<SpaceEntity> call({
    required List<SpaceEntity> spaces,
    required Map<String, dynamic> selectedFilters,
  }) {
    final openNow = selectedFilters['openNow'] == true;
    final days = (selectedFilters['days'] as List?)?.map((e) => e.toString()).toSet() ?? <String>{};
    final crowdLevels = (selectedFilters['crowdLevels'] as List?)?.map((e) => e.toString().toLowerCase()).toSet() ?? <String>{};
    final paymentMethods = (selectedFilters['paymentMethods'] as List?)?.map((e) => e.toString().toLowerCase()).toSet() ?? <String>{};

    return spaces.where((space) {
      if (openNow && !_isOpenNow(space.workingHours)) return false;
      if (days.isNotEmpty && !_matchesDays(space.workingHours, days)) return false;

      if (crowdLevels.isNotEmpty) {
        final level = _crowdLevel(space).toLowerCase();
        if (!crowdLevels.contains(level)) return false;
      }

      if (paymentMethods.isNotEmpty) {
        final methods = space.paymentMethods.map((e) => e.toLowerCase()).toSet();
        if (methods.intersection(paymentMethods).isEmpty) return false;
      }

      return true;
    }).toList(growable: false);
  }

  bool _matchesDays(Map<String, dynamic> workingHours, Set<String> selectedDays) {
    if (workingHours.isEmpty) return false;
    final keys = workingHours.keys.map((e) => e.toLowerCase()).toSet();
    return selectedDays.any((d) => keys.contains(d.toLowerCase()));
  }

  bool _isOpenNow(Map<String, dynamic> workingHours) {
    if (workingHours.isEmpty) return false;
    final now = DateTime.now();
    final day = _weekdayKey(now.weekday).toLowerCase();
    final todayRaw = workingHours[day] ?? workingHours[_weekdayShort(now.weekday)] ?? workingHours[_weekdayShort(now.weekday).toUpperCase()];
    if (todayRaw == null) return false;
    final range = todayRaw.toString();
    final parts = range.split('-');
    if (parts.length != 2) return false;

    final open = _parseHourMinute(parts[0].trim());
    final close = _parseHourMinute(parts[1].trim());
    if (open == null || close == null) return false;

    final nowMinutes = now.hour * 60 + now.minute;
    return nowMinutes >= open && nowMinutes <= close;
  }

  int? _parseHourMinute(String value) {
    final p = value.split(':');
    if (p.length != 2) return null;
    final h = int.tryParse(p[0]);
    final m = int.tryParse(p[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  String _crowdLevel(SpaceEntity space) {
    if (space.totalSeats <= 0) return 'medium';
    final availableRatio = (space.totalSeats - space.currentBookings) / space.totalSeats;
    if (availableRatio > 0.5) return 'low';
    if (availableRatio >= 0.25) return 'medium';
    return 'high';
  }

  String _weekdayKey(int weekday) {
    const map = {
      1: 'monday',
      2: 'tuesday',
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
    };
    return map[weekday] ?? 'monday';
  }

  String _weekdayShort(int weekday) {
    const map = {
      1: 'mon',
      2: 'tue',
      3: 'wed',
      4: 'thu',
      5: 'fri',
      6: 'sat',
      7: 'sun',
    };
    return map[weekday] ?? 'mon';
  }
}
