import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  const ErrorScreen({
    Key? key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.error.withOpacity(0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon ?? Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Error Title
                Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Error Message
                Text(
                  message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Action Button
                if (actionLabel != null && onAction != null)
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: onAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        actionLabel!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Back Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Go Back',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Specific error screens
class NetworkErrorScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorScreen({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      title: 'Network Error',
      message: 'Unable to connect to the internet. Please check your connection and try again.',
      actionLabel: 'Retry',
      onAction: onRetry,
      icon: Icons.wifi_off,
    );
  }
}

class CityNotFoundScreen extends StatelessWidget {
  final String cityName;
  final VoidCallback? onRetry;

  const CityNotFoundScreen({
    Key? key,
    required this.cityName,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      title: 'City Not Found',
      message: 'We couldn\'t find weather data for "$cityName". Please check the spelling or try a different city.',
      actionLabel: 'Try Again',
      onAction: onRetry,
      icon: Icons.location_off,
    );
  }
}

class AuthenticationErrorScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const AuthenticationErrorScreen({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      title: 'Authentication Failed',
      message: 'Unable to sign in. Please check your internet connection and try again.',
      actionLabel: 'Retry Sign In',
      onAction: onRetry,
      icon: Icons.lock_outline,
    );
  }
}

class GeneralErrorScreen extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const GeneralErrorScreen({
    Key? key,
    required this.error,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      title: 'Something Went Wrong',
      message: 'An unexpected error occurred: $error',
      actionLabel: onRetry != null ? 'Try Again' : null,
      onAction: onRetry,
      icon: Icons.error_outline,
    );
  }
} 