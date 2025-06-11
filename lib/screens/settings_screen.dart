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

  Future<void> _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("search_history");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Search history deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
        children: [
          Text("Settings", style: TextStyles.h1, textAlign: TextAlign.center,),
          SizedBox(height: 10,),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Delete search history", style: TextStyles.h2),
                    trailing: const Icon(Icons.delete, color: AppColors.white,),
                    onTap: _clearSearchHistory,
                  ),
                  const Divider(color: AppColors.grey),

                  // Version
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Version", style: TextStyles.h2),
                        Text("1.0.0", style: TextStyles.h2),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.grey),
                  const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Contact to us", style: TextStyles.h2),
                      SizedBox(height: 16),
                    Row(
                    children: [
                      Icon(Icons.email, size: 25, color: AppColors.white,),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text("support@weatherapp.com", style:TextStyle(fontSize: 18, color: AppColors.white)),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 25, color: AppColors.white,),
                      SizedBox(width: 8),
                      Text("+84 782 706 952", style: TextStyle(fontSize: 18, color: AppColors.white)),
                      ],
                    ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, size: 25, color: AppColors.white,),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                        "2 Nguyen Dinh Chieu St, Vinh Tho Ward, Nha Trang City, Khanh Hoa Province",
                        style: TextStyle(fontSize: 18, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                  ],
                  )
                  )
                ],
              ),
            ),
          ),
        ]
    );
  }
}