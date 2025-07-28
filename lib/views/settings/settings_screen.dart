import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: themeController.isDarkMode.value,
                  onChanged: (value) => themeController.toggleTheme(),
                )),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () => authController.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
