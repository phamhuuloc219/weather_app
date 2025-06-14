import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/screens/weather_detail_screen.dart';
import 'package:weather_app/services/api_helper.dart';
import 'package:weather_app/constants/app_colors.dart';
import 'package:weather_app/constants/text_styles.dart';
import 'package:weather_app/providers/get_current_weather_provider.dart';

class SearchDetailScreen extends ConsumerStatefulWidget {
  const SearchDetailScreen({super.key});

  @override
  ConsumerState<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends ConsumerState<SearchDetailScreen> {
  final TextEditingController txtSearch = TextEditingController();
  bool isLoading = false;
  Map<String, dynamic>? data;
  String? error;

  IconData getWeatherIcon(String condition) {
    final c = condition.toLowerCase();
    if (c.contains("cloud")) return Icons.cloud;
    if (c.contains("rain")) return Icons.umbrella;
    if (c.contains("clear")) return Icons.wb_sunny;
    return Icons.device_unknown;
  }

  Future<void> saveToHistoryOnly(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList("search_history") ?? [];
    if (!history.contains(cityName)) {
      history.insert(0, cityName); // Thêm vào đầu
      if (history.length > 10) {
        history.removeLast(); // Xóa cuối
      }
      await prefs.setStringList("search_history", history);
    }
  }

  Future<void> setDefaultCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected_city", cityName);
    ref.invalidate(currentWeatherProvider);
  }

  Future<void> fetchWeather(String cityName) async {
    setState(() {
      isLoading = true;
      error = null;
      data = null;
    });
    try {
      final result = await ApiHelper.getWeatherByCityName(cityName: cityName);
      await saveToHistoryOnly(result.name.toLowerCase());
      setState(() => data = {
        'name': result.name,
        'condition': result.weather[0].main,
        'description': result.weather[0].description,
        'icon': result.weather[0].icon,
        'temp': result.main.temp,
        'feels_like': result.main.feelsLike,
        'humidity': result.main.humidity ?? 0,
        'temp_min': result.main.tempMin,
        'temp_max': result.main.tempMax,
        'wind_speed': result.wind.speed,
        'sunrise': result.sys.sunrise,
        'sunset': result.sys.sunset,
        'weather_code': result.weather[0].id,
      });
    } catch (e) {
      setState(() => error = "This city name was not found");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Trả về tên thành phố nếu đã tìm kiếm thành công, ngược lại trả về null
        Navigator.pop(context, data != null ? data!['name'].toLowerCase() : null);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.secondaryBlack,
        appBar: AppBar(
          title: const Text("Search location"),
          backgroundColor: AppColors.secondaryBlack,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: txtSearch,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter city name...",
                  hintStyle: const TextStyle(color: Colors.white60),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: AppColors.accentBlue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    await fetchWeather(value.trim());
                    // Không gọi Navigator.pop ở đây để giữ giao diện hiển thị
                  }
                },
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const Center(child: CircularProgressIndicator(color: Colors.white)),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.redAccent)),
              if (data != null) ...[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WeatherDetailScreen(
                          city: data!['name'],
                          date: DateTime.now().toIso8601String().split("T").first,
                          weatherCode: data!['weather_code'],
                          maxTemp: data!['temp_max'],
                          minTemp: data!['temp_min'],
                          windSpeed: data!['wind_speed'],
                          humidity: data!['humidity'],
                          feelsLike: data!['feels_like'],
                          sunrise: DateTime.fromMillisecondsSinceEpoch(data!['sunrise'] * 1000)
                              .toLocal()
                              .toString()
                              .substring(11, 16),
                          sunset: DateTime.fromMillisecondsSinceEpoch(data!['sunset'] * 1000)
                              .toLocal()
                              .toString()
                              .substring(11, 16),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          getWeatherIcon(data!["condition"]),
                          color: Colors.white,
                          size: 36,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data!["name"], style: TextStyles.h2),
                              const SizedBox(height: 4),
                              Text(data!["description"], style: TextStyles.subtitleText),
                            ],
                          ),
                        ),
                        Text("${data!["temp"].round()}°", style: TextStyles.h1),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await setDefaultCity(data!['name']);
                      // Trả về tên thành phố khi cài làm mặc định
                      Navigator.pop(context, data!['name'].toLowerCase());
                    },
                    child: Text(
                      "Set ${data!['name']} at default",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    txtSearch.dispose();
    super.dispose();
  }
}