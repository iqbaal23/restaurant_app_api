import 'dart:ui';
import 'dart:isolate';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/main.dart';
import 'package:restaurant_app_api/utils/notification_helper.dart';
import 'package:http/http.dart' as http;

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _service;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._createObject();

  factory BackgroundService() {
    if (_service == null) {
      _service = BackgroundService._createObject();
    }
    return _service!;
  }

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper _notificationHelper = NotificationHelper();
    var restaurants = await ApiService(http.Client()).getRestaurantList();
    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, restaurants);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
