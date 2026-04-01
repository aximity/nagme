import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgBase,
        colorScheme: const ColorScheme.dark(
          surface: AppColors.bgBase,
          primary: AppColors.brandPrimary,
          secondary: AppColors.brandDim,
          error: AppColors.statusSharp,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgBase,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: AppTypography.heading3,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          iconTheme: const IconThemeData(color: AppColors.textSecondary),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.bgSurface,
          indicatorColor: AppColors.brandPrimary.withValues(alpha: 0.15),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTypography.navLabel
                  .copyWith(color: AppColors.brandPrimary);
            }
            return AppTypography.navLabel;
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: AppColors.brandPrimary,
                size: 24,
              );
            }
            return const IconThemeData(
              color: AppColors.textMuted,
              size: 24,
            );
          }),
        ),
        dividerColor: AppColors.bgElevated,
        cardColor: AppColors.bgSurface,
      );
}
