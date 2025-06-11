class Current {
  final String time;
  final int interval;

  Current({
    required this.time,
    required this.interval,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
    time: json["time"] as String,
    interval: json["interval"] as int,
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "interval": interval,
  };
}

class Daily {
  final List<String> time;
  final List<int> weatherCode;
  final List<double> temperature2mMax;
  final List<double> temperature2mMin;
  final List<double> windSpeed;
  final List<double> humidity;
  final List<double> feelsLike;

  Daily({
    required this.time,
    required this.weatherCode,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      time: List<String>.from(json["time"] as List<dynamic>),
      weatherCode: List<int>.from(json["weather_code"] as List<dynamic>),
      temperature2mMax: List<double>.from(json["temperature_2m_max"] as List<dynamic>),
      temperature2mMin: List<double>.from(json["temperature_2m_min"] as List<dynamic>),
      windSpeed: List<double>.from(json["windspeech"]  as List<dynamic>),
      humidity: List<double>.from(json["humidity"]  as List<dynamic>),
      feelsLike: List<double>.from(json["feelslike"]  as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    "time": time,
    "weather_code": weatherCode,
    "temperature_2m_max": temperature2mMax,
    "temperature_2m_min": temperature2mMin,
    "windspeech": windSpeed,
    "humidity": humidity,
    "feelslike": feelsLike,
  };
}

class WeeklyWeather {
  final List<Map<String, dynamic>> list; // Danh sách bản ghi từ OpenWeatherMap

  WeeklyWeather({required this.list});

  factory WeeklyWeather.fromJson(Map<String, dynamic> json) {
    return WeeklyWeather(list: List<Map<String, dynamic>>.from(json['list'] ?? []));
  }

  Daily get daily {
    return Daily(
      time: list.map((e) => (e['dt_txt'] as String).substring(0, 10)).toList(),
      weatherCode: list.map((e) => e['weather'][0]['id'] as int).toList(),
      temperature2mMax: list
          .map((e) => (e['main']['temp_max'] is int
          ? (e['main']['temp_max'] as int).toDouble()
          : e['main']['temp_max'] as double)
          .toDouble())
          .toList(),
      temperature2mMin: list
          .map((e) => (e['main']['temp_min'] is int
          ? (e['main']['temp_min'] as int).toDouble()
          : e['main']['temp_min'] as double)
          .toDouble())
          .toList(),
      humidity: list
          .map((e) => (e['main']['humidity'] is int
          ? (e['main']['humidity'] as int).toDouble()
          : e['main']['humidity'] as double)
          .toDouble())
          .toList(),
      windSpeed: list
          .map((e) => (e['wind']['speed'] is int
          ? (e['wind']['speed'] as int).toDouble()
          : e['wind']['speed'] as double)
          .toDouble())
          .toList(),
      feelsLike: list
          .map((e) => (e['main']['feels_like'] is int
          ? (e['main']['feels_like'] as int).toDouble()
          : e['main']['feels_like'] as double)
          .toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'list': list,
  };
}

class CurrentUnits {
  final String time;
  final String interval;

  CurrentUnits({required this.time, required this.interval});

  factory CurrentUnits.fromJson(Map<String, dynamic> json) => CurrentUnits(
    time: json["time"] as String,
    interval: json["interval"] as String,
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "interval": interval,
  };
}

class DailyUnits {
  final String time;
  final String weatherCode;
  final String temperature2mMax;
  final String temperature2mMin;

  DailyUnits({
    required this.time,
    required this.weatherCode,
    required this.temperature2mMax,
    required this.temperature2mMin,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
    time: json["time"] as String,
    weatherCode: json["weather_code"] as String,
    temperature2mMax: json["temperature_2m_max"] as String,
    temperature2mMin: json["temperature_2m_min"] as String,
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "weather_code": weatherCode,
    "temperature_2m_max": temperature2mMax,
    "temperature_2m_min": temperature2mMin,
  };
}



// class Current {
//   final String time;
//   final int interval;
//
//   Current({
//     required this.time,
//     required this.interval,
//   });
//
//   factory Current.fromJson(Map<String, dynamic> json) => Current(
//     time: json["time"] as String,
//     interval: json["interval"] as int,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "time": time,
//     "interval": interval,
//   };
// }
//
// class Daily {
//   final List<String> time;
//   final List<int> weatherCode;
//   final List<double> temperature2mMax;
//   final List<double> temperature2mMin;
//
//   Daily({
//     required this.time,
//     required this.weatherCode,
//     required this.temperature2mMax,
//     required this.temperature2mMin,
//   });
//
//   factory Daily.fromJson(Map<String, dynamic> json) {
//     return Daily(
//       time: List<String>.from(json["time"] as List<dynamic>),
//       weatherCode: List<int>.from(json["weather_code"] as List<dynamic>),
//       temperature2mMax: List<double>.from(json["temperature_2m_max"] as List<dynamic>),
//       temperature2mMin: List<double>.from(json["temperature_2m_min"] as List<dynamic>),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "time": time,
//     "weather_code": weatherCode,
//     "temperature_2m_max": temperature2mMax,
//     "temperature_2m_min": temperature2mMin,
//   };
// }
//
// class WeeklyWeather {
//   final List<Map<String, dynamic>> list; // Danh sách bản ghi từ OpenWeatherMap
//
//   WeeklyWeather({required this.list});
//
//   factory WeeklyWeather.fromJson(Map<String, dynamic> json) {
//     return WeeklyWeather(list: List<Map<String, dynamic>>.from(json['list'] ?? []));
//   }
//
//   Daily get daily {
//     return Daily(
//       time: list.map((e) => (e['dt_txt'] as String).substring(0, 10)).toList(),
//       weatherCode: list.map((e) => e['weather'][0]['id'] as int).toList(),
//       temperature2mMax: list
//           .map((e) => (e['main']['temp_max'] is int
//           ? (e['main']['temp_max'] as int).toDouble()
//           : e['main']['temp_max'] as double)
//           .toDouble())
//           .toList(),
//       temperature2mMin: list
//           .map((e) => (e['main']['temp_min'] is int
//           ? (e['main']['temp_min'] as int).toDouble()
//           : e['main']['temp_min'] as double)
//           .toDouble())
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'list': list,
//   };
// }
//
// class CurrentUnits {
//   final String time;
//   final String interval;
//
//   CurrentUnits({required this.time, required this.interval});
//
//   factory CurrentUnits.fromJson(Map<String, dynamic> json) => CurrentUnits(
//     time: json["time"] as String,
//     interval: json["interval"] as String,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "time": time,
//     "interval": interval,
//   };
// }
//
// class DailyUnits {
//   final String time;
//   final String weatherCode;
//   final String temperature2mMax;
//   final String temperature2mMin;
//
//   DailyUnits({
//     required this.time,
//     required this.weatherCode,
//     required this.temperature2mMax,
//     required this.temperature2mMin,
//   });
//
//   factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
//     time: json["time"] as String,
//     weatherCode: json["weather_code"] as String,
//     temperature2mMax: json["temperature_2m_max"] as String,
//     temperature2mMin: json["temperature_2m_min"] as String,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "time": time,
//     "weather_code": weatherCode,
//     "temperature_2m_max": temperature2mMax,
//     "temperature_2m_min": temperature2mMin,
//   };
// }
//
