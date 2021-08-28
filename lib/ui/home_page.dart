import 'package:flutter/material.dart';
import 'package:restaurant_app_api/common/styles.dart';
import 'package:restaurant_app_api/ui/bookmarks_restaurant_list_page.dart';
import 'package:restaurant_app_api/ui/restaurant_detail_page.dart';
import 'package:restaurant_app_api/ui/restaurant_list_page.dart';
import 'package:restaurant_app_api/ui/settings_page.dart';
import 'package:restaurant_app_api/utils/notification_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int _bottomNavIndex = 0;

  List<Widget> _listWidget = [
    RestaurantListPage(),
    BookmarksRestaurantListPage(),
    SettingsPage(),
  ];

  List<BottomNavigationBarItem> _bottomNavBarItem = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.bookmark,
        key: Key('bookmark_button_nav'),
      ),
      label: 'Favorite',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(
        context, RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: secondaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
        items: _bottomNavBarItem,
        currentIndex: _bottomNavIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
