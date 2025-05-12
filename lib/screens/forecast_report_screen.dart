import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/get_current_weather_provider.dart';
import '/constants/text_styles.dart';
import '/views/gradient_container.dart';
import '/views/hourly_forecast_view.dart';
import '/views/weekly_forecast_view.dart';

class ForecastReportScreen extends ConsumerWidget {
  const ForecastReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(currentWeatherProvider);

    return currentWeather.when(
      data: (weather) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(
          (weather.dt + weather.timezone) * 1000,
          isUtc: true,
        );

        return GradientContainer(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Forecast Report',
                style: TextStyles.h1,
              ),
            ),
            const SizedBox(height: 40),

            // Today's date with city timezone
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today',
                  style: TextStyles.h2,
                ),
                Text(
                  '${dateTime.day}/${dateTime.month}/${dateTime.year}',
                  style: TextStyles.subtitleText,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const HourlyForecastView(),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Next Forecast',
                  style: TextStyles.h2,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const WeeklyForecastView(),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('$e')),
    );
  }
}
