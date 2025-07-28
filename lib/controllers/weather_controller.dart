// File: lib/controllers/weather_controller.dart
import 'package:get/get.dart';
import '../services/weather_api_service.dart';
import '../models/weather_model.dart';

class WeatherController extends GetxController {
  var isLoading = false.obs;
  var weather = Rxn<WeatherModel>();
  var forecast = <Map<String, dynamic>>[].obs;

  final WeatherApiService _weatherApiService = WeatherApiService();

  Future<void> fetchWeather(String city) async {
    isLoading.value = true;
    try {
      weather.value = await _weatherApiService.fetchWeather(city);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch weather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchForecast(String city) async {
    isLoading.value = true;
    try {
      forecast.value = await _weatherApiService.fetchForecast(city);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch forecast: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
