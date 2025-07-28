import 'package:flutter/material.dart';
import '../../core/utils/weather_helper.dart';

class WeatherTile extends StatelessWidget {
  final String city;
  final int temperature;
  final String condition;

  const WeatherTile({
    super.key,
    required this.city,
    required this.temperature,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(WeatherHelper.getWeatherIcon(condition),
          style: const TextStyle(fontSize: 24)),
      title: Text(city),
      subtitle: Text('$temperature°C, $condition'),
    );
  }
}
