import 'package:flutter/material.dart';
import '../core/utils/weather_helper.dart';

class WeatherCard extends StatelessWidget {
  final String city;
  final int temperature;
  final String condition;
  final IconData icon;
  final VoidCallback onTap;

  const WeatherCard({
    super.key,
    required this.city,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                WeatherHelper.getWeatherIcon(condition),
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '$temperature°C',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      condition,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
