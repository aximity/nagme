import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/services/audio_service.dart';
import 'package:nagme/services/pitch_service.dart';
import 'package:nagme/providers/settings_provider.dart';
import 'package:nagme/providers/instrument_provider.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});

final pitchServiceProvider = Provider<PitchService>((ref) {
  final audio = ref.watch(audioServiceProvider);
  final service = PitchService(audioService: audio);
  ref.onDispose(service.dispose);
  return service;
});

class TunerNotifier extends StateNotifier<TunerState> {
  TunerNotifier(this._ref) : super(TunerState.idle);

  final Ref _ref;
  StreamSubscription<TunerState>? _subscription;

  Future<void> start() async {
    if (state.isActive) return;

    final pitchService = _ref.read(pitchServiceProvider);
    final instrument = _ref.read(selectedInstrumentProvider);
    final refA4 = _ref.read(referenceHzProvider);
    final threshold = _ref.read(tuneThresholdProvider);

    state = state.copyWith(isActive: true);

    _subscription = pitchService.stateStream.listen(
      (s) => state = s,
      onError: (_) => state = TunerState.idle,
    );

    try {
      await pitchService.start(
        instrument: instrument,
        refA4: refA4,
        tuneThreshold: threshold,
      );
    } catch (e) {
      state = TunerState.idle;
      rethrow;
    }
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    final pitchService = _ref.read(pitchServiceProvider);
    await pitchService.stop();
    state = TunerState.idle;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final tunerProvider = StateNotifierProvider<TunerNotifier, TunerState>((ref) {
  return TunerNotifier(ref);
});

/// Waveform için son audio buffer — RepaintBoundary ile verimli güncellenir.
final waveformBufferProvider = StateProvider<Float32List?>((ref) => null);
