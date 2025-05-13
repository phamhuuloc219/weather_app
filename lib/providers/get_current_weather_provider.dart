// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '/services/api_helper.dart';
//
// final currentWeatherProvider = FutureProvider.autoDispose(
//   (ref) => ApiHelper.getCurrentWeather(),
// );


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/services/api_helper.dart';

final currentWeatherProvider = FutureProvider((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final selectedCity = prefs.getString('selected_city') ?? 'Nha Trang'; // Mặc định là
  return await ApiHelper.getWeatherByCityName(cityName: selectedCity);
});

