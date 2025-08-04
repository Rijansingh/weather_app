import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/favorite_location.dart';
import 'package:weather_app/services/auth_service.dart';
import 'package:weather_app/services/firestore_service.dart';
import 'package:weather_app/utils/helpers.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weatherColor = AppHelpers.getWeatherColor(weather.icon);
    final weatherIcon = AppHelpers.getWeatherIcon(weather.icon);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              weatherColor.withOpacity(0.1),
              weatherColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: weatherColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: weatherColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header with city, country, and favorite button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.cityName,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          weather.country,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: weatherColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          weatherIcon,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildFavoriteButton(context),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Main temperature display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weather.temperatureDisplay,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Feels like temperature
              Text(
                'Feels like ${weather.feelsLikeDisplay}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 16),

              // Weather description
              Text(
                weather.description.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Temperature range
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTempRange(
                    context,
                    Icons.thermostat,
                    'Min',
                    weather.minTempDisplay,
                    Colors.blue,
                  ),
                  _buildTempRange(
                    context,
                    Icons.thermostat,
                    'Max',
                    weather.maxTempDisplay,
                    Colors.red,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Detailed weather information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // First row of details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildWeatherDetail(
                          context,
                          Icons.water_drop,
                          'Humidity',
                          weather.humidityDisplay,
                        ),
                        _buildWeatherDetail(
                          context,
                          Icons.air,
                          'Wind',
                          weather.windSpeedDisplay,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Second row of details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildWeatherDetail(
                          context,
                          Icons.compress,
                          'Pressure',
                          weather.pressureDisplay,
                        ),
                        _buildWeatherDetail(
                          context,
                          Icons.visibility,
                          'Visibility',
                          weather.visibilityDisplay,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Sunrise and sunset
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildWeatherDetail(
                          context,
                          Icons.wb_sunny,
                          'Sunrise',
                          weather.sunriseDisplay,
                        ),
                        _buildWeatherDetail(
                          context,
                          Icons.nightlight,
                          'Sunset',
                          weather.sunsetDisplay,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Weather condition indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getConditionColor(weather).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getConditionColor(weather).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getConditionIcon(weather),
                      color: _getConditionColor(weather),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getConditionText(weather),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getConditionColor(weather),
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildFavoriteButton(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (authService.user == null) {
      return const SizedBox.shrink();
    }

    final userId = authService.user!.uid;

    return Consumer<FirestoreService>(
      builder: (context, firestoreService, child) {
        final isCurrentlyFavorite =
            firestoreService.isLocationFavorite(userId, weather.cityName);

        return IconButton(
          onPressed: () async {
            try {
              if (isCurrentlyFavorite) {
                // Remove from favorites
                final locations = firestoreService.getLocationsForUser(userId);
                final location = locations.firstWhere(
                  (loc) =>
                      loc.cityName.toLowerCase() ==
                      weather.cityName.toLowerCase(),
                );
                await firestoreService.deleteFavoriteLocation(location.id);

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${weather.cityName} removed from favorites'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                // Add to favorites
                final location = FavoriteLocation(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: userId,
                  cityName: weather.cityName,
                  timestamp: DateTime.now(),
                );
                await firestoreService.addFavoriteLocation(location);

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${weather.cityName} added to favorites'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update favorites: $e'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          icon: Icon(
            isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
            color: isCurrentlyFavorite ? Colors.red : Colors.grey,
            size: 24,
          ),
          tooltip: isCurrentlyFavorite
              ? 'Remove from favorites'
              : 'Add to favorites',
        );
      },
    );
  }

  Widget _buildTempRange(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetail(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getConditionColor(Weather weather) {
    if (weather.isHot) return Colors.orange;
    if (weather.isCold) return Colors.blue;
    if (weather.isRaining) return Colors.blue;
    if (weather.isSnowing) return Colors.cyan;
    if (weather.isCloudy) return Colors.grey;
    return Colors.green;
  }

  IconData _getConditionIcon(Weather weather) {
    if (weather.isHot) return Icons.wb_sunny;
    if (weather.isCold) return Icons.ac_unit;
    if (weather.isRaining) return Icons.water_drop;
    if (weather.isSnowing) return Icons.ac_unit;
    if (weather.isCloudy) return Icons.cloud;
    return Icons.wb_sunny;
  }

  String _getConditionText(Weather weather) {
    if (weather.isHot) return 'Hot Weather';
    if (weather.isCold) return 'Cold Weather';
    if (weather.isRaining) return 'Rainy';
    if (weather.isSnowing) return 'Snowy';
    if (weather.isCloudy) return 'Cloudy';
    return 'Clear Sky';
  }
}
