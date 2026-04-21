import 'package:flutter/material.dart';
import 'config/di/service_locator.dart';
import 'config/router/app_router.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      initialRoute: AppRouter.initialRoute,
      routes: AppRouter.routes,
      theme: AppTheme.darkTheme(),
    );
  }
}