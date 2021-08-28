import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const DAILY_REMINDERS = 'DAILY_REMINDERS';

  Future<bool> get isDailyRemindersActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DAILY_REMINDERS) ?? false;
  }

  void setDailyReminders(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DAILY_REMINDERS, value);
  }
}
