import 'package:flutter/cupertino.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  String id;

  RestaurantDetailProvider({required this.apiService, required this.id}) {
    _getRestaurantDetail(id);
  }

  late RestaurantDetail _restaurantDetail;
  String _message = '';
  late ResultState _state;

  String get message => _message;
  RestaurantDetail get restaurantDetail => _restaurantDetail;
  ResultState get state => _state;

  void refresh(String id) {
    _getRestaurantDetail(id);
    notifyListeners();
  }

  Future<dynamic> _getRestaurantDetail(id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurantDetail(id);
      if (restaurant.error) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantDetail = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
