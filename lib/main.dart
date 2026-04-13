import 'package:flutter/material.dart';
import 'splashscreen.dart';
import 'onboarding.dart';
import 'dashboard.dart'; 

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
      // Tetap mulai dari Splash Screen
      initialRoute: '/dashboard', // Ganti ke '/dashboard' untuk langsung ke dashboard
      routes: {
        '/': (context) => const ProjectPalsSplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
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