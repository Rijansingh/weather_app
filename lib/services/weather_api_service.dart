import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_keys.dart';
import '../constants/app_constants.dart';
import '../models/weather_model.dart';
import '../core/utils/weather_helper.dart';

class WeatherApiService {
  Future<WeatherModel> getWeather(String city) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/weather?q=$city&appid=${ApiKeys.openWeatherMap}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel(
        city: data['name'],
        temperature: WeatherHelper.kelvinToCelsius(data['main']['temp']),
        condition: data['weather'][0]['main'],
        humidity: data['main']['humidity'].toDouble(),
        windSpeed: data['wind']['speed'].toDouble(),
      );
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}
