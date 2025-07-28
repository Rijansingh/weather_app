class WeatherHelper {
  static String getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'snow':
        return '❄️';
      default:
        return '🌫️';
    }
  }

  static double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }
}
