class DailyWeather {
  final DateTime date;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;

  final double windSpeed;
  final double humidity;
  final double feelsLike;
  final DateTime sunrise;
  final DateTime sunset;

  DailyWeather({
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
}
