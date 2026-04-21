import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryCyan,
      scaffoldBackgroundColor: AppColors.darkBlueBg,
      fontFamily: 'sans-serif',
    );
  }
}
