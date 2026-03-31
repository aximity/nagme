import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Stitch export token'larına birebir eşleşen renk sistemi.
class AppColors {
  AppColors._();

  // Arka plan katmanları (yüzeyden en alta)
  static const Color background         = Color(0xFF111125); // surface / background
  static const Color surfaceContainerLowest = Color(0xFF0C0C1F);
  static const Color surfaceContainerLow    = Color(0xFF1A1A2E);
  static const Color surfaceContainer       = Color(0xFF1E1E32);
  static const Color surfaceContainerHigh   = Color(0xFF28283D);
  static const Color surfaceContainerHighest= Color(0xFF333348);
  static const Color surfaceBright          = Color(0xFF37374D);

  // Birincil — amber/altın (akortlu, aktif)
  static const Color primary          = Color(0xFFFFc499); // lighter amber
  static const Color primaryContainer = Color(0xFFF4A261); // amber (CTA, glow)
  static const Color onPrimary        = Color(0xFF4E2600);
  static const Color onPrimaryFixed   = Color(0xFF2F1400);

  // İkincil — mercan kırmızı (bemol/diyez)
  static const Color secondary          = Color(0xFFFFB4A2);
  static const Color secondaryContainer = Color(0xFF862810);

  // Metin
  static const Color onSurface        = Color(0xFFE2E0FC); // birincil metin
  static const Color tertiaryFixed    = Color(0xFFE7E2DA); // yüksek kontrast
  static const Color onSurfaceVariant = Color(0xFFD8C2B5); // ikincil metin
  static const Color tertiary         = Color(0xFFD4CFC8); // soluk metin

  // Sınır / taslak
  static const Color outline        = Color(0xFFA08D80);
  static const Color outlineVariant = Color(0xFF534439);

  // Durum
  static const Color error = Color(0xFFFFB4AB);

  // Kısayol — sık kullanılanlar
  static const Color surface    = background;
  static const Color textPrimary   = tertiaryFixed;
  static const Color textSecondary = onSurfaceVariant;
  static const Color textHint      = tertiary;
  static const Color border        = surfaceContainerHighest;
}

/// Stitch font sistemi:
///   Epilogue   → headline (büyük nota harfleri)
///   Manrope    → body (genel metin, etiketler)
///   Space Grotesk → label (Hz, cents, teknik veri)
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary:   AppColors.primaryContainer,
        secondary: AppColors.secondary,
        surface:   AppColors.surfaceContainerLow,
        error:     AppColors.error,
        onPrimary:  AppColors.onPrimary,
        onSurface:  AppColors.onSurface,
        onError:    AppColors.onPrimaryFixed,
      ),
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).apply(
        bodyColor:    AppColors.onSurface,
        displayColor: AppColors.tertiaryFixed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleTextStyle: GoogleFonts.epilogue(
          color: AppColors.tertiaryFixed,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
      ),
      iconTheme: const IconThemeData(color: AppColors.onSurfaceVariant),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.background.withValues(alpha: 0.9),
        indicatorColor: AppColors.surfaceContainerHighest,
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.spaceGrotesk(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
