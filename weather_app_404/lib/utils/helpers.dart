import 'package:flutter/material.dart';

class AppHelpers {
  // Date formatting
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Temperature formatting
  static String formatTemperature(double temperature) {
    return '${temperature.round()}°C';
  }

  // Weather description formatting
  static String formatWeatherDescription(String description) {
    return description.toUpperCase();
  }

  // Color based on weather condition
  static Color getWeatherColor(String iconCode) {
    if (iconCode.startsWith('01')) return Colors.orange;
    if (iconCode.startsWith('02')) return Colors.blue;
    if (iconCode.startsWith('03') || iconCode.startsWith('04')) return Colors.grey;
    if (iconCode.startsWith('09') || iconCode.startsWith('10')) return Colors.blue;
    if (iconCode.startsWith('11')) return Colors.purple;
    if (iconCode.startsWith('13')) return Colors.cyan;
    if (iconCode.startsWith('50')) return Colors.grey;
    return Colors.blue;
  }

  // Weather icon mapping
  static String getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return '☀️';
      case '01n':
        return '🌙';
      case '02d':
      case '02n':
        return '⛅';
      case '03d':
      case '03n':
        return '☁️';
      case '04d':
      case '04n':
        return '☁️';
      case '09d':
      case '09n':
        return '🌧️';
      case '10d':
        return '🌦️';
      case '10n':
        return '🌧️';
      case '11d':
      case '11n':
        return '⛈️';
      case '13d':
      case '13n':
        return '❄️';
      case '50d':
      case '50n':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  // Show snackbar with consistent styling
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Validate city name
  static bool isValidCityName(String cityName) {
    return cityName.trim().isNotEmpty && cityName.trim().length >= 2;
  }

  // Get loading widget with consistent styling
  static Widget getLoadingWidget({String? message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message),
          ],
        ],
      ),
    );
  }

  // Get error widget with consistent styling
  static Widget getErrorWidget(String message, VoidCallback? onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ],
      ),
    );
  }

  // Get empty state widget
  static Widget getEmptyStateWidget({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: iconColor ?? Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
} 