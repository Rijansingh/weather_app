import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/config/app_config.dart';

class WeatherService {
  Future<Weather> fetchWeather(String city) async {
    if (!AppConfig.isValidApiKey()) {
      throw Exception(AppConfig.getApiKeyErrorMessage());
    }

    if (city.trim().isEmpty) {
      throw Exception(AppConfig.emptyCityName);
    }

    try {
      final response = await http
          .get(
            Uri.parse(
                '${AppConfig.openWeatherBaseUrl}/weather?q=${Uri.encodeComponent(city.trim())}&appid=${AppConfig.openWeatherApiKey}&units=metric'),
          )
          .timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception(AppConfig.cityNotFound);
      } else if (response.statusCode == 401) {
        throw Exception(AppConfig.apiKeyError);
      } else if (response.statusCode == 429) {
        throw Exception(AppConfig.tooManyRequests);
      } else {
        throw Exception(
            'Failed to load weather data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('${AppConfig.networkError}: $e');
    }
  }

  Future<Weather> fetchWeatherByCoordinates(double lat, double lon) async {
    if (!AppConfig.isValidApiKey()) {
      throw Exception(AppConfig.getApiKeyErrorMessage());
    }

    try {
      final response = await http
          .get(
            Uri.parse(
                '${AppConfig.openWeatherBaseUrl}/weather?lat=$lat&lon=$lon&appid=${AppConfig.openWeatherApiKey}&units=metric'),
          )
          .timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Weather.fromJson(data);
      } else {
        throw Exception('Failed to load weather data for coordinates');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('${AppConfig.networkError}: $e');
    }
  }
}
