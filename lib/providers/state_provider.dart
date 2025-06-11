import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider để quản lý giờ được chọn
final selectedHourProvider = StateProvider<int?>((ref) => null);