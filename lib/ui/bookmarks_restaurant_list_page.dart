import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/provider/database_provider.dart';
import 'package:restaurant_app_api/widget/card_restaurant.dart';

class BookmarksRestaurantListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmakrs'),
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.HasData) {
            return ListView.builder(
              itemCount: provider.bookmarks.length,
              itemBuilder: (context, index) {
                return CardRestaurant(restaurant: provider.bookmarks[index]);
              },
            );
          } else {
            return Center(
              child: Text(
                provider.message,
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}
