import 'dart:convert';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';
import 'package:restaurant_app_api/data/model/restaurant_list.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static final String _list = 'list';
  static final String _detail = 'detail/';
  static final String _search = 'search?q=';
  static final String _addReview = 'review';

  final http.Client client;
  ApiService(this.client);

  Future<RestaurantList> getRestaurantList() async {
    final response = await client.get(Uri.parse(_baseUrl + _list));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(id) async {
    final response = await client.get(Uri.parse(_baseUrl + _detail + id));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantList> searchRestaurant(query) async {
    final response = await client.get(Uri.parse(_baseUrl + _search + query));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<dynamic> sendReview(String id, String name, String review) async {
    final response = await client.post(
      Uri.parse(_baseUrl + _addReview),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'X-Auth-Token': '12345',
      },
      body: jsonEncode(<String, String>{
        'id': id,
        'name': name,
        'review': review,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to make review');
    }
  }
}
