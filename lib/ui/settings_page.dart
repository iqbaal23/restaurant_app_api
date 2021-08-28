import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/styles.dart';
import 'package:restaurant_app_api/provider/preferences_provider.dart';
import 'package:restaurant_app_api/provider/scheduling_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: secondaryColor,
            ),
            child: ListTile(
              title: Text(
                'Scheduling Notifications',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Consumer<SchedulingProvider>(
                builder: (context, scheduled, _) {
                  return Switch.adaptive(
                    value: provider.isDailyRemindersActive,
                    onChanged: (value) async {
                      scheduled.scheduledNotifications(value);
                      provider.enableDailyReminders(value);
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
