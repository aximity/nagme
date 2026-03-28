import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:nagme/core/pitch_detector.dart';
import 'package:nagme/core/note_calculator.dart';
import 'package:nagme/core/signal_filter.dart';
import 'package:nagme/core/confidence_scorer.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/services/audio_service.dart';
import 'package:nagme/config/constants.dart';

/// Profesyonel pitch service — 5 katmanlı filtreleme + hold time.
class PitchService {
  final AudioService _audioService;
  final double refA4;
  final InstrumentTuning instrument;
  final double sensitivity;

  StreamSubscription<Float32List>? _audioSub;
  final StreamController<TunerState> _controller =
      StreamController<TunerState>.broadcast();

  final List<double> _accumulator = [];
  late PitchDetector _detector;
  final ConfidenceScorer _scorer = ConfidenceScorer();
  late final InstrumentFrequencyRange _freqRange;

  /// Hold time: son geçerli state + timestamp.
  TunerState? _lastValidState;
  DateTime? _lastValidTime;
  static const _holdDuration = Duration(milliseconds: 80);

  /// Median filter: son 3 frekans ölçümü — outlier'ları eler.
  final List<double> _recentFreqs = [];

  PitchService({
    AudioService? audioService,
    this.refA4 = AppConstants.defaultRefHz,
    required this.instrument,
    this.sensitivity = 0.5,
  }) : _audioService = audioService ?? AudioService() {
    _freqRange = InstrumentFrequencyRange.forInstrument(instrument.id);
    _scorer.sensitivity = sensitivity;
  }

  Stream<TunerState> get stateStream => _controller.stream;

  Future<void> start() async {
    _scorer.reset();
    _scorer.sensitivity = sensitivity;
    _lastValidState = null;
    _lastValidTime = null;
    await _audioService.start();
    _detector = PitchDetector(sampleRate: _audioService.actualSampleRate);
    _audioSub = _audioService.stream.listen(_onAudioData);
    _controller.add(const TunerState(status: TunerStatus.listening));
  }

  Future<void> stop() async {
    await _audioSub?.cancel();
    _audioSub = null;
    await _audioService.stop();
    _accumulator.clear();
    _recentFreqs.clear();
    _scorer.reset();
    _lastValidState = null;
    _lastValidTime = null;
    _controller.add(TunerState.initial);
  }

  Future<void> dispose() async {
    await stop();
    await _controller.close();
    await _audioService.dispose();
  }

  void _onAudioData(Float32List data) {
    _accumulator.addAll(data);
    if (_accumulator.length < AppConstants.bufferSize) return;

    final buffer = Float32List.fromList(
      _accumulator.sublist(0, AppConstants.bufferSize),
    );
    _accumulator.removeRange(0, AppConstants.bufferSize);
    _processBuffer(buffer);
  }

  int _debugCounter = 0;

  void _processBuffer(Float32List buffer) {
    final sampleRate = _audioService.actualSampleRate;
    final rms = PitchDetector.rms(buffer);
    final shouldLog = (_debugCounter++ % 20 == 0); // Her 20 buffer'da bir logla

    // Sabit sessizlik eşiği — adaptif gate Android'de sorun çıkarıyordu
    if (rms < AppConstants.silenceThreshold) {
      if (shouldLog) {
        debugPrint('[NAGME] silence: rms=$rms threshold=${AppConstants.silenceThreshold}');
      }
      _emitWithHold(const TunerState(status: TunerStatus.noSignal));
      return;
    }

    var frequency = _detector.detect(buffer);
    if (frequency < 0) {
      if (shouldLog) debugPrint('[NAGME] YIN no pitch: rms=$rms');
      _emitWithHold(const TunerState(status: TunerStatus.noSignal));
      return;
    }

    if (frequency < _freqRange.lowHz || frequency > _freqRange.highHz) {
      if (shouldLog) debugPrint('[NAGME] out of range: freq=$frequency range=${_freqRange.lowHz}-${_freqRange.highHz}');
      _emitWithHold(const TunerState(status: TunerStatus.noSignal));
      return;
    }
    frequency = _correctHarmonicError(frequency);

    // Median filter: son 3 ölçümün medyanı — tek bir outlier frame'i eler
    frequency = _medianFilter(frequency);

    final isStable = _scorer.checkStability(frequency);
    if (!isStable) {
      if (shouldLog) debugPrint('[NAGME] unstable: freq=$frequency stableFrames=${_scorer.stableFrames}');
      _emitWithHold(const TunerState(status: TunerStatus.lowConfidence));
      return;
    }

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

    if (shouldLog) {
      debugPrint('[NAGME] freq=$frequency rms=$rms confidence=$confidence (stab=$stabilityScore hnr=$hnrScore sfm=$sfmScore) min=${_scorer.minConfidence}');
    }

    if (confidence < _scorer.minConfidence) {
      _emitWithHold(TunerState(
        status: TunerStatus.lowConfidence,
        confidence: confidence,
      ));
      return;
    }

    final note = noteFromFrequency(frequency, refA4: refA4);
    final closest = nearestString(frequency, instrument);

    final state = TunerState(
      status: TunerStatus.detected,
      currentNote: note,
      rawFrequency: frequency,
      closestString: closest,
      confidence: confidence,
    );

    _lastValidState = state;
    _lastValidTime = DateTime.now();
    _controller.add(state);
  }

  /// Hold time: sinyal kaybolduğunda son geçerli notayı kısa süre tut.
  void _emitWithHold(TunerState fallbackState) {
    if (_lastValidState != null && _lastValidTime != null) {
      final elapsed = DateTime.now().difference(_lastValidTime!);
      if (elapsed < _holdDuration) {
        _controller.add(_lastValidState!);
        return;
      }
    }
    // Sinyal kesildi — median filter'ı temizle, eski nota takılmasın
    _lastValidState = null;
    _lastValidTime = null;
    _recentFreqs.clear();
    _controller.add(fallbackState);
  }

  /// Harmonik hata düzeltme (2x, 3x, 0.5x).
  ///
  /// Sadece algılanan frekans bir telden 150+ cent uzaktaysa ve
  /// bir harmonik adayı 50 cent içinde bir tele denk geliyorsa düzeltir.
  /// Bu, hoparlör harmoniklerinin yanlış eşleşmesini önler.
  double _correctHarmonicError(double frequency) {
    if (instrument.isChromatic) return frequency;

    double minCentDist = double.infinity;
    for (final s in instrument.strings) {
      final centDist = (1200.0 * log(frequency / s.frequency) / ln2).abs();
      if (centDist < minCentDist) minCentDist = centDist;
    }

    // Zaten bir tele yeterince yakınsa düzeltme yapma
    if (minCentDist < 150) return frequency;

    final candidates = [frequency / 2, frequency / 3, frequency * 2];
    double bestFreq = frequency;
    double bestDist = minCentDist;

    for (final candidate in candidates) {
      // Adayın makul frekans aralığında olduğundan emin ol
      if (candidate < _freqRange.lowHz || candidate > _freqRange.highHz) {
        continue;
      }
      for (final s in instrument.strings) {
        final centDist =
            (1200.0 * log(candidate / s.frequency) / ln2).abs();
        if (centDist < bestDist) {
          bestDist = centDist;
          bestFreq = candidate;
        }
      }
    }

    // Sadece aday gerçekten bir tele çok yakınsa düzelt (50 cent içinde)
    if (bestDist < 50 && bestFreq != frequency) return bestFreq;
    return frequency;
  }

  /// Median filter: son 3 ölçümün medyanını döndürür.
  /// Tek bir outlier frame'i (harmonik hatası, gürültü spike) eler.
  double _medianFilter(double frequency) {
    _recentFreqs.add(frequency);
    if (_recentFreqs.length > 3) _recentFreqs.removeAt(0);
    if (_recentFreqs.length < 3) return frequency;

    final sorted = List<double>.from(_recentFreqs)..sort();
    return sorted[1]; // medyan
  }
}
