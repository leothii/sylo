import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _keyStreakCount = 'sylo_streak_count';
  static const String _keyLastDate = 'sylo_last_streak_date';
  static const String _keyActiveDates = 'sylo_active_dates_list';

  // Updates the streak when a user chats
  static Future<bool> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final lastDateStr = prefs.getString(_keyLastDate);
    int currentStreak = prefs.getInt(_keyStreakCount) ?? 0;
    List<String> activeDates = prefs.getStringList(_keyActiveDates) ?? [];

    if (lastDateStr == null) {
      await _saveData(prefs, 1, today, activeDates);
      return true;
    }

    final lastDate = DateTime.parse(lastDateStr);

    if (today.isAtSameMomentAs(lastDate)) {
      return false;
    } else if (today.difference(lastDate).inDays == 1) {
      await _saveData(prefs, currentStreak + 1, today, activeDates);
      return true;
    } else {
      await _saveData(prefs, 1, today, activeDates);
      return true;
    }
  }

  static Future<void> _saveData(
    SharedPreferences prefs,
    int streak,
    DateTime today,
    List<String> activeDates,
  ) async {
    String todayStr = today.toIso8601String();
    if (!activeDates.contains(todayStr)) {
      activeDates.add(todayStr);
    }
    activeDates.removeWhere((date) {
      final d = DateTime.parse(date);
      return today.difference(d).inDays > 7;
    });

    await prefs.setInt(_keyStreakCount, streak);
    await prefs.setString(_keyLastDate, todayStr);
    await prefs.setStringList(_keyActiveDates, activeDates);
  }

  // Returns the total streak count
  static Future<int> getStreakCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyStreakCount) ?? 0;
  }

  // Returns the active days for the weekly dots
  static Future<Set<int>> getActiveWeekdays() async {
    final prefs = await SharedPreferences.getInstance();
    final activeStrings = prefs.getStringList(_keyActiveDates) ?? [];
    final Set<int> activeWeekdays = {};
    final now = DateTime.now();

    for (String dateStr in activeStrings) {
      DateTime date = DateTime.parse(dateStr);
      if (now.difference(date).inDays < 8) {
        activeWeekdays.add(date.weekday);
      }
    }
    return activeWeekdays;
  }

  // --- NEW METHOD ADDED HERE ---
  /// Returns true if the user has already chatted TODAY.
  static Future<bool> hasChattedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateStr = prefs.getString(_keyLastDate);
    if (lastDateStr == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime.parse(lastDateStr);

    return today.isAtSameMomentAs(lastDate);
  }
}
