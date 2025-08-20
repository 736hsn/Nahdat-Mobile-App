import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData lightTheme = ThemeData(
  // brightness: Brightness.dark,
  colorScheme: const ColorScheme.light(
    surface: AppColors.backgroundLight,
    primary: AppColors.primaryLight,
    onPrimary: AppColors.textPrimaryLight,
    secondary: AppColors.textSecondaryLight,
    secondaryContainer: AppColors.cardSecondaryLight,
    tertiary: AppColors.success,
    error: AppColors.error,
  ),
  dividerColor: AppColors.textPrimaryLight,
  highlightColor: AppColors.bottomNavBarIconLight,
  cardColor: AppColors.cardPrimaryLight,
  canvasColor: AppColors.textPrimaryLight,
  hintColor: AppColors.textSecondaryLight,
  primaryColor: AppColors.primaryLight,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  splashColor: AppColors.backgroundLight,
);

ThemeData darkTheme = ThemeData(
  // brightness: Brightness.light,
  colorScheme: const ColorScheme.dark(
    surface: AppColors.backgroundDark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.textPrimaryDark,
    secondary: AppColors.textSecondaryDark,
    onSecondary: AppColors.cardPrimaryDark,
    secondaryContainer: AppColors.cardSecondaryDark,
    tertiary: AppColors.success,
    error: AppColors.error,
  ),
  dividerColor: AppColors.textPrimaryDark,
  highlightColor: AppColors.bottomNavBarIconDark,
  cardColor: AppColors.cardPrimaryDark,
  canvasColor: AppColors.textPrimaryDark,

  hintColor: AppColors.textSecondaryDark,
  primaryColor: AppColors.primaryDark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  splashColor: AppColors.backgroundDark,
);
