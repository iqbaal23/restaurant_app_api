import 'package:flutter/foundation.dart';
import 'package:restaurant_app_api/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyRemindersPreferences();
  }

  bool _isDailyRemindersActive = false;
  bool get isDailyRemindersActive => _isDailyRemindersActive;

  void _getDailyRemindersPreferences() async {
    _isDailyRemindersActive = await preferencesHelper.isDailyRemindersActive;
    notifyListeners();
  }

  void enableDailyReminders(bool value) {
    preferencesHelper.setDailyReminders(value);
    _getDailyRemindersPreferences();
  }
}
