class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final int pressure;
  final int visibility;
  final double minTemp;
  final double maxTemp;
  final int sunrise;
  final int sunset;
  final String country;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.pressure,
    required this.visibility,
    required this.minTemp,
    required this.maxTemp,
    required this.sunrise,
    required this.sunset,
    required this.country,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? 'Unknown City',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      humidity: (json['main']['humidity'] ?? 0).toDouble(),
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      description: json['weather'][0]['description'] ?? 'Unknown',
      icon: json['weather'][0]['icon'] ?? '01d',
      pressure: json['main']['pressure'] ?? 0,
      visibility: json['visibility'] ?? 0,
      minTemp: (json['main']['temp_min'] ?? 0).toDouble(),
      maxTemp: (json['main']['temp_max'] ?? 0).toDouble(),
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
      country: json['sys']['country'] ?? 'Unknown',
    );
  }

  // Helper methods for better UX
  String get temperatureDisplay => '${temperature.round()}°C';
  String get feelsLikeDisplay => '${feelsLike.round()}°C';
  String get humidityDisplay => '${humidity.round()}%';
  String get windSpeedDisplay => '${windSpeed.toStringAsFixed(1)} m/s';
  String get pressureDisplay => '${pressure} hPa';
  String get visibilityDisplay => '${(visibility / 1000).toStringAsFixed(1)} km';
  String get minTempDisplay => '${minTemp.round()}°C';
  String get maxTempDisplay => '${maxTemp.round()}°C';

  // Weather condition helpers
  bool get isHot => temperature > 30;
  bool get isCold => temperature < 10;
  bool get isRaining => description.toLowerCase().contains('rain');
  bool get isSnowing => description.toLowerCase().contains('snow');
  bool get isCloudy => description.toLowerCase().contains('cloud');
  bool get isClear => description.toLowerCase().contains('clear') || description.toLowerCase().contains('sunny');

  // Time helpers
  DateTime get sunriseTime => DateTime.fromMillisecondsSinceEpoch(sunrise * 1000);
  DateTime get sunsetTime => DateTime.fromMillisecondsSinceEpoch(sunset * 1000);
  
  String get sunriseDisplay => '${sunriseTime.hour.toString().padLeft(2, '0')}:${sunriseTime.minute.toString().padLeft(2, '0')}';
  String get sunsetDisplay => '${sunsetTime.hour.toString().padLeft(2, '0')}:${sunsetTime.minute.toString().padLeft(2, '0')}';
}
