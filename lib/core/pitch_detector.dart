import 'dart:typed_data';
import 'package:nagme/config/constants.dart';
import 'package:nagme/utils/audio_utils.dart';

/// YIN algoritması için parametre sınıfı (Isolate'e geçilebilir).
class PitchInput {
  const PitchInput(this.buffer, this.sampleRate);
  final Float32List buffer;
  final int sampleRate;
}

/// [compute] ile çağrılmak üzere tasarlanmış top-level fonksiyon.
/// Sessizlik veya tespit edilemeyen frekans için -1.0 döndürür.
double detectPitch(PitchInput input) {
  final buffer = input.buffer;
  final sampleRate = input.sampleRate;

  // 1. RMS eşik kontrolü — çok sessiz sinyal
  if (calculateRms(buffer) < AppConstants.rmsThreshold) return -1.0;

  final n = buffer.length;
  final halfN = n ~/ 2;

  // 2. Difference function: d[τ] = Σ(x[j] - x[j+τ])²
  final diff = Float64List(halfN);
  for (int tau = 1; tau < halfN; tau++) {
    double sum = 0.0;
    for (int j = 0; j < halfN; j++) {
      final delta = buffer[j] - buffer[j + tau];
      sum += delta * delta;
    }
    diff[tau] = sum;
  }

  // 3. Cumulative mean normalized difference (CMND)
  final cmnd = Float64List(halfN);
  cmnd[0] = 1.0;
  double runningSum = 0.0;
  for (int tau = 1; tau < halfN; tau++) {
    runningSum += diff[tau];
    cmnd[tau] = runningSum > 0 ? diff[tau] * tau / runningSum : 0.0;
  }

  // 4. Absolute threshold — ilk minimum < yinThreshold
  int tau = 2;
  while (tau < halfN - 1) {
    if (cmnd[tau] < AppConstants.yinThreshold) {
      // Yerel minimumu bul
      while (tau + 1 < halfN && cmnd[tau + 1] < cmnd[tau]) {
        tau++;
      }
      break;
    }
    tau++;
  }

  if (tau >= halfN - 1) return -1.0; // Uygun τ bulunamadı

  // 5. Parabolic interpolation — sub-sample hassasiyet
  final tauRefined = _parabolicInterpolation(cmnd, tau);
  if (tauRefined <= 0) return -1.0;

  return sampleRate / tauRefined;
}

double _parabolicInterpolation(Float64List cmnd, int tau) {
  if (tau <= 0 || tau >= cmnd.length - 1) return tau.toDouble();
  final s0 = cmnd[tau - 1];
  final s1 = cmnd[tau];
  final s2 = cmnd[tau + 1];
  final denom = 2 * (2 * s1 - s0 - s2);
  if (denom.abs() < 1e-10) return tau.toDouble();
  return tau + (s0 - s2) / denom;
}
