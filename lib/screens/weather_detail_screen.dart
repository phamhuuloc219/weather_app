import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/providers/state_provider.dart';
import '/views/hourly_forecast_view.dart';
import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/utils/get_weather_icons.dart';
import '/views/gradient_container.dart';

class WeatherDetailScreen extends ConsumerWidget {
  final String city;
  final String date;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;
  final double windSpeed;
  final int humidity;
  final double feelsLike;
  final String sunrise;
  final String sunset;

  const WeatherDetailScreen({
    super.key,
    required this.city,
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
    required this.sunrise,
    required this.sunset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.secondaryBlack,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather Details - $city",
          style: TextStyles.h1.copyWith(decoration: TextDecoration.none),
        ),
        backgroundColor: AppColors.secondaryBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            ref.read(selectedHourProvider.notifier).state = null;
            Navigator.pop(context);
          },
        ),
      ),
      body: GradientContainer(
        children: [
          const SizedBox(height: 5),
          Center(
            child: Column(
              children: [
                Text(
                  city,
                  style: TextStyles.h1.copyWith(decoration: TextDecoration.none),
                ),
                const SizedBox(height: 10),
                Text(
                  date,
                  style: TextStyles.subtitleText.copyWith(decoration: TextDecoration.none),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  getWeatherIcon(weatherCode: weatherCode),
                  width: 180,
                  height: 180,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red, size: 180);
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "${maxTemp.toStringAsFixed(1)}° / ${minTemp.toStringAsFixed(1)}°",
                  style: TextStyles.h2.copyWith(decoration: TextDecoration.none),
                ),
                const SizedBox(height: 10),
                Text(
                  "Feel like: ${feelsLike.toStringAsFixed(1)}°C",
                  style: TextStyles.subtitleText.copyWith(decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWeatherCard(Icons.wind_power, "Wind speed", "${windSpeed.toStringAsFixed(1)} km/h"),
                    const SizedBox(width: 2),
                    _buildWeatherCard(Icons.water_drop, "Humidity", '$humidity%'),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWeatherCard(Icons.wb_sunny_outlined, "Sunrise", sunrise),
                    const SizedBox(width: 2),
                    _buildWeatherCard(Icons.nightlight_outlined, "Sunset", sunset),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                HourlyForecastView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(IconData icon, String title, String value) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.white, size: 32),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyles.h3.copyWith(decoration: TextDecoration.none),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyles.subtitleText.copyWith(decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}
