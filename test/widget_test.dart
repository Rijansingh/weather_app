import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_96/main.dart';

void main() {
  testWidgets('WeatherApp renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());
    expect(find.text('Weather App'), findsOneWidget);
  });
}
