String getWeatherIcon({required int weatherCode}) {
  const Map<int, String> weatherMap = {
    800: 'assets/icons/01d.png', // Trời quang
    801: 'assets/icons/02d.png', // Mây rải rác
    802: 'assets/icons/03d.png', // Mây phân tán
    803: 'assets/icons/04d.png', // Mây vỡ
    804: 'assets/icons/04d.png', // Trời u ám
    500: 'assets/icons/10d.png', // Mưa nhẹ
    501: 'assets/icons/10d.png', // Mưa vừa
    502: 'assets/icons/10d.png', // Mưa to
    503: 'assets/icons/10d.png', // Mưa rất to
    504: 'assets/icons/10d.png', // Mưa cực đại
    511: 'assets/icons/13d.png', // Mưa đóng băng
    520: 'assets/icons/09d.png', // Mưa rào nhẹ
    521: 'assets/icons/09d.png', // Mưa rào
    522: 'assets/icons/09d.png', // Mưa rào nặng
    531: 'assets/icons/09d.png', // Mưa rào gián đoạn
  };

  if (weatherMap.containsKey(weatherCode)) {
    return weatherMap[weatherCode]!;
  }

  if (weatherCode > 700) return 'assets/icons/50d.png'; // Sương mù, bụi
  if (weatherCode >= 600) return 'assets/icons/13d.png'; // Tuyết
  if (weatherCode >= 500) return 'assets/icons/10d.png'; // Mưa
  if (weatherCode >= 300) return 'assets/icons/09d.png'; // Mưa phùn
  if (weatherCode >= 200) return 'assets/icons/11d.png'; // Giông bão

  return 'assets/icons/01d.png'; // Mặc định
}
