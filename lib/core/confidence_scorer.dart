import 'dart:collection';
import 'dart:math';

/// Konuşma/gürültü filtreleyici + güven skoru hesaplayıcı.
class ConfidenceScorer {
  final _recentPitches = Queue<double>();
  static const _maxFrames = 12;

  int _stableFrameCount = 0;
  int _unstableStreak = 0; // Ardışık kötü frame sayısı
  static const _requiredStableFrames = 1;
  static const _stabilityCentThreshold = 50.0;

  double _noiseFloor = 0.003;
  static const _noiseAdaptRate = 0.03;

  double _lastStablePitch = 0.0;

  /// Hassasiyet: 0.0 (çok hassas) — 1.0 (toleranslı).
  /// sensitivity_provider'dan gelir.
  double sensitivity = 0.5;

  /// Hassasiyete göre güven eşiği hesaplar.
  /// Hassas (0.0) → 0.35, Orta (0.5) → 0.25, Toleranslı (1.0) → 0.15
  double get minConfidence => 0.35 - sensitivity * 0.20;

  /// Hassasiyete göre noise gate çarpanı.
  /// Hassas → 2.0, Toleranslı → 1.3
  double get _noiseGateMultiplier => 2.0 - sensitivity * 0.7;

  void updateNoiseFloor(double rms) {
    if (rms < _noiseFloor * 2) {
      _noiseFloor = _noiseFloor * (1 - _noiseAdaptRate) +
          rms * _noiseAdaptRate;
      if (_noiseFloor < 0.001) _noiseFloor = 0.001;
    }
  }

  bool isAboveNoiseFloor(double rms) => rms > _noiseFloor * _noiseGateMultiplier;

  double get noiseFloor => _noiseFloor;
  int get stableFrames => _stableFrameCount;

  bool checkStability(double currentPitch) {
    _recentPitches.addLast(currentPitch);
    if (_recentPitches.length > _maxFrames) _recentPitches.removeFirst();

    if (_lastStablePitch <= 0) {
      _lastStablePitch = currentPitch;
      _stableFrameCount = 0;
      return false;
    }

    final centDiff =
        (1200.0 * log(currentPitch / _lastStablePitch) / ln2).abs();

    if (centDiff < _stabilityCentThreshold) {
      _stableFrameCount++;
      _unstableStreak = 0;
      _lastStablePitch = _lastStablePitch * 0.85 + currentPitch * 0.15;
    } else {
      _unstableStreak++;
      if (_unstableStreak >= 2) {
        // 2+ ardışık kötü frame → sıfırla (muhtemelen konuşma veya yeni nota)
        _lastStablePitch = currentPitch;
        _stableFrameCount = 0;
        _unstableStreak = 0;
      }
      // 1 kötü frame → tolerans göster, sayaç korunur
    }

    return _stableFrameCount >= _requiredStableFrames;
  }

  double pitchStabilityScore() {
    if (_recentPitches.length < 3) return 0.3;

    final pitches = _recentPitches.toList();
    final mean = pitches.reduce((a, b) => a + b) / pitches.length;

    double variance = 0.0;
    for (final p in pitches) {
      if (p > 0 && mean > 0) {
        final centDiff = 1200.0 * log(p / mean) / ln2;
        variance += centDiff * centDiff;
      }
    }
    final stdDev = sqrt(variance / pitches.length);
    return (1.0 - stdDev / 40.0).clamp(0.0, 1.0);
  }

  // Keman yay gürültüsü = 6-10 dB HNR. Eşik 5dB'den başlamalı.
  double hnrConfidence(double hnrDb) =>
      ((hnrDb - 5.0) / 15.0).clamp(0.0, 1.0);

  double sfmConfidence(double sfm) =>
      (1.0 - (sfm - 0.05) / 0.35).clamp(0.0, 1.0);

  double totalConfidence({
    required double stabilityScore,
    required double hnrScore,
    required double sfmScore,
    required double rms,
  }) {
    final signalScore = ((rms - 0.01) / 0.29).clamp(0.0, 1.0);
    // Keman için: HNR düşük olabilir (yay gürültüsü), ağırlığı azalt
    return stabilityScore * 0.40 +
        hnrScore * 0.15 +
        sfmScore * 0.20 +
        signalScore * 0.25;
  }

  void reset() {
    _recentPitches.clear();
    _noiseFloor = 0.003;
    _stableFrameCount = 0;
    _unstableStreak = 0;
    _lastStablePitch = 0.0;
  }
}
