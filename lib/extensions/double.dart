extension ConvertWindSpeed on double {
  String get kmh => (this * 3.6).toStringAsFixed(2);
}
