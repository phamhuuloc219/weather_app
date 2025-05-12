import 'package:flutter/material.dart';
import 'package:weather_app/constants/app_colors.dart';
import 'package:weather_app/constants/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/views/gradient_container.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isCelsius = true; // Mặc định dùng Celsius

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCelsius = prefs.getBool('isCelsius') ?? true; // Mặc định true nếu chưa có
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCelsius', _isCelsius);
  }

  Future<void> _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lịch sử tìm kiếm đã được xóa')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
        children: [
          Text("Cài đặt", style: TextStyles.h1, textAlign: TextAlign.center,),
          SizedBox(height: 10,),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chuyển đổi đơn vị nhiệt độ
                  SwitchListTile(
                    title: const Text(
                      'Sử dụng đơn vị Celsius',
                      style: TextStyles.subtitleText,
                    ),
                    value: _isCelsius,
                    activeColor: AppColors.lightBlue,
                    onChanged: (value) {
                      setState(() {
                        _isCelsius = value;
                      });
                      _saveSettings();
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  ),
                  const Divider(color: AppColors.grey, thickness: 1),
                  // Xóa lịch sử tìm kiếm
                  ListTile(
                    title: const Text(
                      'Xóa lịch sử tìm kiếm',
                      style: TextStyles.subtitleText,
                    ),
                    trailing: const Icon(Icons.delete, color: AppColors.white),
                    onTap: () {
                      _clearSearchHistory();
                    },
                  ),
                  const Divider(color: AppColors.grey, thickness: 1),
                  // Thông tin ứng dụng
                  ListTile(
                    title: const Text(
                      'Version',
                      style: TextStyles.subtitleText,
                    ),
                    subtitle: const Text(
                      '1.0.0',
                      style: TextStyles.subtitleText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
    );
  }
}