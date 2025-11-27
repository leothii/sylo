import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  // --- HELPER: Get Current User ID ---
  static String _getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("⚠️ StreakService: No user logged in. Using 'guest'.");
      return 'guest';
    }
    debugPrint("✅ StreakService: Active User: ${user.uid}");
    return user.uid;
  }

  // --- KEYS (Now functions to always get the latest UID) ---
  static String _keyStreakCount() => 'sylo_streak_count_${_getUserId()}';
  static String _keyLastDate() => 'sylo_last_streak_date_${_getUserId()}';
  static String _keyActiveDates() => 'sylo_active_dates_list_${_getUserId()}';

  // --- UPDATE LOGIC ---
  static Future<bool> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final keyDate = _keyLastDate();
    final keyCount = _keyStreakCount();
    final keyDates = _keyActiveDates();

    final lastDateStr = prefs.getString(keyDate);
    int currentStreak = prefs.getInt(keyCount) ?? 0;
    List<String> activeDates = prefs.getStringList(keyDates) ?? [];

    // 1. First time ever
    if (lastDateStr == null) {
      debugPrint("🔥 Streak started! (1 Day)");
      await _saveData(prefs, 1, today, activeDates);
      return true;
    }

    final lastDate = DateTime.parse(lastDateStr);

    // 2. Already chatted today
    if (today.isAtSameMomentAs(lastDate)) {
      debugPrint("🔥 Already chatted today. Streak: $currentStreak");
      return false;
    }
    // 3. Chatted yesterday (Increment)
    else if (today.difference(lastDate).inDays == 1) {
      debugPrint("🔥 Streak incremented! (${currentStreak + 1} Days)");
      await _saveData(prefs, currentStreak + 1, today, activeDates);
      return true;
    }
    // 4. Broken streak (Reset)
    else {
      debugPrint("💔 Streak broken. Reset to 1.");
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
    // Cleanup old dates
    activeDates.removeWhere((date) {
      final d = DateTime.parse(date);
      return today.difference(d).inDays > 7;
    });

    await prefs.setInt(_keyStreakCount(), streak);
    await prefs.setString(_keyLastDate(), todayStr);
    await prefs.setStringList(_keyActiveDates(), activeDates);
  }

  // --- GETTERS ---

  static Future<int> getStreakCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_keyStreakCount()) ?? 0;
    debugPrint("📊 Loaded Streak Count: $count for ${_getUserId()}");
    return count;
  }

  static Future<Set<int>> getActiveWeekdays() async {
    final prefs = await SharedPreferences.getInstance();
    final activeStrings = prefs.getStringList(_keyActiveDates()) ?? [];
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

  static Future<bool> hasChattedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateStr = prefs.getString(_keyLastDate());
    if (lastDateStr == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime.parse(lastDateStr);

    return today.isAtSameMomentAs(lastDate);
  }
}
