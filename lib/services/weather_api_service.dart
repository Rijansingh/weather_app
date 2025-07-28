// File: lib/services/weather_api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_keys.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  Future<WeatherModel> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${ApiKeys.openWeatherMap}&units=metric',
    ));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel(
        city: data['name'],
        temperature: data['main']['temp'].toDouble(),
        condition: data['weather'][0]['main'],
        humidity: data['main']['humidity'].toDouble(),
        windSpeed: data['wind']['speed'].toDouble(),
      );
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchForecast(String city) async {
    final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=${ApiKeys.openWeatherMap}&units=metric',
    ));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['list'] as List)
          .asMap()
          .entries
          .where((entry) => entry.key % 8 == 0)
          .map((entry) => {
                'temp': entry.value['main']['temp'].toDouble(),
                'date': entry.value['dt_txt'],
              })
          .take(5)
          .toList();
    } else {
      throw Exception('Failed to fetch forecast data');
    }
  }
}