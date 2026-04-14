import 'package:flutter/material.dart';
import 'splashscreen.dart';
import 'onboarding.dart';
import 'dashboard.dart'; 
import 'login.dart';
import 'register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProjectPals',
      initialRoute: '/',
      routes: {
        '/': (context) => const ProjectPalsSplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: 'sans-serif',
      ),
    );
  }
}