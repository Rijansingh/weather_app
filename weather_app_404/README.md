# Weather App

A modern, beautiful weather application built with Flutter that provides real-time weather information with a focus on excellent user experience.

## 🌟 Features

- **Current Location Weather**: Automatically get weather for your current location
- **City Search**: Search for weather in any city worldwide
- **Favorite Locations**: Save and manage your favorite cities
- **Modern UI/UX**: Beautiful, responsive design with smooth animations
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Real-time Data**: Live weather updates from OpenWeatherMap API
- **Google Authentication**: Secure sign-in with Google accounts
- **Offline Support**: Cached data for better performance

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project setup
- OpenWeatherMap API key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd weather_app_404
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project
   - Enable Authentication (Google Sign-in)
   - Enable Firestore Database
   - Download and add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update Firebase configuration in your project

4. **Configure OpenWeatherMap API**
   - Sign up at [OpenWeatherMap](https://openweathermap.org/api)
   - Get your API key
   - Replace `YOUR_API_KEY_HERE` in `lib/services/weather_service.dart` with your actual API key

5. **Configure Location Services**
   - For Android: Add location permissions to `android/app/src/main/AndroidManifest.xml`
   - For iOS: Add location permissions to `ios/Runner/Info.plist`

### Android Permissions

Add these permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS Permissions

Add these keys to `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location to show weather for your current location.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to location to show weather for your current location.</string>
```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── weather.dart          # Weather data model
│   └── favorite_location.dart # Favorite location model
├── screens/
│   ├── home_screen.dart      # Main weather screen
│   ├── login_screen.dart     # Authentication screen
│   └── favorites_screen.dart # Favorites management
├── services/
│   ├── auth_service.dart     # Firebase authentication
│   ├── weather_service.dart  # Weather API integration
│   └── firestore_service.dart # Firestore database
└── widgets/
    ├── weather_card.dart     # Weather display widget
    └── favorite_location_tile.dart # Favorite location widget
```

## 🎨 UI/UX Improvements

### Design Features
- **Material Design 3**: Modern design system with dynamic colors
- **Smooth Animations**: Fade and slide transitions throughout the app
- **Responsive Layout**: Adapts to different screen sizes
- **Loading States**: Clear feedback during data fetching
- **Error Handling**: User-friendly error messages
- **Empty States**: Helpful guidance when no data is available

### User Experience
- **Auto-location**: Automatically detects and shows weather for current location
- **Search Suggestions**: Real-time search with city name validation
- **Favorites Management**: Easy add/remove of favorite locations
- **Offline Support**: Cached data for better performance
- **Accessibility**: Screen reader support and high contrast options

## 🔧 Configuration

### API Keys
1. **OpenWeatherMap**: Get your API key from [OpenWeatherMap](https://openweathermap.org/api)
2. **Firebase**: Configure your Firebase project and add the configuration files

### Environment Variables
For production, consider using environment variables for API keys:
```dart
// Example using flutter_dotenv
final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
```

## 🚀 Running the App

```bash
# Run on connected device
flutter run

# Run with specific device
flutter run -d <device-id>

# Build for release
flutter build apk --release
```

## 📱 Screenshots

The app features:
- **Login Screen**: Beautiful onboarding with feature highlights
- **Home Screen**: Current weather with search and location features
- **Favorites Screen**: Manage saved locations with expandable weather cards

## 🛠️ Dependencies

- `flutter`: Core framework
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication services
- `google_sign_in`: Google Sign-in integration
- `cloud_firestore`: Database operations
- `http`: API requests
- `geolocator`: Location services
- `geocoding`: Address geocoding
- `provider`: State management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you encounter any issues:
1. Check the Firebase configuration
2. Verify your OpenWeatherMap API key
3. Ensure location permissions are properly set
4. Check the console for error messages

## 🔮 Future Enhancements

- [ ] Weather forecasts (5-day, hourly)
- [ ] Weather maps integration
- [ ] Push notifications for weather alerts
- [ ] Widget support for home screen
- [ ] Multiple language support
- [ ] Weather history and trends
- [ ] Social sharing features
