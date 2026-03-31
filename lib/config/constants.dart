class AppConstants {
  AppConstants._();

  // Ses işleme
  static const int sampleRate = 44100;
  static const int bufferSize = 4096;
  static const double rmsThreshold = 0.008;

  // Tuner
  static const double defaultRefHz = 440.0;
  static const int defaultTuneThreshold = 5; // ±5 cents = akortlu
  static const double minFrequency = 27.5; // A0
  static const double maxFrequency = 4186.0; // C8

  // YIN algoritması
  static const double yinThreshold = 0.15;

  // UI spacing
  static const double paddingXs = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXl = 32.0;
  static const double paddingXxl = 48.0;

  // Köşe yarıçapları
  static const double radiusS = 8.0;
  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXl = 32.0;
  static const double radiusFull = 999.0;

  // Animasyon
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 600);

  // SharedPreferences anahtarları
  static const String prefRefHz = 'ref_hz';
  static const String prefTuneThreshold = 'tune_threshold';
  static const String prefSelectedInstrument = 'selected_instrument';
  static const String prefThemeMode = 'theme_mode';
  static const String prefNoteNotation = 'note_notation';
  static const String prefToneEnabled = 'tone_enabled';
}
