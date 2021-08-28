import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/styles.dart';
import 'package:restaurant_app_api/data/model/restaurant_list.dart';
import 'package:restaurant_app_api/provider/database_provider.dart';
import 'package:restaurant_app_api/ui/restaurant_detail_page.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isBookmarked(restaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return Material(
              color: primaryColor,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new RestaurantDetailPage(
                        id: restaurant.id,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Stack(
                      children: [
                        Hero(
                          tag: restaurant.pictureId,
                          child: Image.network(
                            'https://restaurant-api.dicoding.dev/images/medium/' +
                                restaurant.pictureId,
                            height: MediaQuery.of(context).size.width * 0.5,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0x80000000),
                                const Color(0x80000000),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    left: 8.0,
                                  ),
                                  child: Text(
                                    restaurant.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    left: 8.0,
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.location_pin,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: restaurant.city,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 8,
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.star,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: restaurant.rating,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            isBookmarked
                                ? IconButton(
                                    onPressed: () =>
                                        provider.removeBookmark(restaurant.id),
                                    icon: Icon(
                                      Icons.bookmark,
                                      size: 30,
                                    ),
                                    color: Colors.white,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  )
                                : IconButton(
                                    onPressed: () =>
                                        provider.addBookmark(restaurant),
                                    icon: Icon(
                                      Icons.bookmark_border,
                                      size: 30,
                                    ),
                                    key: Key(restaurant.name),
                                    color: Colors.white,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
