import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/instrument.dart';
import '../models/pitch_result.dart';
import '../models/tuner_state.dart';
import '../services/audio_service.dart';
import '../services/note_calculator.dart';
import '../services/tone_generator.dart';
import 'instrument_provider.dart';
import 'settings_provider.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

final toneGeneratorProvider = Provider<ToneGenerator>((ref) {
  final generator = ToneGenerator();
  ref.onDispose(() => generator.dispose());
  return generator;
});

final isListeningProvider = StateProvider<bool>((ref) => false);

final selectedStringProvider = StateProvider<StringTuning?>((ref) => null);

final tunerStateProvider = StateNotifierProvider<TunerStateNotifier, TunerState>(
  (ref) => TunerStateNotifier(ref),
);

class TunerStateNotifier extends StateNotifier<TunerState> {
  final Ref _ref;
  StreamSubscription<PitchResult>? _subscription;
  Timer? _holdTimer;
  static const Duration _holdDuration = Duration(milliseconds: 2000);

  int _smoothingWindow = 5;
  int _consecutiveValid = 0;
  final Queue<double> _freqBuffer = Queue<double>();

  TunerStateNotifier(this._ref) : super(const TunerState()) {
    final instrument = _ref.read(selectedInstrumentProvider);
    _smoothingWindow = instrument.smoothingWindow ?? 5;

    // Enstrüman değiştiğinde seçili teli sıfırla ve smoothing güncelle
    _ref.listen(selectedInstrumentProvider, (_, instrument) {
      _ref.read(selectedStringProvider.notifier).state = null;
      _smoothingWindow = instrument.smoothingWindow ?? 5;
    });
  }

  Future<void> startListening() async {
    // Hızlı toggle koruması: önceki dinleme varsa önce durdur
    if (_subscription != null) await stopListening();

    try {
      _ref.read(toneGeneratorProvider).stop();

      final audioService = _ref.read(audioServiceProvider);
      final instrument = _ref.read(selectedInstrumentProvider);

      // Seviyeye göre yinThreshold çarpanı
      final level = _ref.read(detectionLevelProvider);
      final baseYin = instrument.yinThreshold ?? 0.5;
      final double yinMultiplier;
      switch (level) {
        case DetectionLevel.beginner:
          yinMultiplier = 1.5;
        case DetectionLevel.intermediate:
          yinMultiplier = 1.0;
        case DetectionLevel.advanced:
          yinMultiplier = 0.7;
      }

      await audioService.startCapture(
        minFreq: instrument.minFrequency,
        maxFreq: instrument.maxFrequency,
        confidenceThreshold: baseYin * yinMultiplier,
        bufferSize: instrument.preferredBufferSize ?? 2048,
      );
      _ref.read(isListeningProvider.notifier).state = true;
      _freqBuffer.clear();

      _subscription = audioService.pitchStream.listen(
        _onPitchResult,
        onError: (_) => stopListening(),
      );
    } catch (_) {
      _ref.read(isListeningProvider.notifier).state = false;
      state = const TunerState();
    }
  }

  Future<void> stopListening() async {
    _subscription?.cancel();
    _subscription = null;

    final audioService = _ref.read(audioServiceProvider);
    await audioService.stopCapture();

    _holdTimer?.cancel();
    _holdTimer = null;
    _ref.read(isListeningProvider.notifier).state = false;
    _freqBuffer.clear();
    _consecutiveValid = 0;
    state = const TunerState();
  }

  void _onPitchResult(PitchResult pitch) {
    if (!pitch.isValid) {
      _freqBuffer.clear();
      _consecutiveValid = 0;
      // Hemen idle'a düşme — hold timer'ın bitmesini bekle
      return;
    }

    final referenceA4 = _ref.read(referenceFreqProvider);

    // Tel filtresi: nota sınıfı kilidi — oktavdan bağımsız eşleşme
    final selectedString = _ref.read(selectedStringProvider);
    if (selectedString != null) {
      final targetNoteName = _stripOctave(selectedString.name);

      final detectedNote = NoteCalculator.fromFrequency(
        pitch.frequency,
        referenceA4: referenceA4,
      );
      final detectedNoteName = detectedNote.name;

      // Nota sınıfları eşleşmiyorsa reddet (smoothing buffer'a girmesin)
      if (detectedNoteName != targetNoteName) {
        return;
      }
      // Eşleşiyorsa normal akışa devam — smoothing, status hesaplama vs.
    }

    // Harmonik tutarlılık: önceki frekansla karşılaştır, ani atlamaları reddet
    if (_freqBuffer.isNotEmpty) {
      final ratio = pitch.frequency / _freqBuffer.last;
      if (ratio < 0.85 || ratio > 1.18) {
        _freqBuffer.clear();
        _consecutiveValid = 0;
        return;
      }
    }

    // Adaptif smoothing: pizzicato'da küçük pencere, arşe'de büyük pencere
    _consecutiveValid++;
    final effectiveWindow = _consecutiveValid < _smoothingWindow
        ? _consecutiveValid.clamp(2, _smoothingWindow)
        : _smoothingWindow;

    _freqBuffer.addLast(pitch.frequency);
    while (_freqBuffer.length > effectiveWindow) {
      _freqBuffer.removeFirst();
    }

    final smoothedFreq = _median(_freqBuffer);

    final baseThreshold = _ref.read(tuningThresholdProvider);

    // Seviyeye göre akort eşiği ayarla
    final level = _ref.read(detectionLevelProvider);
    final int effectiveThreshold;
    switch (level) {
      case DetectionLevel.beginner:
        effectiveThreshold = baseThreshold + 5;
      case DetectionLevel.intermediate:
        effectiveThreshold = baseThreshold;
      case DetectionLevel.advanced:
        effectiveThreshold = (baseThreshold - 3).clamp(1, baseThreshold);
    }

    // Seçili tel varsa cents'i hedef telin frekansına göre hesapla
    if (selectedString != null) {
      final targetFreq = selectedString.frequency;
      final centsFromTarget = 1200 * (log(smoothedFreq / targetFreq) / ln2);

      final TunerStatus statusVsTarget;
      if (centsFromTarget.abs() <= effectiveThreshold) {
        statusVsTarget = TunerStatus.inTune;
      } else if (centsFromTarget < 0) {
        statusVsTarget = TunerStatus.flat;
      } else {
        statusVsTarget = TunerStatus.sharp;
      }

      final noteName = _stripOctave(selectedString.name);

      // Gereksiz rebuild önle
      if (state.note == noteName &&
          state.octave == selectedString.octave &&
          state.status == statusVsTarget &&
          (state.cents - centsFromTarget).abs() < 1) {
        return;
      }

      state = TunerState(
        status: statusVsTarget,
        note: noteName,
        octave: selectedString.octave,
        frequency: smoothedFreq,
        cents: centsFromTarget,
      );

      _holdTimer?.cancel();
      _holdTimer = Timer(_holdDuration, () {
        state = const TunerState();
      });
      return;
    }

    // Kromatik mod — en yakın notaya göre hesapla
    final note = NoteCalculator.fromFrequency(
      smoothedFreq,
      referenceA4: referenceA4,
    );

    final TunerStatus status;
    if (note.cents.abs() <= effectiveThreshold) {
      status = TunerStatus.inTune;
    } else if (note.cents < 0) {
      status = TunerStatus.flat;
    } else {
      status = TunerStatus.sharp;
    }

    // Gereksiz rebuild önle: aynı nota + benzer cent (±1)
    if (state.note == note.name &&
        state.octave == note.octave &&
        state.status == status &&
        (state.cents - note.cents).abs() < 1) {
      return;
    }

    state = TunerState(
      status: status,
      note: note.name,
      octave: note.octave,
      frequency: smoothedFreq,
      cents: note.cents,
    );

    // Hold timer'ı sıfırla — 2 saniye yeni geçerli pitch gelmezse idle'a dön
    _holdTimer?.cancel();
    _holdTimer = Timer(_holdDuration, () {
      state = const TunerState();
    });
  }

  double _median(Queue<double> values) {
    final sorted = values.toList()..sort();
    final mid = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[mid];
    return (sorted[mid - 1] + sorted[mid]) / 2;
  }

  // "A4" → "A", "F#1" → "F#", "Bb3" → "Bb"
  String _stripOctave(String noteName) {
    return noteName.replaceAll(RegExp(r'\d+$'), '');
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _holdTimer?.cancel();
    super.dispose();
  }
}
