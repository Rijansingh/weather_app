class AppConfig {
  // API Configuration
  static const String openWeatherApiKey = 'cae1b77da18c432c888864a2f31ef0cd';
  static const String openWeatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // App Configuration
  static const String appName = 'Weather App';
  static const String appVersion = '1.0.0';
  
  // Feature Flags
  static const bool enableLocationServices = true;
  static const bool enableFavorites = true;
  static const bool enableAnimations = true;
  
  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration apiTimeout = Duration(seconds: 10);
  
  // Error Messages
  static const String locationPermissionDenied = 'Location permission denied. Please enable location services to get weather for your current location.';
  static const String locationServiceDisabled = 'Location services are disabled. Please enable them in your device settings.';
  static const String networkError = 'Network error. Please check your internet connection and try again.';
  static const String cityNotFound = 'City not found. Please check the spelling and try again.';
  static const String apiKeyError = 'Invalid API key. Please check your OpenWeatherMap API key.';
  static const String tooManyRequests = 'Too many requests. Please try again later.';
  
  // Success Messages
  static const String locationAdded = 'Location added to favorites';
  static const String locationRemoved = 'Location removed from favorites';
  static const String weatherUpdated = 'Weather information updated';
  
  // Validation Messages
  static const String emptyCityName = 'Please enter a city name';
  static const String invalidCityName = 'Please enter a valid city name';
  
  // Helper Methods
  static bool isValidApiKey() {
    return openWeatherApiKey != 'YOUR_API_KEY_HERE' && openWeatherApiKey.isNotEmpty;
  }
  
  static String getApiKeyErrorMessage() {
    if (!isValidApiKey()) {
      return 'Please configure your OpenWeatherMap API key in lib/config/app_config.dart';
    }
    return apiKeyError;
  }
} 