import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getSearchHistory() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('search_history') ?? [];
}

Future<void> saveSelectedCity(String cityName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('selected_city', cityName);
}