// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '/models/hourly_weather.dart';
// import '/services/api_helper.dart';
//
// final hourlyForecastProvider = FutureProvider.autoDispose<HourlyWeather>(
//   (ref) => ApiHelper.getHourlyForecast(),
// );
//

// get_hourly_forecast_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/hourly_weather.dart';
import '/services/api_helper.dart';

final hourlyForecastProvider = FutureProvider.autoDispose<HourlyWeather>(
      (ref) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedCity = prefs.getString('selected_city') ?? 'Nha Trang';
    return ApiHelper.getHourlyForecast (cityName: selectedCity);
  },
);
