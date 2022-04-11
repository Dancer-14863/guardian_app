import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeOptions implements AppThemeOptions {
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final Color textColorOnPrimary;
  final Color textColorOnSecondary;
  final Color backgroundColor;

  final double textSize1;
  final double textSize2;
  final double textSize3;
  final double textSize4;
  final double textSize5;

  ThemeOptions({
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
    required this.textColorOnPrimary,
    required this.textColorOnSecondary,
    required this.backgroundColor,
    required this.textSize1,
    required this.textSize2,
    required this.textSize3,
    required this.textSize4,
    required this.textSize5,
  });
}
