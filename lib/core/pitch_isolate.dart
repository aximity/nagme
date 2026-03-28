import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:nagme/config/constants.dart';
import 'package:nagme/core/confidence_scorer.dart';
import 'package:nagme/core/note_calculator.dart';
import 'package:nagme/core/pitch_detector.dart';
import 'package:nagme/core/signal_filter.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/models/note.dart';
import 'package:nagme/models/tuner_state.dart';

/// Isolate'ten donen pitch analiz sonucu.
class PitchIsolateResult {
  final TunerStatus status;
  final Note? note;
  final double? rawFrequency;
  final StringTuning? closestString;
  final double confidence;

  const PitchIsolateResult({
    required this.status,
    this.note,
    this.rawFrequency,
    this.closestString,
    this.confidence = 0.0,
  });
}

/// Isolate baslatma icin konfigurasyon.
class PitchIsolateConfig {
  final int sampleRate;
  final double refA4;
  final double sensitivity;
  final InstrumentTuning instrument;

  const PitchIsolateConfig({
    required this.sampleRate,
    required this.refA4,
    required this.sensitivity,
    required this.instrument,
  });
}

/// Pitch detection'i ayri Isolate'te calistiran yonetici.
///
/// UI thread'i bloklamamak icin tum agir hesaplama (YIN, bandpass,
/// HNR, SFM, confidence) worker isolate'te yapilir.
class PitchIsolateManager {
  Isolate? _isolate;
  SendPort? _workerPort;
  ReceivePort? _resultPort;
  StreamSubscription? _resultSub;

  final StreamController<PitchIsolateResult> _resultController =
      StreamController<PitchIsolateResult>.broadcast();

  Stream<PitchIsolateResult> get resultStream => _resultController.stream;

  /// Worker isolate'i baslatir.
  Future<void> start(PitchIsolateConfig config) async {
    await stop();

    _resultPort = ReceivePort();
    final initPort = ReceivePort();

    _isolate = await Isolate.spawn(
      _workerEntryPoint,
      _InitMessage(
        initSendPort: initPort.sendPort,
        resultSendPort: _resultPort!.sendPort,
        config: config,
      ),
    );

    // Worker ilk mesaj olarak kendi SendPort'unu gonderir
    _workerPort = await initPort.first as SendPort;
    initPort.close();

    _resultSub = _resultPort!.listen((message) {
      if (message is PitchIsolateResult) {
        _resultController.add(message);
      }
    });
  }

  /// Audio buffer'i islenmek uzere worker'a gonderir.
  void processBuffer(Float32List buffer) {
    _workerPort?.send(buffer);
  }

  /// Worker isolate'i durdurur (yeniden baslatilabilir).
  Future<void> stop() async {
    _workerPort?.send(null); // graceful shutdown sinyali
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _workerPort = null;
    await _resultSub?.cancel();
    _resultSub = null;
    _resultPort?.close();
    _resultPort = null;
  }

  /// Tamamen kapatir (stream controller dahil).
  Future<void> dispose() async {
    await stop();
    await _resultController.close();
  }
}

// ---------------------------------------------------------------------------
// Isolate iletisim mesajlari
// ---------------------------------------------------------------------------

class _InitMessage {
  final SendPort initSendPort;
  final SendPort resultSendPort;
  final PitchIsolateConfig config;

  const _InitMessage({
    required this.initSendPort,
    required this.resultSendPort,
    required this.config,
  });
}

// ---------------------------------------------------------------------------
// Worker isolate entry point (top-level function)
// ---------------------------------------------------------------------------

void _workerEntryPoint(_InitMessage init) {
  final receivePort = ReceivePort();
  init.initSendPort.send(receivePort.sendPort);

  final worker = _PitchWorker(
    config: init.config,
    resultPort: init.resultSendPort,
  );

  receivePort.listen((message) {
    if (message == null) {
      receivePort.close();
      return;
    }
    if (message is Float32List) {
      worker.processBuffer(message);
    }
  });
}

// ---------------------------------------------------------------------------
// Worker: tum agir hesaplama burada yapilir
// ---------------------------------------------------------------------------

class _PitchWorker {
  final PitchIsolateConfig config;
  final SendPort resultPort;

  late final PitchDetector _detector;
  final ConfidenceScorer _scorer = ConfidenceScorer();
  late final InstrumentFrequencyRange _freqRange;

  /// Median filter: son 3 frekans olcumu.
  final List<double> _recentFreqs = [];

  /// Hold time state.
  PitchIsolateResult? _lastValidResult;
  DateTime? _lastValidTime;
  static const _holdDuration = Duration(milliseconds: 80);

  _PitchWorker({required this.config, required this.resultPort}) {
    _detector = PitchDetector(sampleRate: config.sampleRate);
    _scorer.sensitivity = config.sensitivity;
    _freqRange = InstrumentFrequencyRange.forInstrument(config.instrument.id);
  }

  void processBuffer(Float32List buffer) {
    final sampleRate = config.sampleRate;
    final rms = PitchDetector.rms(buffer);

    // Sessizlik kontrolu
    if (rms < AppConstants.silenceThreshold) {
      _emitWithHold(const PitchIsolateResult(status: TunerStatus.noSignal));
      return;
    }

    var frequency = _detector.detect(buffer);
    if (frequency < 0) {
      _emitWithHold(const PitchIsolateResult(status: TunerStatus.noSignal));
      return;
    }

    // Frekans araligi kontrolu
    if (frequency < _freqRange.lowHz || frequency > _freqRange.highHz) {
      _emitWithHold(const PitchIsolateResult(status: TunerStatus.noSignal));
      return;
    }
    frequency = _correctHarmonicError(frequency);

    // Median filter
    frequency = _medianFilter(frequency);

    // Stabilite kontrolu
    final isStable = _scorer.checkStability(frequency);
    if (!isStable) {
      _emitWithHold(
          const PitchIsolateResult(status: TunerStatus.lowConfidence));
      return;
    }

    // Sinyal analizi
    final filtered = SignalFilter.bandpass(
      buffer,
      lowCut: _freqRange.lowHz,
      highCut: _freqRange.highHz,
      sampleRate: sampleRate,
    );
    final hnr = SignalFilter.harmonicToNoiseRatio(filtered, sampleRate);
    final sfmBuf = filtered.length > 512
        ? Float32List.sublistView(filtered, 0, 512)
        : filtered;
    final sfm = SignalFilter.spectralFlatness(sfmBuf);

    final stabilityScore = _scorer.pitchStabilityScore();
    final hnrScore = _scorer.hnrConfidence(hnr);
    final sfmScore = _scorer.sfmConfidence(sfm);
    final confidence = _scorer.totalConfidence(
      stabilityScore: stabilityScore,
      hnrScore: hnrScore,
      sfmScore: sfmScore,
      rms: rms,
    );

    if (confidence < _scorer.minConfidence) {
      _emitWithHold(PitchIsolateResult(
        status: TunerStatus.lowConfidence,
        confidence: confidence,
      ));
      return;
    }

    // Nota hesapla
    final note = noteFromFrequency(frequency, refA4: config.refA4);
    final closest = nearestString(frequency, config.instrument);

    final result = PitchIsolateResult(
      status: TunerStatus.detected,
      note: note,
      rawFrequency: frequency,
      closestString: closest,
      confidence: confidence,
    );

    _lastValidResult = result;
    _lastValidTime = DateTime.now();
    resultPort.send(result);
  }

  /// Hold time: sinyal kayboldiginda son gecerli notayi kisa sure tut.
  void _emitWithHold(PitchIsolateResult fallbackResult) {
    if (_lastValidResult != null && _lastValidTime != null) {
      final elapsed = DateTime.now().difference(_lastValidTime!);
      if (elapsed < _holdDuration) {
        resultPort.send(_lastValidResult!);
        return;
      }
    }
    _lastValidResult = null;
    _lastValidTime = null;
    _recentFreqs.clear();
    resultPort.send(fallbackResult);
  }

  /// Harmonik hata duzeltme (2x, 3x, 0.5x).
  double _correctHarmonicError(double frequency) {
    if (config.instrument.isChromatic) return frequency;

    double minCentDist = double.infinity;
    for (final s in config.instrument.strings) {
      final centDist = (1200.0 * log(frequency / s.frequency) / ln2).abs();
      if (centDist < minCentDist) minCentDist = centDist;
    }

    if (minCentDist < 150) return frequency;

    final candidates = [frequency / 2, frequency / 3, frequency * 2];
    double bestFreq = frequency;
    double bestDist = minCentDist;

    for (final candidate in candidates) {
      if (candidate < _freqRange.lowHz || candidate > _freqRange.highHz) {
        continue;
      }
      for (final s in config.instrument.strings) {
        final centDist =
            (1200.0 * log(candidate / s.frequency) / ln2).abs();
        if (centDist < bestDist) {
          bestDist = centDist;
          bestFreq = candidate;
        }
      }
    }

    if (bestDist < 50 && bestFreq != frequency) return bestFreq;
    return frequency;
  }

  /// Median filter: son 3 olcumun medyanini dondurur.
  double _medianFilter(double frequency) {
    _recentFreqs.add(frequency);
    if (_recentFreqs.length > 3) _recentFreqs.removeAt(0);
    if (_recentFreqs.length < 3) return frequency;

    final sorted = List<double>.from(_recentFreqs)..sort();
    return sorted[1];
  }
}
