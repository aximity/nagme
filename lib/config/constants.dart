/// Uygulama sabitleri
class AppConstants {
  AppConstants._();

  // Tuner
  static const double defaultRefHz = 440.0;
  static const double minRefHz = 415.0;
  static const double maxRefHz = 466.0;
  static const double tuneThresholdCents = 5.0; // ±5 cent = akortlu
  static const double maxCentsDisplay = 50.0; // Gauge ±50 cent gösterir

  // Audio
  static const int sampleRate = 44100;
  static const int bufferSize = 4096; // G3=196Hz için 18+ periyod, düşük gecikme
  static const double silenceThreshold = 0.005; // Web mikrofon için düşürüldü
  static const double minFrequency = 27.5; // A0
  static const double maxFrequency = 4186.0; // C8

  // YIN
  static const double yinThreshold = 0.15; // Web mikrofon + keman dengesi

  // UI Spacing
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // UI Radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;

  // Animasyon süreleri (ms)
  static const int needleAnimDuration = 150;
  static const int noteTransitionDuration = 200;
  static const int glowPulseDuration = 1000;
}
