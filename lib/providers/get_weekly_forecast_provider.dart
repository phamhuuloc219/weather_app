import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/weekly_weather.dart';
import '/services/api_helper.dart';

final weeklyForecastProvider = FutureProvider.autoDispose<WeeklyWeather>(
      (ref) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedCity = prefs.getString("selected_city") ?? "Nha Trang";
    final weatherData = await ApiHelper.getWeeklyForecast(cityName: selectedCity);
    return weatherData;
  },
);

