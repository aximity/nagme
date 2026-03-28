/// Uygulama sabitleri
class AppConstants {
  AppConstants._();

  // Tuner
  static const double defaultRefHz = 440.0;
  static const double minRefHz = 415.0;
  static const double maxRefHz = 466.0;
  static const double tuneThresholdCents = 5.0;
  static const double maxCentsDisplay = 50.0;

  // Audio
  static const int sampleRate = 44100;
  static const int bufferSize = 4096;
  static const double silenceThreshold = 0.002;
  static const double androidMicGain = 8.0;
  static const double minFrequency = 27.5;
  static const double maxFrequency = 4186.0;

  // YIN
  static const double yinThreshold = 0.20;

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
  static const int needleAnimDuration = 300;
  static const int noteTransitionDuration = 250;
  static const int glowPulseDuration = 1200;
  static const int pageTransitionDuration = 350;
  static const int buttonScaleDuration = 120;

  // Spring parametreleri
  static const double springDamping = 0.7;
  static const double springStiffness = 280.0;

  // Gauge
  static const double gaugeSize = 320.0;
}
