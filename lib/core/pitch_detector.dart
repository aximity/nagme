import 'dart:math';
import 'dart:typed_data';
import 'package:nagme/config/constants.dart';

/// YIN pitch detection algoritması.
///
/// Referans: De Cheveigné & Kawahara (2002)
/// Hann window + parabolic interpolation ile geliştirilmiş versiyon.
class PitchDetector {
  final int sampleRate;
  final double threshold;

  const PitchDetector({
    this.sampleRate = AppConstants.sampleRate,
    this.threshold = AppConstants.yinThreshold,
  });

  /// PCM buffer'dan pitch algılar.
  ///
  /// Döndürür: algılanan frekans (Hz), sinyal yoksa -1.0
  double detect(Float32List buffer) {
    if (_rms(buffer) < AppConstants.silenceThreshold) return -1.0;

    // Hann window uygula — spectral leakage azaltır,
    // düşük frekanslar (G3=196Hz) daha kararlı algılanır
    final windowed = _applyHannWindow(buffer);

    final int halfLen = windowed.length ~/ 2;
    final yinBuffer = Float64List(halfLen);

    _differenceFunction(windowed, yinBuffer);
    _cumulativeMeanNormalized(yinBuffer);

    int tauEstimate = _absoluteThreshold(yinBuffer);
    if (tauEstimate == -1) return -1.0;

    final double betterTau = _parabolicInterpolation(yinBuffer, tauEstimate);
    final double frequency = sampleRate / betterTau;

    if (frequency < AppConstants.minFrequency ||
        frequency > AppConstants.maxFrequency) {
      return -1.0;
    }

    return frequency;
  }

  /// RMS (Root Mean Square) hesaplar.
  static double rms(Float32List buffer) => _rms(buffer);

  static double _rms(Float32List buffer) {
    double sum = 0.0;
    for (int i = 0; i < buffer.length; i++) {
      sum += buffer[i] * buffer[i];
    }
    return sqrt(sum / buffer.length);
  }

  /// Hann window uygular.
  Float32List _applyHannWindow(Float32List buffer) {
    final n = buffer.length;
    final windowed = Float32List(n);
    for (int i = 0; i < n; i++) {
      final w = 0.5 * (1 - cos(2 * pi * i / (n - 1)));
      windowed[i] = (buffer[i] * w).toDouble();
    }
    return windowed;
  }

  /// YIN Adım 1: Difference function
  void _differenceFunction(Float32List buffer, Float64List yinBuffer) {
    final int halfLen = yinBuffer.length;
    for (int tau = 0; tau < halfLen; tau++) {
      double sum = 0.0;
      for (int j = 0; j < halfLen; j++) {
        final double diff = buffer[j] - buffer[j + tau];
        sum += diff * diff;
      }
      yinBuffer[tau] = sum;
    }
  }

  /// YIN Adım 2: Cumulative mean normalized difference
  void _cumulativeMeanNormalized(Float64List yinBuffer) {
    yinBuffer[0] = 1.0;
    double runningSum = 0.0;
    for (int tau = 1; tau < yinBuffer.length; tau++) {
      runningSum += yinBuffer[tau];
      yinBuffer[tau] = yinBuffer[tau] * tau / runningSum;
    }
  }

  /// YIN Adım 3: Absolute threshold — eşik altındaki ilk minimum tau.
  int _absoluteThreshold(Float64List yinBuffer) {
    final int minTau = max(2, (sampleRate / AppConstants.maxFrequency).floor());
    final int maxTau =
        min(yinBuffer.length - 1, (sampleRate / AppConstants.minFrequency).ceil());

    for (int tau = minTau; tau < maxTau; tau++) {
      if (yinBuffer[tau] < threshold) {
        while (tau + 1 < maxTau && yinBuffer[tau + 1] < yinBuffer[tau]) {
          tau++;
        }
        return tau;
      }
    }
    return -1;
  }

  /// YIN Adım 4: Parabolic interpolation
  double _parabolicInterpolation(Float64List yinBuffer, int tauEstimate) {
    if (tauEstimate < 1 || tauEstimate >= yinBuffer.length - 1) {
      return tauEstimate.toDouble();
    }

    final double s0 = yinBuffer[tauEstimate - 1];
    final double s1 = yinBuffer[tauEstimate];
    final double s2 = yinBuffer[tauEstimate + 1];

    final double denominator = 2.0 * s1 - s2 - s0;
    if (denominator.abs() < 1e-10) return tauEstimate.toDouble();

    final double adjustment = (s2 - s0) / (2.0 * denominator);
    return tauEstimate + adjustment;
  }
}
