import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/extensions/strings.dart';
import 'package:weather_app/screens/weather_detail_screen.dart';
import 'package:weather_app/screens/weather_screen/weather_info.dart';
import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/providers/get_current_weather_provider.dart';
import '/views/gradient_container.dart';
import '/views/hourly_forecast_view.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(currentWeatherProvider);

    return weatherData.when(
      data: (weather) {
        final currentDate = DateTime.fromMillisecondsSinceEpoch(weather.dt * 1000);
        final sunrise = DateTime.fromMillisecondsSinceEpoch(weather.sys.sunrise * 1000);
        final sunset = DateTime.fromMillisecondsSinceEpoch(weather.sys.sunset * 1000);

        return GradientContainer(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                Text(
                  weather.name,
                  style: TextStyles.h1,
                ),
                const SizedBox(height: 20),
                Text(
                  DateTime.now().dateTime,
                  style: TextStyles.subtitleText,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 260,
                  child: Image.asset(
                    "assets/icons/${weather.weather[0].icon.replaceAll('n', 'd')}.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  weather.weather[0].description.capitalize,
                  style: TextStyles.h2,
                ),
              ],
            ),
            const SizedBox(height: 40),
            WeatherInfo(weather: weather),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WeatherDetailScreen(
                          city: weather.name ?? 'Unknown City',
                          date: currentDate.toString(),
                          weatherCode: weather.weather[0].id ?? 0,
                          maxTemp: weather.main.temp ?? 0.0,
                          minTemp: weather.main.temp ?? 0.0,
                          windSpeed: weather.wind.speed ?? 0.0,
                          humidity: weather.main.humidity?.toInt() ?? 0,
                          feelsLike: weather.main.feelsLike ?? 0.0,
                          sunrise: sunrise.toString().substring(11, 16),
                          sunset: sunset.toString().substring(11, 16),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "View full report",
                    style: TextStyle(
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const HourlyForecastView(),
          ],
        );
      },
      error: (error, stackTrace) {
        return const Center(
          child: Text(
            "An error has occurred",
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:weather_app/constants/string.dart';
// import '../weather_detail_screen.dart';
// import '/constants/app_colors.dart';
// import '/constants/text_styles.dart';
// import '/extensions/datetime.dart';
// import '/providers/get_current_weather_provider.dart';
// import '/views/gradient_container.dart';
// import '/views/hourly_forecast_view.dart';
// import 'weather_info.dart';
//
// class WeatherScreen extends ConsumerWidget {
//   const WeatherScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final weatherData = ref.watch(currentWeatherProvider);
//
//
//     return weatherData.when(
//       data: (weather) {
//         return GradientContainer(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   width: double.infinity,
//                 ),
//                 // Country name text
//                 Text(
//                   weather.name,
//                   style: TextStyles.h1,
//                 ),
//                 const SizedBox(height: 20),
//                 // Today's date
//                 Text(
//                   DateTime.now().dateTime,
//
//                   style: TextStyles.subtitleText,
//                 ),
//                 const SizedBox(height: 30),
//                 // Weather icon big
//                 SizedBox(
//                   height: 260,
//                   child: Image.asset(
//                     'assets/icons/${weather.weather[0].icon.replaceAll('n', 'd')}.png',
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 // Weather description
//                 Text(
//                   weather.weather[0].description.capitalize,
//                   style: TextStyles.h2,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 40),
//             // Weather info in a row
//             WeatherInfo(weather: weather),
//             const SizedBox(height: 40),
//             // Today Daily Forecast
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Today',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: AppColors.white,
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) {
//                           final currentDate = DateTime.fromMillisecondsSinceEpoch(
//                             weather.dt * 1000,
//                           );
//                           return WeatherDetailScreen(
//                             city: weather.name ?? 'Unknown City',
//                             date: currentDate.toIso8601String().split('T')[0], // YYYY-MM-DD
//                             weatherCode: weather.weather[0].id ?? 0, // Giá trị mặc định nếu null
//                             maxTemp: weather.main.temp ?? 0.0, // Giá trị mặc định nếu null
//                             minTemp: weather.main.temp ?? 0.0, // Giá trị mặc định nếu null
//                             windSpeed: weather.wind.speed ?? 0.0,
//                             humidity: weather.main.humidity ?? 0, // Giá trị mặc định nếu null
//                             feelsLike: weather.main.feelsLike ?? 0.0,
//                             sunrise: DateTime.fromMillisecondsSinceEpoch(
//                               weather.sys.sunrise * 1000,
//                             ).toIso8601String().split('T')[1].substring(0, 5) ?? '00:00',
//                             sunset: DateTime.fromMillisecondsSinceEpoch(
//                               weather.sys.sunset * 1000,
//                             ).toIso8601String().split('T')[1].substring(0, 5) ?? '00:00',
//                           );
//                         },
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     'View full report',
//                     style: TextStyle(
//                       color: AppColors.lightBlue,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),
//             // hourly forecast
//             const HourlyForecastView(),
//           ],
//         );
//       },
//       error: (error, stackTrace) {
//         return const Center(
//           child: Text(
//             'An error has occurred',
//           ),
//         );
//       },
//       loading: () {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
// }
