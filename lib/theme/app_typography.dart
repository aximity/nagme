import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  // Plus Jakarta Sans 800 — başlıklar
  static const heading1 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const heading2 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const heading3 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  // Space Grotesk 500-700 — frekans/cent göstergeleri
  static const frequency = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.brandPrimary,
  );

  static const cent = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const noteName = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 64,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Be Vietnam Pro 500 — body/nav
  static const body = TextStyle(
    fontFamily: 'BeVietnamPro',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const bodySecondary = TextStyle(
    fontFamily: 'BeVietnamPro',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const caption = TextStyle(
    fontFamily: 'BeVietnamPro',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const navLabel = TextStyle(
    fontFamily: 'BeVietnamPro',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}
