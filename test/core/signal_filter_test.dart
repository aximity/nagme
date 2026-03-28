import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:nagme/core/signal_filter.dart';
import 'package:nagme/core/confidence_scorer.dart';
import 'package:nagme/utils/audio_utils.dart';

void main() {
  group('SignalFilter - bandpass', () {
    test('440Hz sinüs bandpass 200-1000Hz içinden geçer', () {
      final buffer = generateSineWave(frequency: 440.0);
      final filtered = SignalFilter.bandpass(
        buffer,
        lowCut: 200,
        highCut: 1000,
        sampleRate: 44100,
      );
      // Filtrelenmiş sinyal hala enerji içermeli
      double rms = 0;
      for (final s in filtered) { rms += s * s; }
      rms = sqrt(rms / filtered.length);
      expect(rms, greaterThan(0.1));
    });

    test('440Hz sinüs bandpass 1000-2000Hz ile zayıflar', () {
      final buffer = generateSineWave(frequency: 440.0);
      final filtered = SignalFilter.bandpass(
        buffer,
        lowCut: 1000,
        highCut: 2000,
        sampleRate: 44100,
      );
      double rms = 0;
      for (final s in filtered) { rms += s * s; }
      rms = sqrt(rms / filtered.length);
      // 440Hz, 1000Hz high-pass ile zayıflamalı
      expect(rms, lessThan(0.2));
    });
  });

  group('SignalFilter - HNR', () {
    test('saf sinüs yüksek HNR verir', () {
      final buffer = generateSineWave(frequency: 440.0, amplitude: 0.5);
      final hnr = SignalFilter.harmonicToNoiseRatio(buffer, 44100);
      expect(hnr, greaterThan(10.0));
    });

    test('gürültü düşük HNR verir', () {
      final rand = Random(42);
      final buffer = Float32List(4096);
      for (int i = 0; i < buffer.length; i++) {
        buffer[i] = (rand.nextDouble() * 2 - 1) * 0.3;
      }
      final hnr = SignalFilter.harmonicToNoiseRatio(buffer, 44100);
      expect(hnr, lessThan(10.0));
    });
  });

  group('SignalFilter - SFM', () {
    test('saf sinüs düşük SFM verir (tonal)', () {
      final buffer = generateSineWave(frequency: 440.0, length: 512);
      final sfm = SignalFilter.spectralFlatness(buffer);
      expect(sfm, lessThan(0.3));
    });
  });

  group('ConfidenceScorer', () {
    test('kararlı pitch ardışık frame kontrolünü geçer', () {
      final scorer = ConfidenceScorer();
      // Aynı frekansı tekrarla — 2. kararlı frame'de geçmeli
      expect(scorer.checkStability(440.0), false);
      expect(scorer.checkStability(441.0), true); // 2. ardışık kararlı frame
    });

    test('değişken pitch (konuşma) reddedilir', () {
      final scorer = ConfidenceScorer();
      expect(scorer.checkStability(440.0), false);
      expect(scorer.checkStability(330.0), false); // büyük sıçrama → reset
      expect(scorer.checkStability(500.0), false); // yine sıçrama
      expect(scorer.checkStability(220.0), false); // yine sıçrama
      expect(scorer.checkStability(380.0), false); // hiçbir zaman 4'e ulaşamaz
    });

    test('yüksek HNR yüksek güven verir', () {
      final scorer = ConfidenceScorer();
      expect(scorer.hnrConfidence(25.0), greaterThan(0.8));
    });

    test('düşük HNR düşük güven verir', () {
      final scorer = ConfidenceScorer();
      expect(scorer.hnrConfidence(3.0), equals(0.0));
    });

    test('adaptif noise gate sessizlikte güncellenir', () {
      final scorer = ConfidenceScorer();
      scorer.updateNoiseFloor(0.003);
      scorer.updateNoiseFloor(0.003);
      scorer.updateNoiseFloor(0.003);
      expect(scorer.noiseFloor, lessThan(0.008));
    });

    test('toplam güven skoru 0-1 arasında', () {
      final scorer = ConfidenceScorer();
      final score = scorer.totalConfidence(
        stabilityScore: 0.9,
        hnrScore: 0.8,
        sfmScore: 0.7,
        rms: 0.15,
      );
      expect(score, greaterThan(0.0));
      expect(score, lessThanOrEqualTo(1.0));
    });

    test('reset sonrası temiz başlangıç', () {
      final scorer = ConfidenceScorer();
      scorer.checkStability(440.0);
      scorer.checkStability(440.0);
      scorer.updateNoiseFloor(0.003);
      scorer.reset();
      expect(scorer.noiseFloor, equals(0.003));
    });
  });

  group('InstrumentFrequencyRange', () {
    test('keman aralığı doğru', () {
      final range = InstrumentFrequencyRange.forInstrument('violin');
      expect(range.lowHz, equals(80.0));
      expect(range.highHz, equals(3200.0));
    });

    test('gitar aralığı doğru', () {
      final range = InstrumentFrequencyRange.forInstrument('guitar');
      expect(range.lowHz, equals(50.0));
      expect(range.highHz, equals(1500.0));
    });

    test('kromatik geniş aralık', () {
      final range = InstrumentFrequencyRange.forInstrument('chromatic');
      expect(range.lowHz, equals(27.5));
      expect(range.highHz, equals(4186.0));
    });
  });
}
