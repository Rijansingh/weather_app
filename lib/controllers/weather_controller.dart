import 'package:get/get.dart';
import '../services/weather_api_service.dart';
import '../services/location_service.dart';
import '../models/weather_model.dart';

class WeatherController extends GetxController {
  final WeatherApiService _weatherService = WeatherApiService();
  final LocationService _locationService = LocationService();
  var weather = Rxn<WeatherModel>();
  var isLoading = false.obs;

  Future<void> fetchWeather(String city) async {
    try {
      isLoading.value = true;
      final weatherData = await _weatherService.getWeather(city);
      weather.value = weatherData;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch weather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWeatherByLocation() async {
    try {
      isLoading.value = true;
      final position = await _locationService.getCurrentLocation();
      final weatherData = await _weatherService
          .getWeather('lat=${position.latitude}&lon=${position.longitude}');
      weather.value = weatherData;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch location weather: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
