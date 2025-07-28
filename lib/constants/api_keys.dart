import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static String get openWeatherMap =>
      dotenv.env['OPENWEATHERMAP_API_KEY'] ?? '';
}

class ApiKeys {
  static const String openWeatherMap = 'cae1b77da18c432c888864a2f31ef0cd';
}
