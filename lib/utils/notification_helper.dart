import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app_api/data/model/restaurant_list.dart';
import 'package:restaurant_app_api/ui/restaurant_detail_page.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;
  int randomNumber = Random().nextInt(20);

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('Notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantList restaurants) async {
    var _channelId = '1';
    var _channelName = 'channel_01';
    var _channelDescription = 'Restaurant Notifications';

    var notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            _channelId, _channelName, _channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            styleInformation: DefaultStyleInformation(true, true)));

    var titleNotification = '<b>Recomendation Restaurant</b>';
    var titleRecommendation = restaurants.restaurants[randomNumber].name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleRecommendation, notificationDetails,
        payload: restaurants.restaurants[randomNumber].id);
  }

  void configureSelectNotificationSubject(BuildContext context, String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new RestaurantDetailPage(id: payload)));
    });
  }
}
