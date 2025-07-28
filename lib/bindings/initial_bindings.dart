import 'package:get/get.dart';
import '../controllers/nav_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/weather_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavController());
    Get.lazyPut(() => ThemeController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => WeatherController());
  }
}
