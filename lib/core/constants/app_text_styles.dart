import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headline styles
  static TextStyle heroHeadline({
    double fontSize = 48,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: -0.5,
      height: 1.2,
    );
  }

  static TextStyle sectionHeadline({
    double fontSize = 36,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: -0.5,
      height: 1.2,
    );
  }

  // Body text
  static TextStyle bodyText({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: AppColors.darkGrey,
      height: 1.5,
    );
  }

  // Button text
  static TextStyle buttonText({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: AppColors.white,
      letterSpacing: 0.5,
    );
  }

  // Logo text
  static TextStyle logoText({
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: AppColors.darkGrey,
      letterSpacing: -0.5,
    );
  }

  // Statistics
  static TextStyle statisticsText({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: AppColors.darkGrey,
    );
  }

  static TextStyle taglineText({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: AppColors.darkGrey,
      fontStyle: FontStyle.italic,
    );
  }
}
