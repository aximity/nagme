import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Nağme renk paleti — premium müzik stüdyo teması
class AppColors {
  AppColors._();

  // Arka plan — hafif sıcak ton
  static const background = Color(0xFF0A0A0C);
  static const surface = Color(0xFF141416);
  static const surfaceLight = Color(0xFF1E1E22);
  static const surfaceBorder = Color(0xFF2A2A30);

  // Akort durumu
  static const inTune = Color(0xFFFFB300);
  static const inTuneGlow = Color(0x40FFB300);
  static const inTuneDeep = Color(0xFFD4A017);
  static const sharp = Color(0xFFE8655A);
  static const flat = Color(0xFF5B8DEF);

  // Metin
  static const textPrimary = Color(0xFFF0EDE8);
  static const textSecondary = Color(0xFF8E8B85);
  static const textMuted = Color(0xFF55534F);

  // Fonksiyonel
  static const accent = inTune;
  static const error = Color(0xFFE8655A);
  static const success = Color(0xFF5CB868);

  // Gauge
  static const gaugeTrack = Color(0xFF222228);
  static const gaugeActive = inTune;
  static const needleColor = Color(0xFFF0EDE8);
}

/// Gradyan tanımları
class AppGradients {
  AppGradients._();

  static const backgroundVignette = RadialGradient(
    center: Alignment(0, -0.3),
    radius: 0.9,
    colors: [
      Color(0xFF141416),
      Color(0xFF0A0A0C),
    ],
  );

  static const gaugeGlow = RadialGradient(
    center: Alignment(0, -0.2),
    radius: 0.5,
    colors: [
      Color(0x0AFFB300),
      Color(0x00000000),
    ],
  );

  static const inTuneGlow = RadialGradient(
    center: Alignment.center,
    radius: 0.6,
    colors: [
      Color(0x18FFB300),
      Color(0x00000000),
    ],
  );

  static const cardSurface = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1A1E),
      Color(0xFF141416),
    ],
  );
}

/// Gölge sistemi
class AppShadows {
  AppShadows._();

  static List<BoxShadow> glow(Color color, {double blur = 16}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: blur,
          spreadRadius: 0,
        ),
      ];

  static const subtle = [
    BoxShadow(
      color: Color(0x20000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
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
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: AppColors.surfaceBorder.withValues(alpha: 0.5)),
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
        activeTrackColor: AppColors.inTune,
        inactiveTrackColor: AppColors.gaugeTrack,
        thumbColor: AppColors.inTune,
        overlayColor: AppColors.inTune.withValues(alpha: 0.12),
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 88,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -3,
        height: 1.0,
      ),
      displayMedium: GoogleFonts.jetBrainsMono(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      displaySmall: GoogleFonts.jetBrainsMono(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
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
      labelLarge: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelSmall: GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
