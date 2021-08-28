import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';
import 'package:restaurant_app_api/data/model/restaurant_list.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {

  group('Module test for restaurant list api', () {
    test('return restaurant list if the http call completes successfully',
        () async {
      final client = MockClient();
      final jsonFile = new File('test/assets/restaurant_list.json');
      final resultActual = await jsonFile.readAsString();

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(resultActual, 200));

      expect(
          await ApiService(client).getRestaurantList(), isA<RestaurantList>());
    });

    test('throw an exception if the http call completes with an error', () {
      final client = MockClient();

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService(client).getRestaurantList(), throwsException);
    });
  });
  
  group('Module test for restaurant detail api', () {
    test('return restaurant detail if the http call completes successfully',
        () async {
      final client = MockClient();
      final jsonFile = new File('test/assets/restaurant_detail.json');
      final resultActual = await jsonFile.readAsString();

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response(resultActual, 200));

      expect(await ApiService(client).getRestaurantDetail('rqdv5juczeskfw1e867'), isA<RestaurantDetail>());
    });

    test('throw an exception if the http call completes with an error', () {
      final client = MockClient();

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService(client).getRestaurantDetail('rqdv5juczeskfw1e867'), throwsException);
    });
  });

  group('Module test for restaurant search api', () {
    test('return restaurant search if the http call completes successfully',
        () async {
      final client = MockClient();
      final jsonFile = new File('test/assets/restaurant_search.json');
      final resultActual = await jsonFile.readAsString();

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/search?q=kafein')))
          .thenAnswer((_) async => http.Response(resultActual, 200));

      expect(await ApiService(client).searchRestaurant('kafein'), isA<RestaurantList>());
    });

    test('throw an exception if the http call completes with an error', () {
      final client = MockClient();

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/search?q=kafein')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService(client).searchRestaurant('kafein'), throwsException);
    });
  });

}
