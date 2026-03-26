import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Nağme renk paleti — profesyonel müzik stüdyo teması
class AppColors {
  AppColors._();

  // Arka plan
  static const background = Color(0xFF0D0D0D);
  static const surface = Color(0xFF1A1A1A);
  static const surfaceLight = Color(0xFF242424);
  static const surfaceBorder = Color(0xFF2E2E2E);

  // Akort durumu
  static const inTune = Color(0xFFFFB300); // Amber/Altın — akortlu
  static const inTuneGlow = Color(0x40FFB300); // Amber glow
  static const sharp = Color(0xFFFF6B6B); // Mercan kırmızı — diyez/bemol
  static const flat = Color(0xFFFF6B6B); // Aynı renk — akort dışı

  // Metin
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFF9E9E9E);
  static const textMuted = Color(0xFF616161);

  // Fonksiyonel
  static const accent = inTune;
  static const error = Color(0xFFEF5350);
  static const success = Color(0xFF66BB6A);

  // Gauge
  static const gaugeTrack = Color(0xFF2E2E2E);
  static const gaugeActive = inTune;
  static const needleColor = Color(0xFFF5F5F5);
}

/// Uygulama teması
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.accent,
        error: AppColors.error,
        onSurface: AppColors.textPrimary,
        onPrimary: AppColors.background,
      ),
      textTheme: _textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: AppColors.surfaceBorder),
        ),
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      // Büyük nota gösterimi
      displayLarge: GoogleFonts.outfit(
        fontSize: 96,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      // Hz gösterimi
      displayMedium: GoogleFonts.jetBrainsMono(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      // Cent gösterimi
      displaySmall: GoogleFonts.jetBrainsMono(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      // Başlıklar
      headlineMedium: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      // Alt başlık
      titleMedium: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      // Gövde metin
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      // Etiketler
      labelLarge: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelSmall: GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      ),
    );
  }
}
