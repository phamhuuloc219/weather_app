import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/providers/get_current_weather_provider.dart';

class CityManager {
  CityManager(this.ref);

  final Ref ref;

  // Lưu thành phố mặc định và làm mới currentWeatherProvider
  Future<void> setDefaultCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected_city", cityName.toLowerCase());
    ref.invalidate(currentWeatherProvider);
  }

  Future<void> saveToHistory(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList("search_history") ?? [];
    final normalizedCityName = cityName.toLowerCase();

    // Xóa thành phố nếu đã tồn tại
    history.remove(normalizedCityName);

    // Thêm thành phố vào đầu danh sách
    history.insert(0, normalizedCityName);

    // Giới hạn danh sách tối đa 10 mục
    if (history.length > 10) {
      history.removeLast();
    }

    // Lưu danh sách mới vào SharedPreferences
    await prefs.setStringList("search_history", history);
  }

  // Xóa thành phố khỏi lịch sử tìm kiếm
  Future<void> deleteCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cities = prefs.getStringList("search_history") ?? [];
    final normalizedCityName = cityName.toLowerCase();
    if (cities.contains(normalizedCityName)) {
      cities.remove(normalizedCityName);
      await prefs.setStringList("search_history", cities);
    }
  }

  // Lấy danh sách lịch sử tìm kiếm
  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("search_history") ?? [];
  }
}

// Provider cung cấp CityManager
final cityProvider = Provider<CityManager>((ref) => CityManager(ref));