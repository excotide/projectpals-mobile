import 'package:flutter/widgets.dart';

import '../../core/constants/app_strings.dart';
import '../../presentation/pages/dashboard.dart';
import '../../presentation/pages/login.dart';
import '../../presentation/pages/onboarding.dart';
import '../../presentation/pages/register_screen.dart';
import '../../presentation/pages/splashscreen.dart';

class AppRouter {
  AppRouter._();

  static String get initialRoute => AppStrings.routeSplash;

  static Map<String, WidgetBuilder> get routes {
    return {
      AppStrings.routeSplash: (context) => const ProjectPalsSplashScreen(),
      AppStrings.routeOnboarding: (context) => const OnboardingScreen(),
      AppStrings.routeLogin: (context) => const LoginScreen(),
      AppStrings.routeRegister: (context) => const RegisterScreen(),
      AppStrings.routeDashboard: (context) => const DashboardScreen(),
    };
  }
}
