import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app_api/utils/background_service.dart';
import 'package:restaurant_app_api/utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledNotifications(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling Notifications Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Notifications Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
