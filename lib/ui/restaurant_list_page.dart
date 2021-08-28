import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/provider/restaurant_list_provider.dart';
import 'package:restaurant_app_api/ui/home_page.dart';
import 'package:restaurant_app_api/widget/card_restaurant.dart';
import 'package:http/http.dart' as http;

class RestaurantListPage extends StatefulWidget {
  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search Query";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantListProvider(
        apiService: ApiService(
          http.Client(),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: _isSearching
              ? BackButton(onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(),
                    ),
                  );
                })
              : null,
          title: _isSearching ? _buildSearchField() : Text('Restaurant'),
          actions: _buildActions(),
        ),
        body: restaurantListView(),
      ),
    );
  }

  Widget restaurantListView() {
    return Consumer<RestaurantListProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultState.HasData) {
          return Container(
            padding: EdgeInsets.only(bottom: 4),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.restaurantList.restaurants.length,
              itemBuilder: (context, index) {
                return CardRestaurant(
                    restaurant: state.restaurantList.restaurants[index]);
              },
            ),
          );
        } else if (state.state == ResultState.NoData) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (state.state == ResultState.Error) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (state.state == ResultState.NoConnection) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return Center(
            child: Text('There is something wrong'),
          );
        }
      },
    );
  }

  Widget _buildSearchField() {
    return Consumer<RestaurantListProvider>(builder: (context, state, _) {
      return TextField(
          controller: _searchQueryController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search Data...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white30),
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
          onChanged: (query) {
            state.setQuery(query);
            updateSearchQuery(query);
          });
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController.text.isEmpty) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(),
                ),
              );
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(
      LocalHistoryEntry(onRemove: _stopSearching),
    );

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}
