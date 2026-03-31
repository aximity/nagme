import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nagme/core/pitch_detector.dart';
import 'package:nagme/core/note_calculator.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/services/audio_service.dart';

class PitchService {
  PitchService({required this.audioService});

  final AudioService audioService;
  StreamSubscription<Float32List>? _subscription;
  final _stateController = StreamController<TunerState>.broadcast();

  Stream<TunerState> get stateStream => _stateController.stream;

  Future<void> start({
    required InstrumentTuning instrument,
    required double refA4,
    required int tuneThreshold,
  }) async {
    await audioService.start();
    _subscription = audioService.bufferStream.listen(
      (buffer) => unawaited(_processBuffer(
        buffer,
        instrument: instrument,
        refA4: refA4,
        tuneThreshold: tuneThreshold,
      )),
      onError: (e) => _stateController.addError(e),
    );
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    await audioService.stop();
  }

  Future<void> _processBuffer(
    Float32List buffer, {
    required InstrumentTuning instrument,
    required double refA4,
    required int tuneThreshold,
  }) async {
    final freq = await compute(detectPitch, PitchInput(buffer, AppConstants.sampleRate));

    if (freq <= 0) {
      // Sessizlik — notu temizle, aktif durumu koru
      _stateController.add(const TunerState(isActive: true));
      return;
    }

    final note = NoteCalculator.noteFromFrequency(freq, refA4: refA4);
    if (note == null) return;

    final closestString = NoteCalculator.nearestString(freq, instrument);

    // Enstrüman modunda: tel'e göre cent, kromatik modda: nota'ya göre cent
    final displayCents = closestString != null
        ? NoteCalculator.centsOffset(freq, closestString.frequency)
        : note.cents;

    _stateController.add(TunerState(
      currentNote: note,
      frequency: freq,
      cents: displayCents,
      isInTune: displayCents.abs() <= tuneThreshold,
      isActive: true,
      closestString: closestString,
    ));
  }

  void dispose() {
    stop();
    _stateController.close();
  }
}
