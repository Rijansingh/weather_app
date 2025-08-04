import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/screens/favorites_screen.dart';
import 'package:weather_app/screens/error_screen.dart';
import 'package:weather_app/services/auth_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final weatherService = WeatherService();
  final cityController = TextEditingController();
  Weather? weatherData;
  bool isLoading = false;
  String? errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shakeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    _shakeController.forward().then((_) => _shakeController.reverse());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  bool _validateCityName(String cityName) {
    if (cityName.trim().isEmpty) {
      _showError('Please enter a city name');
      return false;
    }
    
    if (cityName.trim().length < 2) {
      _showError('City name must be at least 2 characters long');
      return false;
    }
    
    // Check for special characters
    final RegExp validCityName = RegExp(r'^[a-zA-Z\s\-\.]+$');
    if (!validCityName.hasMatch(cityName.trim())) {
      _showError('City name contains invalid characters');
      return false;
    }
    
    return true;
  }

  Future<void> _fetchWeatherForCity(String city) async {
    if (!_validateCityName(city)) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedWeather = await weatherService.fetchWeather(city.trim());
      if (!mounted) return;
      
      setState(() {
        weatherData = fetchedWeather;
        isLoading = false;
      });
      
      _animationController.forward();
      _showSuccess('Weather data loaded successfully!');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'City not found or network error. Please try again.';
        isLoading = false;
      });
      
      // Show specific error screen based on error type
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        _showCityNotFoundError(city.trim());
      } else if (e.toString().contains('network') || e.toString().contains('connection')) {
        _showNetworkError();
      } else {
        _showGeneralError(e.toString());
      }
    }
  }

  void _showCityNotFoundError(String cityName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CityNotFoundScreen(
          cityName: cityName,
          onRetry: () {
            Navigator.of(context).pop();
            _fetchWeatherForCity(cityName);
          },
        ),
      ),
    );
  }

  void _showNetworkError() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NetworkErrorScreen(
          onRetry: () {
            Navigator.of(context).pop();
            if (cityController.text.isNotEmpty) {
              _fetchWeatherForCity(cityController.text);
            }
          },
        ),
      ),
    );
  }

  void _showGeneralError(String error) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GeneralErrorScreen(
          error: error,
          onRetry: () {
            Navigator.of(context).pop();
            if (cityController.text.isNotEmpty) {
              _fetchWeatherForCity(cityController.text);
            }
          },
        ),
      ),
    );
  }

  void _showWeatherTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Weather Tips'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTip('🌡️ Temperature', 'Check both current and "feels like" temperature'),
            _buildTip('💨 Wind Speed', 'Higher wind speeds can make it feel colder'),
            _buildTip('💧 Humidity', 'High humidity makes hot weather feel hotter'),
            _buildTip('👁️ Visibility', 'Low visibility may indicate fog or pollution'),
            _buildTip('🌅 Sunrise/Sunset', 'Plan outdoor activities around daylight hours'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // App Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weather App',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Hello, ${authService.user?.displayName ?? 'User'}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.help_outline),
                            onPressed: _showWeatherTips,
                            tooltip: 'Weather Tips',
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FavoritesScreen(),
                                ),
                              );
                            },
                            tooltip: 'Favorites',
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: () async {
                              try {
                                await authService.signOut();
                                _showSuccess('Signed out successfully');
                              } catch (e) {
                                _showError('Sign-out failed: $e');
                              }
                            },
                            tooltip: 'Sign Out',
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Search Bar with Animation
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation.value, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: cityController,
                                  decoration: InputDecoration(
                                    hintText: 'Search for a city...',
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(16),
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: cityController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              cityController.clear();
                                              setState(() {});
                                            },
                                          )
                                        : null,
                                  ),
                                  onChanged: (value) => setState(() {}),
                                  onSubmitted: (value) {
                                    if (value.isNotEmpty) {
                                      _fetchWeatherForCity(value);
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  if (cityController.text.isNotEmpty) {
                                    _fetchWeatherForCity(cityController.text);
                                  } else {
                                    _showError('Please enter a city name');
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Quick Search Buttons
                  if (weatherData == null && !isLoading)
                    Column(
                      children: [
                        Text(
                          'Popular Cities',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'London',
                            'New York',
                            'Tokyo',
                            'Paris',
                            'Sydney',
                            'Mumbai',
                          ].map((city) => ActionChip(
                            label: Text(city),
                            onPressed: () {
                              cityController.text = city;
                              _fetchWeatherForCity(city);
                            },
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Loading State
                  if (isLoading)
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading weather data...'),
                        ],
                      ),
                    ),

                  // Weather Data
                  if (weatherData != null && !isLoading)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: WeatherCard(weather: weatherData!),
                    ),

                  // Empty State
                  if (weatherData == null && !isLoading && errorMessage == null)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_outlined,
                            size: 64,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Search for a city to get weather information',
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter a city name above or try a popular city',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
