import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/weather_detail_screen.dart';
import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/models/daily_weather.dart';
import '/providers/get_weekly_forecast_provider.dart';
import '/utils/get_weather_icons.dart';
import '/widgets/subscript_text.dart';

class WeeklyForecastView extends ConsumerWidget {
  const WeeklyForecastView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyForecast = ref.watch(weeklyForecastProvider);
    final currentDate = DateTime.now(); // Lấy ngày hiện tại (11/06/2025, 05:10 PM +07)

    return weeklyForecast.when(
      data: (weatherData) {
        return FutureBuilder<String>(
          future: SharedPreferences.getInstance().then(
                (prefs) => prefs.getString("selected_city") ?? 'Nha Trang',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            final city = snapshot.data ?? "Nha Trang";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị "Today" với ngày hiện tại
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today",
                        style: TextStyles.h3.copyWith(color: AppColors.white),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(currentDate),
                        style: TextStyles.subtitleText.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
                // Danh sách dự báo hàng ngày
                ListView.builder(
                  itemCount: weatherData.daily.weatherCode.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final dateStr = weatherData.daily.time[index];
                    final date = DateTime.parse(dateStr);
                    final dayOfWeek = date.dayOfWeek;
                    final isToday = date.year == currentDate.year &&
                        date.month == currentDate.month &&
                        date.day == currentDate.day;

                    final iconCode = weatherData.daily.weatherCode[index];
                    final maxTemp = weatherData.daily.temperature2mMax[index];
                    final minTemp = weatherData.daily.temperature2mMin[index];
                    final windSpeech = weatherData.daily.windSpeed[index];
                    final humidity = weatherData.daily.humidity[index];
                    final iconPath = getWeatherIcon(weatherCode: iconCode);

                    final dailyWeather = DailyWeather(
                      date: date,
                      weatherCode: iconCode,
                      maxTemp: maxTemp.toDouble(),
                      minTemp: minTemp.toDouble(),
                      //windSpeed: 4.2,
                      windSpeed: windSpeech,
                      humidity: humidity,
                      feelsLike: maxTemp - 1,
                      sunrise: date.add(const Duration(hours: 5, minutes: 30)),
                      sunset: date.add(const Duration(hours: 18)),
                    );
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WeatherDetailScreen(
                              city: city,
                              date: DateFormat("yyyy-MM-dd").format(date),
                              weatherCode: iconCode,
                              maxTemp: maxTemp.toDouble(),
                              minTemp: minTemp.toDouble(),
                              windSpeed: dailyWeather.windSpeed,
                              humidity: dailyWeather.humidity.toInt(),
                              feelsLike: dailyWeather.feelsLike,
                              sunrise: DateFormat.Hm().format(dailyWeather.sunrise),
                              sunset: DateFormat.Hm().format(dailyWeather.sunset),
                            ),
                          ),
                        );
                      },
                      child: WeeklyForecastTile(
                        day: isToday ? "Today" : dayOfWeek,
                        date: DateFormat('dd/MM/yyyy').format(date),
                        temp: maxTemp.round(), // Sử dụng maxTemp làm đại diện
                        icon: iconPath,
                      ),
                    );
                  },
                ),
              ],
            );
          },
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

class WeeklyForecastTile extends StatelessWidget {
  const WeeklyForecastTile({
    super.key,
    required this.day,
    required this.date,
    required this.temp,
    required this.icon,
  });

  final String day;
  final String date;
  final int temp;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.accentBlue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(day, style: TextStyles.h3),
              const SizedBox(height: 5),
              Text(date, style: TextStyles.subtitleText),
            ],
          ),
          SuperscriptText(
            text: "$temp",
            color: AppColors.white,
            superScript: "°C",
            superscriptColor: AppColors.white,
          ),
          Image.asset(
            icon,
            width: 60,
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../screens/weather_detail_screen.dart';
// import '/constants/app_colors.dart';
// import '/constants/text_styles.dart';
// import '/extensions/datetime.dart';
// import '/models/daily_weather.dart';
// import '/providers/get_weekly_forecast_provider.dart';
// import '/utils/get_weather_icons.dart';
// import '/widgets/subscript_text.dart';
//
// class WeeklyForecastView extends ConsumerWidget {
//   const WeeklyForecastView({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final weeklyForecast = ref.watch(weeklyForecastProvider);
//
//     return weeklyForecast.when(
//       data: (weatherData) {
//         return FutureBuilder<String>(
//           future: SharedPreferences.getInstance().then(
//                 (prefs) => prefs.getString("selected_city") ?? 'Nha Trang',
//           ),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text("Error: ${snapshot.error}"));
//             }
//             final city = snapshot.data ?? "Nha Trang";
//
//             return ListView.builder(
//               itemCount: weatherData.daily.weatherCode.length,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 final dateStr = weatherData.daily.time[index];
//                 final date = DateTime.parse(dateStr);
//                 final dayOfWeek = date.dayOfWeek;
//
//                 final iconCode = weatherData.daily.weatherCode[index];
//                 final maxTemp = weatherData.daily.temperature2mMax[index];
//                 final minTemp = weatherData.daily.temperature2mMin[index];
//                 final iconPath = getWeatherIcon(weatherCode: iconCode);
//
//                 final dailyWeather = DailyWeather(
//                   date: date,
//                   weatherCode: iconCode,
//                   maxTemp: maxTemp.toDouble(),
//                   minTemp: minTemp.toDouble(),
//                   windSpeed: 4.2,
//                   humidity: 75,
//                   feelsLike: maxTemp - 1,
//                   sunrise: date.add(const Duration(hours: 5, minutes: 30)),
//                   sunset: date.add(const Duration(hours: 18)),
//                 );
//
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => WeatherDetailScreen(
//                           city: city,
//                           date: DateFormat("yyyy-MM-dd").format(date),
//                           weatherCode: iconCode,
//                           maxTemp: maxTemp.toDouble(),
//                           minTemp: minTemp.toDouble(),
//                           windSpeed: dailyWeather.windSpeed,
//                           humidity: dailyWeather.humidity.toInt(),
//                           feelsLike: dailyWeather.feelsLike,
//                           sunrise: DateFormat.Hm().format(dailyWeather.sunrise),
//                           sunset: DateFormat.Hm().format(dailyWeather.sunset),
//                         ),
//                       ),
//                     );
//                   },
//                   child: WeeklyForecastTile(
//                     day: dayOfWeek,
//                     date: dateStr,
//                     temp: maxTemp.round(),
//                     icon: iconPath,
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//       error: (error, stackTrace) {
//         return Center(child: Text(error.toString()));
//       },
//       loading: () {
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }
//
// class WeeklyForecastTile extends StatelessWidget {
//   const WeeklyForecastTile({
//     super.key,
//     required this.day,
//     required this.date,
//     required this.temp,
//     required this.icon,
//   });
//
//   final String day;
//   final String date;
//   final int temp;
//   final String icon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: AppColors.accentBlue,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             children: [
//               Text(day, style: TextStyles.h3),
//               const SizedBox(height: 5),
//               Text(date, style: TextStyles.subtitleText),
//             ],
//           ),
//           SuperscriptText(
//             text: "$temp",
//             color: AppColors.white,
//             superScript: "°C",
//             superscriptColor: AppColors.white,
//           ),
//           Image.asset(
//             icon,
//             width: 60,
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../screens/weather_detail_screen.dart';
// import '/constants/app_colors.dart';
// import '/constants/text_styles.dart';
// import '/extensions/datetime.dart';
// import '/models/daily_weather.dart';
// import '/providers/get_weekly_forecast_provider.dart';
// import '/utils/get_weather_icons.dart';
// import '/widgets/subscript_text.dart';
//
// class WeeklyForecastView extends ConsumerWidget {
//   const WeeklyForecastView({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final weeklyForecast = ref.watch(weeklyForecastProvider);
//     final currentDate = DateTime.now(); // Lấy ngày hiện tại (11/06/2025, 05:10 PM +07)
//
//     return weeklyForecast.when(
//       data: (weatherData) {
//         return FutureBuilder<String>(
//           future: SharedPreferences.getInstance().then(
//                 (prefs) => prefs.getString("selected_city") ?? 'Nha Trang',
//           ),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text("Error: ${snapshot.error}"));
//             }
//             final city = snapshot.data ?? "Nha Trang";
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Hiển thị "Today" với ngày hiện tại
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Today",
//                         style: TextStyles.h3.copyWith(color: AppColors.white),
//                       ),
//                       Text(
//                         DateFormat('dd/MM/yyyy').format(currentDate),
//                         style: TextStyles.subtitleText.copyWith(color: AppColors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Danh sách dự báo hàng ngày
//                 ListView.builder(
//                   itemCount: weatherData.daily.weatherCode.length,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     final dateStr = weatherData.daily.time[index];
//                     final date = DateTime.parse(dateStr);
//                     final dayOfWeek = date.dayOfWeek;
//                     final isToday = date.year == currentDate.year &&
//                         date.month == currentDate.month &&
//                         date.day == currentDate.day;
//
//                     final iconCode = weatherData.daily.weatherCode[index];
//                     final maxTemp = weatherData.daily.temperature2mMax[index];
//                     final minTemp = weatherData.daily.temperature2mMin[index];
//                     final iconPath = getWeatherIcon(weatherCode: iconCode);
//
//                     final dailyWeather = DailyWeather(
//                       date: date,
//                       weatherCode: iconCode,
//                       maxTemp: maxTemp.toDouble(),
//                       minTemp: minTemp.toDouble(),
//                       windSpeed: 4.2,
//                       humidity: 75,
//                       feelsLike: maxTemp - 1,
//                       sunrise: date.add(const Duration(hours: 5, minutes: 30)),
//                       sunset: date.add(const Duration(hours: 18)),
//                     );
//
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => WeatherDetailScreen(
//                               city: city,
//                               date: DateFormat("yyyy-MM-dd").format(date),
//                               weatherCode: iconCode,
//                               maxTemp: maxTemp.toDouble(),
//                               minTemp: minTemp.toDouble(),
//                               windSpeed: dailyWeather.windSpeed,
//                               humidity: dailyWeather.humidity.toInt(),
//                               feelsLike: dailyWeather.feelsLike,
//                               sunrise: DateFormat.Hm().format(dailyWeather.sunrise),
//                               sunset: DateFormat.Hm().format(dailyWeather.sunset),
//                             ),
//                           ),
//                         );
//                       },
//                       child: WeeklyForecastTile(
//                         day: isToday ? "Today" : dayOfWeek,
//                         date: DateFormat('dd/MM/yyyy').format(date),
//                         temp: maxTemp.round(), // Sử dụng maxTemp làm đại diện
//                         icon: iconPath,
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//       error: (error, stackTrace) {
//         return Center(child: Text(error.toString()));
//       },
//       loading: () {
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }
//
// class WeeklyForecastTile extends StatelessWidget {
//   const WeeklyForecastTile({
//     super.key,
//     required this.day,
//     required this.date,
//     required this.temp,
//     required this.icon,
//   });
//
//   final String day;
//   final String date;
//   final int temp;
//   final String icon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: AppColors.accentBlue,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             children: [
//               Text(day, style: TextStyles.h3),
//               const SizedBox(height: 5),
//               Text(date, style: TextStyles.subtitleText),
//             ],
//           ),
//           SuperscriptText(
//             text: "$temp",
//             color: AppColors.white,
//             superScript: "°C",
//             superscriptColor: AppColors.white,
//           ),
//           Image.asset(
//             icon,
//             width: 60,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
