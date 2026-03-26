import 'dart:math';
import 'dart:typed_data';

/// Enstrümana özel bandpass filtre ve sinyal analiz araçları.
class SignalFilter {
  /// Basit 2. derece Butterworth bandpass filtre uygular.
  ///
  /// [lowCut] ve [highCut]: frekans aralığı (Hz)
  /// [sampleRate]: örnekleme hızı
  static Float32List bandpass(
    Float32List input, {
    required double lowCut,
    required double highCut,
    required int sampleRate,
  }) {
    // High-pass filtre (lowCut altını kes)
    final hp = _highPass(input, lowCut, sampleRate);
    // Low-pass filtre (highCut üstünü kes)
    return _lowPass(hp, highCut, sampleRate);
  }

  /// 1. derece IIR high-pass filtre.
  static Float32List _highPass(Float32List input, double cutoff, int sampleRate) {
    final rc = 1.0 / (2.0 * pi * cutoff);
    final dt = 1.0 / sampleRate;
    final alpha = rc / (rc + dt);

    final output = Float32List(input.length);
    output[0] = input[0];

    for (int i = 1; i < input.length; i++) {
      output[i] = (alpha * (output[i - 1] + input[i] - input[i - 1])).toDouble();
    }
    return output;
  }

  /// 1. derece IIR low-pass filtre.
  static Float32List _lowPass(Float32List input, double cutoff, int sampleRate) {
    final rc = 1.0 / (2.0 * pi * cutoff);
    final dt = 1.0 / sampleRate;
    final alpha = dt / (rc + dt);

    final output = Float32List(input.length);
    output[0] = input[0];

    for (int i = 1; i < input.length; i++) {
      output[i] = (output[i - 1] + alpha * (input[i] - output[i - 1])).toDouble();
    }
    return output;
  }

  /// Harmonik-Gürültü Oranı (HNR) hesaplar.
  ///
  /// Yüksek HNR = temiz tonal sinyal (enstrüman).
  /// Düşük HNR = gürültülü sinyal (konuşma, ortam).
  /// Döndürür: dB cinsinden HNR değeri.
  static double harmonicToNoiseRatio(Float32List buffer, int sampleRate) {
    final n = buffer.length;
    if (n < 2) return 0.0;

    // Autocorrelation hesapla
    final halfN = n ~/ 2;
    double maxCorr = 0.0;
    double zeroCorr = 0.0;

    // R(0) — toplam enerji
    for (int i = 0; i < n; i++) {
      zeroCorr += buffer[i] * buffer[i];
    }
    if (zeroCorr < 1e-10) return 0.0;

    // En yüksek autocorrelation tepesini bul (tau > minPeriod)
    final minPeriod = sampleRate ~/ 4000; // max 4kHz
    final maxPeriod = min(halfN, sampleRate ~/ 50); // min 50Hz

    for (int tau = minPeriod; tau < maxPeriod; tau++) {
      double corr = 0.0;
      for (int i = 0; i < n - tau; i++) {
        corr += buffer[i] * buffer[i + tau];
      }
      if (corr > maxCorr) maxCorr = corr;
    }

    // HNR = 10 * log10(R_max / (R_0 - R_max))
    final noise = zeroCorr - maxCorr;
    if (noise < 1e-10) return 40.0; // Neredeyse saf ton
    return 10.0 * log(maxCorr / noise) / ln10;
  }

  /// Spektral Düzlük Ölçümü (SFM).
  ///
  /// 0'a yakın = tonal (enstrüman), 1'e yakın = gürültü.
  static double spectralFlatness(Float32List buffer) {
    final n = buffer.length;
    if (n < 2) return 1.0;

    // Basit güç spektrumu (FFT yerine periodogram yaklaşımı)
    final halfN = n ~/ 2;
    final power = Float64List(halfN);

    for (int k = 0; k < halfN; k++) {
      double re = 0.0, im = 0.0;
      for (int i = 0; i < n; i++) {
        final angle = -2.0 * pi * k * i / n;
        re += buffer[i] * cos(angle);
        im += buffer[i] * sin(angle);
      }
      power[k] = re * re + im * im;
    }

    // Geometrik ortalama / Aritmetik ortalama
    double logSum = 0.0;
    double sum = 0.0;
    int count = 0;

    for (int k = 1; k < halfN; k++) {
      if (power[k] > 1e-10) {
        logSum += log(power[k]);
        sum += power[k];
        count++;
      }
    }

    if (count == 0 || sum < 1e-10) return 1.0;

    final geoMean = exp(logSum / count);
    final ariMean = sum / count;

    return (geoMean / ariMean).clamp(0.0, 1.0);
  }
}

/// Enstrüman frekans aralıkları.
class InstrumentFrequencyRange {
  final double lowHz;
  final double highHz;

  const InstrumentFrequencyRange(this.lowHz, this.highHz);

  /// Enstrüman ID'sine göre frekans aralığı döndürür.
  static InstrumentFrequencyRange forInstrument(String instrumentId) {
    return switch (instrumentId) {
      // Aralıklar: en kalın tel frekansının %60'ı — en ince telin 3. harmoniği
      'violin'      => const InstrumentFrequencyRange(80.0, 3200.0),
      'guitar'      => const InstrumentFrequencyRange(50.0, 1500.0),
      'bass_guitar' => const InstrumentFrequencyRange(25.0, 500.0),
      'ukulele'     => const InstrumentFrequencyRange(150.0, 1500.0),
      'baglama'     => const InstrumentFrequencyRange(65.0, 1500.0),
      'ud'          => const InstrumentFrequencyRange(45.0, 1000.0),
      'viola'       => const InstrumentFrequencyRange(80.0, 2500.0),
      'cello'       => const InstrumentFrequencyRange(40.0, 1200.0),
      _             => const InstrumentFrequencyRange(27.5, 4186.0), // chromatic
    };
  }
}
