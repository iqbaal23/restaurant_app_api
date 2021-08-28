import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/styles.dart';
import 'package:restaurant_app_api/data/db/database_helper.dart';
import 'package:restaurant_app_api/data/preferences/preferences_helper.dart';
import 'package:restaurant_app_api/provider/database_provider.dart';
import 'package:restaurant_app_api/provider/preferences_provider.dart';
import 'package:restaurant_app_api/provider/scheduling_provider.dart';
import 'package:restaurant_app_api/ui/home_page.dart';
import 'package:restaurant_app_api/ui/restaurant_detail_page.dart';
import 'package:restaurant_app_api/utils/background_service.dart';
import 'package:restaurant_app_api/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();
  await AndroidAlarmManager.initialize();
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
          create: (_) => SchedulingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: primaryColor,
          accentColor: Colors.blue,
          scaffoldBackgroundColor: primaryColor,
          textTheme: myTextTheme,
        ),
        home: SplashScreenView(
          navigateRoute: HomePage(),
          duration: 3000,
          imageSrc: 'assets/images/app_icon.jpg',
          imageSize: 100,
          text: 'Restaurant App',
          textStyle: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white),
          backgroundColor: primaryColor,
        ),
        routes: {
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                id: ModalRoute.of(context)?.settings.arguments as String,
              )
        },
      ),
    );
  }
}
