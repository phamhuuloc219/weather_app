// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '/models/weekly_weather.dart';
// import '/services/api_helper.dart';
//
// final weeklyForecastProvider = FutureProvider.autoDispose<WeeklyWeather>(
//   (ref) => ApiHelper.getWeeklyForecast(),
// );

// get_weekly_forecast_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/weekly_weather.dart';
import '/services/api_helper.dart';

final weeklyForecastProvider = FutureProvider.autoDispose<WeeklyWeather>(
      (ref) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedCity = prefs.getString('selected_city') ?? 'Nha Trang';
    return ApiHelper.getWeeklyForecast(cityName: selectedCity);
  },
);
