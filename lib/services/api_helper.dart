import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show immutable;
import '/constants/constants.dart';
import '/models/hourly_weather.dart';
import '/models/weather.dart';
import '/models/weekly_weather.dart';
import '/utils/logging.dart';

@immutable
class ApiHelper {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5';
  static double lat = 0.0;
  static double lon = 0.0;
  static final dio = Dio(); // client duy nhat de goi api


  //* Hourly Weather
  static Future<HourlyWeather> getHourlyForecast({String? cityName}) async {
    if (cityName != null) {
      final cityWeather = await getWeatherByCityName(cityName: cityName);
      lat = cityWeather.coord.lat;
      lon = cityWeather.coord.lon;
    }
    final url = _constructForecastUrl();
    final response = await _fetchData(url);
    return HourlyWeather.fromJson(response);
  }


  static Future<WeeklyWeather> getWeeklyForecast({String? cityName}) async {
    if (cityName != null) {
      final cityWeather = await getWeatherByCityName(cityName: cityName);
      lat = cityWeather.coord.lat;
      lon = cityWeather.coord.lon;
    }
    final url = _constructWeeklyForecastUrl();
    final response = await _fetchData(url);
    final data = response as Map<String, dynamic>;
    final dailyData = <Map<String, dynamic>>[];
    final dates = <String>{};
    for (var item in data['list']) {
      final date = DateTime.parse(item['dt_txt'].substring(0, 10));
      final dateStr = date.toIso8601String().substring(0, 10);
      if (!dates.contains(dateStr)) {
        dates.add(dateStr);
        dailyData.add(item);
      }
    }
    return WeeklyWeather.fromJson({'list': dailyData});
  }



  //* Weather by City Name
  static Future<Weather> getWeatherByCityName({
    required String cityName,
  }) async {
    final url = _constructWeatherByCityUrl(cityName);
    final response = await _fetchData(url);
    return Weather.fromJson(response);
  }

  //! Build urls
  static String _constructWeatherUrl() =>
      '$baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=${Constants.apiKey}';

  static String _constructForecastUrl() =>
      '$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=${Constants.apiKey}';

  static String _constructWeatherByCityUrl(String cityName) =>
      '$baseUrl/weather?q=$cityName&units=metric&appid=${Constants.apiKey}';


  static String _constructWeeklyForecastUrl() =>
      '$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=${Constants.apiKey}';

  //* Fetch Data for a url
  static Future<Map<String, dynamic>> _fetchData(String url) async {
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        printWarning("Failed to load data: ${response.statusCode}");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      printWarning("Error fetching data from $url: $e");
      throw Exception("Error fetching data");
    }
  }
}