import 'dart:async';
import 'dart:collection';

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

  int _smoothingWindow = 5;
  static const int _stringFilterSemitones = 2;
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

      await audioService.startCapture(
        minFreq: instrument.minFrequency,
        maxFreq: instrument.maxFrequency,
        confidenceThreshold: instrument.yinThreshold ?? 0.5,
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

    _ref.read(isListeningProvider.notifier).state = false;
    _freqBuffer.clear();
    state = const TunerState();
  }

  void _onPitchResult(PitchResult pitch) {
    if (!pitch.isValid) {
      _freqBuffer.clear();
      if (state.status != TunerStatus.idle) {
        state = const TunerState();
      }
      return;
    }

    final referenceA4 = _ref.read(referenceFreqProvider);

    // Tel filtresi: seçili tel varsa, hedeften ±2 yarım ton dışını atla
    final selectedString = _ref.read(selectedStringProvider);
    if (selectedString != null) {
      final targetMidi = NoteCalculator.frequencyToMidi(
        selectedString.frequency,
        referenceA4: referenceA4,
      );
      final detectedMidi = NoteCalculator.frequencyToMidi(
        pitch.frequency,
        referenceA4: referenceA4,
      );
      if (targetMidi > 0 &&
          detectedMidi > 0 &&
          (detectedMidi - targetMidi).abs() > _stringFilterSemitones) {
        return;
      }
    }

    // Smoothing: son N geçerli frekansın medyanı
    _freqBuffer.addLast(pitch.frequency);
    if (_freqBuffer.length > _smoothingWindow) {
      _freqBuffer.removeFirst();
    }

    final smoothedFreq = _median(_freqBuffer);

    final threshold = _ref.read(tuningThresholdProvider);

    final note = NoteCalculator.fromFrequency(
      smoothedFreq,
      referenceA4: referenceA4,
    );

    final TunerStatus status;
    if (note.cents.abs() <= threshold) {
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
  }

  double _median(Queue<double> values) {
    final sorted = values.toList()..sort();
    final mid = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[mid];
    return (sorted[mid - 1] + sorted[mid]) / 2;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
