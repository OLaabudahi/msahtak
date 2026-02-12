import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    height: 1.15,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.subtext,
    height: 1.45,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    height: 1.2,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: AppColors.hint,
    height: 1.35,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    height: 1.2,
  );

  static const TextStyle cardBody = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: AppColors.subtext,
    height: 1.35,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.link,
    height: 1.2,
  );

  static const TextStyle step = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.subtext,
    height: 1.2,
  );

  static const TextStyle pill = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    height: 1.2,
  );

  static const TextStyle pillSelected = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    height: 1.2,
  );
}