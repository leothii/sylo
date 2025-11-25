import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _streakKey = 'current_streak';
  static const String _lastActionKey = 'last_action_date';

  /// Call this to DISPLAY the streak without changing it
  Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final int streak = prefs.getInt(_streakKey) ?? 0;
    final String? lastActionString = prefs.getString(_lastActionKey);

    if (lastActionString == null || streak == 0) return 0;

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime lastAction = DateTime.parse(lastActionString);
    final DateTime yesterday = today.subtract(const Duration(days: 1));

    // If they did it today or yesterday, show the streak.
    if (lastAction == today || lastAction == yesterday) {
      return streak;
    }

    // If they missed yesterday, the visual streak is broken (0)
    return 0;
  }

  /// Call this ONLY when the user performs a task (Quiz/Search)
  Future<void> completeTaskAndIncrement() async {
    final prefs = await SharedPreferences.getInstance();

    final int currentStreak = prefs.getInt(_streakKey) ?? 0;
    final String? lastActionString = prefs.getString(_lastActionKey);

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    if (lastActionString == null) {
      await _saveData(prefs, 1, today);
      return;
    }

    final DateTime lastAction = DateTime.parse(lastActionString);

    if (lastAction == today) return; // Already done today

    final DateTime yesterday = today.subtract(const Duration(days: 1));

    if (lastAction == yesterday) {
      await _saveData(prefs, currentStreak + 1, today);
    } else {
      await _saveData(prefs, 1, today);
    }
  }

  Future<void> _saveData(
    SharedPreferences prefs,
    int streak,
    DateTime date,
  ) async {
    await prefs.setInt(_streakKey, streak);
    await prefs.setString(_lastActionKey, date.toIso8601String());
  }
}
