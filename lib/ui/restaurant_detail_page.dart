import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/styles.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';
import 'package:restaurant_app_api/data/model/restaurant_list.dart' as res_list;
import 'package:restaurant_app_api/provider/database_provider.dart' as db;
import 'package:restaurant_app_api/provider/restaurant_detail_provider.dart';
import 'package:http/http.dart' as http;

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final String id;
  const RestaurantDetailPage({required this.id});

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantDetailProvider(
        apiService: ApiService(http.Client()),
        id: widget.id,
      ),
      child: Consumer<RestaurantDetailProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.state == ResultState.HasData) {
            return _content(context, state.restaurantDetail.restaurant);
          } else if (state.state == ResultState.NoData) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          } else if (state.state == ResultState.Error) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                'There is something wrong',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Scaffold _content(BuildContext context, Restaurant restaurant) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Column(
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    color: secondaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          restaurant.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Consumer<db.DatabaseProvider>(
                          builder: (context, provider, child) {
                            return FutureBuilder<bool>(
                                future: provider.isBookmarked(restaurant.id),
                                builder: (context, snapshot) {
                                  var isBookmarked = snapshot.data ?? false;
                                  return isBookmarked
                                      ? IconButton(
                                          onPressed: () => provider
                                              .removeBookmark(restaurant.id),
                                          icon: Icon(
                                            Icons.bookmark,
                                            size: 30,
                                          ),
                                          color: Colors.white,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                        )
                                      : IconButton(
                                          onPressed: () => provider.addBookmark(
                                            res_list.Restaurant(
                                              id: restaurant.id,
                                              name: restaurant.name,
                                              description:
                                                  restaurant.description,
                                              pictureId: restaurant.pictureId,
                                              city: restaurant.city,
                                              rating:
                                                  restaurant.rating.toString(),
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.bookmark_border,
                                            size: 30,
                                          ),
                                          color: Colors.white,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                        );
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    size: 32,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.city,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Jl. Lorem Ipsum No. 10',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: IgnorePointer(
                child: RatingBar(
                  initialRating: restaurant.rating,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 16.0,
                  ),
                  ratingWidget: RatingWidget(
                    full: Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    half: Icon(
                      Icons.star_half,
                      color: Colors.amber,
                    ),
                    empty: Icon(
                      Icons.star_border_outlined,
                      color: Colors.amber,
                    ),
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    restaurant.description,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Foods',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: restaurant.menus.foods
                          .map(
                            (food) => Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                color: thirdColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  food.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Drinks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: restaurant.menus.drinks
                          .map(
                            (drink) => Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                color: thirdColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  drink.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: restaurant.customerReviews
                            .map(
                              (review) => Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                  vertical: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: thirdColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            review.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            review.date,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.white,
                                        height: 8,
                                        thickness: 0.5,
                                      ),
                                      Text(
                                        review.review,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF6d7885),
        child: Icon(Icons.rate_review),
        onPressed: () {
          showReviewDialog(context, restaurant.id);
        },
      ),
    );
  }

  showReviewDialog(BuildContext context, String id) {
    TextEditingController nameController = new TextEditingController();
    TextEditingController reviewController = new TextEditingController();

    Widget cancelButton = TextButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.blue,
        ),
        child: Text(
          "Cancel",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget reviewButton = TextButton(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.blue,
        ),
        child: Text(
          "Send",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        final snackBar = SnackBar(
          content: FutureBuilder(
              future: ApiService(http.Client()).sendReview(
                id,
                nameController.text,
                reviewController.text,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Successfully Give a Review!');
                } else {
                  return Text('Failed to Give a Review!');
                }
              }),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
        Future.delayed(const Duration(milliseconds: 100), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => super.widget,
            ),
          );
        });
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        "Review the Restaurant",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Name',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: thirdColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: nameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: 'Type your name',
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 16.0, bottom: 4),
              child: Text(
                'Review',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: thirdColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: 'Type your review',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
        reviewButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
