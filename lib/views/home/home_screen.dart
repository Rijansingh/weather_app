import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/nav_controller.dart';
import '../../controllers/weather_controller.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/weather_tile.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavController navController = Get.find();
    final WeatherController weatherController = Get.find();
    final TextEditingController cityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'Enter city',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (cityController.text.isNotEmpty) {
                      weatherController.fetchWeather(cityController.text);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (weatherController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (weatherController.weather.value == null) {
                return const Center(child: Text('Enter a city to see weather'));
              }
              final weather = weatherController.weather.value!;
              return WeatherCard(
                city: weather.city,
                temperature: weather.temperature.round(),
                condition: weather.condition,
                icon: Icons.wb_sunny,
                onTap: () =>
                    Get.snackbar('Weather', 'Tapped on ${weather.city}'),
              );
            }),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  WeatherTile(
                      city: 'London', temperature: 18, condition: 'Cloudy'),
                  WeatherTile(
                      city: 'Tokyo', temperature: 25, condition: 'Rainy'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: navController.currentIndex.value,
        onTap: navController.changeIndex,
      ),
    );
  }
}
