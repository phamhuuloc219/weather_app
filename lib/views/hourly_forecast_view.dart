import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/providers/state_provider.dart';
import 'package:weather_app/screens/weather_detail_screen.dart';
import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/int.dart';
import '/providers/get_hourly_forecast_provider.dart';
import '/providers/get_current_weather_provider.dart';
import '/utils/get_weather_icons.dart';

class HourlyForecastView extends ConsumerWidget {
  const HourlyForecastView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hourlyWeather = ref.watch(hourlyForecastProvider);
    final currentWeather = ref.watch(currentWeatherProvider);
    final selectedHour = ref.watch(selectedHourProvider);

    return hourlyWeather.when(
      data: (hourlyForecast) {
        return currentWeather.when(
          data: (weather) {
            final city = weather.name ?? 'Unknown City';
            final sunrise = (weather.sys.sunrise * 1000).time; // Sử dụng extension
            final sunset = (weather.sys.sunset * 1000).time; // Sử dụng extension

            return SizedBox(
              height: 100,
              child: ListView.builder(
                itemCount: 12,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final forecast = hourlyForecast.list[index];
                  final isActive = selectedHour != null && forecast.dt == selectedHour;

                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedHourProvider.notifier).state = forecast.dt;
                      final formattedTime = forecast.dt.time; // Lấy giờ từ timestamp
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WeatherDetailScreen(
                            city: city,
                            date: formattedTime, // Truyền giờ đã định dạng
                            weatherCode: forecast.weather[0].id ?? 0,
                            maxTemp: forecast.main.temp ?? 0.0,
                            minTemp: forecast.main.temp ?? 0.0,
                            windSpeed: forecast.wind.speed ?? 0.0,
                            humidity: forecast.main.humidity?.toInt() ?? 0,
                            feelsLike: forecast.main.feelsLike ?? 0.0,
                            sunrise: sunrise,
                            sunset: sunset,
                          ),
                        ),
                      );
                    },
                    child: HourlyForcastTile(
                      id: forecast.weather.isNotEmpty ? forecast.weather[0].id ?? 0 : 0,
                      hour: forecast.dt.time,
                      temp: forecast.main.temp.round(),
                      isActive: isActive,
                    ),
                  );
                },
              ),
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text(error.toString()));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class HourlyForcastTile extends StatelessWidget {
  const HourlyForcastTile({
    super.key,
    required this.id,
    required this.hour,
    required this.temp,
    required this.isActive,
  });

  final int id;
  final String hour;
  final int temp;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
      child: Material(
        color: isActive ? AppColors.lightBlue : AppColors.accentBlue,
        borderRadius: BorderRadius.circular(15.0),
        elevation: isActive ? 8 : 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                getWeatherIcon(weatherCode: id),
                width: 50,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hour,
                    style: const TextStyle(color: AppColors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$temp°',
                    style: TextStyles.h3,
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
