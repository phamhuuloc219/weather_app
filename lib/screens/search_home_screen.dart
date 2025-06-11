import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/city_weather.dart';
import 'package:weather_app/providers/search_provider.dart';
import 'package:weather_app/screens/search_detail_screen.dart';
import 'package:weather_app/screens/weather_detail_screen.dart';
import 'package:weather_app/services/api_helper.dart';
import 'package:weather_app/constants/app_colors.dart';

class SearchHomeScreen extends ConsumerStatefulWidget {
  const SearchHomeScreen({super.key});

  @override
  ConsumerState<SearchHomeScreen> createState() => _SearchHomeScreenState();
}

class _SearchHomeScreenState extends ConsumerState<SearchHomeScreen> {
  bool isLoading = false;
  List<CityWeather> history = [];

  @override
  void initState() {
    super.initState();
    loadSearchHistory();
  }

  Future<void> loadSearchHistory() async {
    setState(() => isLoading = true);
    try {
      final cityNames = await ref.read(cityProvider).getSearchHistory();
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
          continue; // Bỏ qua thành phố không hợp lệ
        }
      }
      setState(() {
        history = loaded;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        history = [];
      });
    }
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
                  final newCity = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SearchDetailScreen(),
                    ),
                  );
                  if (newCity != null) {
                    await loadSearchHistory();
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter location",
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
                  child: Text("No search history",
                      style: TextStyle(color: Colors.grey)),
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
                    Text(city.name.toCapitalCase(),
                        style: const TextStyle(fontSize: 18, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      "${city.condition}  ${city.tempMax} / ${city.tempMin}",
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(city.temp,
                  style: const TextStyle(fontSize: 32, color: Colors.white)),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (String value) async {
                  if (value == "delete") {
                    await ref.read(cityProvider).deleteCity(city.name);
                    setState(() {
                      history = history.where((c) => c.name != city.name).toList();
                    });
                  } else if (value == "setDefault") {
                    await ref.read(cityProvider).setDefaultCity(city.name);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${city.name} set as default city")),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: "delete",
                    child: Text("Delete"),
                  ),
                  const PopupMenuItem(
                    value: "setDefault",
                    child: Text("Set as default"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
