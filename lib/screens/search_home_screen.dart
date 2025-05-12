import 'package:flutter/material.dart';
import 'package:weather_app/screens/search_detail_screen.dart';
import 'package:weather_app/services/api_helper.dart';
import 'package:weather_app/screens/weather_detail_screen.dart';
import 'package:weather_app/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityWeather {
  final String name;
  final String condition;
  final String temp;
  final String tempMax;
  final String tempMin;

  CityWeather({
    required this.name,
    required this.condition,
    required this.temp,
    required this.tempMax,
    required this.tempMin,
  });
}

class SearchHomeScreen extends StatefulWidget {
  const SearchHomeScreen({super.key});

  @override
  State<SearchHomeScreen> createState() => _SearchHomeScreenState();
}

class _SearchHomeScreenState extends State<SearchHomeScreen> {
  bool isLoading = false;
  List<CityWeather> history = [];

  @override
  void initState() {
    super.initState();
    loadSearchHistory();
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('search_history') ?? [];
  }

  Future<void> loadSearchHistory() async {
    setState(() => isLoading = true);
    final cityNames = await getSearchHistory();
    final List<CityWeather> loaded = [];
    for (var city in cityNames) {
      try {
        final data = await ApiHelper.getWeatherByCityName(cityName: city);
        final temp = data.main.temp;
        final cond = data.weather[0].main;
        final max = data.main.tempMax;
        final min = data.main.tempMin;

        loaded.add(CityWeather(
          name: city,
          condition: cond,
          temp: "${temp.round()}°",
          tempMax: "${max.round()}°",
          tempMin: "${min.round()}°",
        ));
      } catch (e) {
        print('Error loading weather for $city: $e');
      }
    }
    setState(() {
      history = loaded;
      isLoading = false;
    });
  }

  Future<void> saveSelectedCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_city', cityName);
    print('Saved selected city: $cityName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SearchDetailScreen(),
                    ),
                  );
                  loadSearchHistory();
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Nhập vị trí',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: AppColors.accentBlue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              else if (history.isEmpty)
                const Center(
                  child: Text("Chưa có lịch sử tìm kiếm", style: TextStyle(color: Colors.grey)),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return buildCityCard(history[index]);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCityCard(CityWeather city) {
    return GestureDetector(
      onTap: () async {
        await saveSelectedCity(city.name); // Lưu thành phố được chọn
        final data = await ApiHelper.getWeatherByCityName(cityName: city.name);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WeatherDetailScreen(
                city: data.name,
                date: DateTime.now().toIso8601String().split("T").first,
                weatherCode: data.weather[0].id,
                maxTemp: data.main.tempMax,
                minTemp: data.main.tempMin,
                windSpeed: data.wind.speed,
                humidity: data.main.humidity ?? 0,
                feelsLike: data.main.feelsLike,
                sunrise: DateTime.fromMillisecondsSinceEpoch(data.sys.sunrise * 1000)
                    .toLocal()
                    .toString()
                    .substring(11, 16),
                sunset: DateTime.fromMillisecondsSinceEpoch(data.sys.sunset * 1000)
                    .toLocal()
                    .toString()
                    .substring(11, 16),
              ),
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.accentBlue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(city.name, style: const TextStyle(fontSize: 18, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      '${city.condition}  ${city.tempMax} / ${city.tempMin}',
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(city.temp, style: const TextStyle(fontSize: 32, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
