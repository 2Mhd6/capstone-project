import 'package:flutter/material.dart';

import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';

class AppTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.appBackgroundColor,


    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryButtonColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
      )
    )
  );

}