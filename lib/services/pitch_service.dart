import 'dart:async';
import 'dart:typed_data';
import 'package:nagme/core/pitch_isolate.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/services/audio_service.dart';
import 'package:nagme/config/constants.dart';

/// Profesyonel pitch service — Isolate tabanli ses isleme.
///
/// Audio buffer'lari biriktirir, Isolate'e gonderir,
/// sonuclari TunerState stream'ine cevirir.
class PitchService {
  final AudioService _audioService;
  final double refA4;
  final InstrumentTuning instrument;
  final double sensitivity;

  StreamSubscription<Float32List>? _audioSub;
  StreamSubscription<PitchIsolateResult>? _isolateSub;
  final StreamController<TunerState> _controller =
      StreamController<TunerState>.broadcast();

  final List<double> _accumulator = [];
  final PitchIsolateManager _isolateManager = PitchIsolateManager();

  PitchService({
    AudioService? audioService,
    this.refA4 = AppConstants.defaultRefHz,
    required this.instrument,
    this.sensitivity = 0.5,
  }) : _audioService = audioService ?? AudioService();

  Stream<TunerState> get stateStream => _controller.stream;

  Future<void> start() async {
    await _audioService.start();

    // Isolate'i baslat
    await _isolateManager.start(PitchIsolateConfig(
      sampleRate: _audioService.actualSampleRate,
      refA4: refA4,
      sensitivity: sensitivity,
      instrument: instrument,
    ));

    // Isolate sonuclarini dinle
    _isolateSub = _isolateManager.resultStream.listen(_onIsolateResult);

    // Mikrofon verisini dinle
    _audioSub = _audioService.stream.listen(_onAudioData);
    _controller.add(const TunerState(status: TunerStatus.listening));
  }

  Future<void> stop() async {
    await _audioSub?.cancel();
    _audioSub = null;
    await _isolateSub?.cancel();
    _isolateSub = null;
    await _isolateManager.stop();
    await _audioService.stop();
    _accumulator.clear();
    _controller.add(TunerState.initial);
  }

  Future<void> dispose() async {
    await stop();
    await _controller.close();
    await _isolateManager.dispose();
    await _audioService.dispose();
  }

  /// Audio verisi geldiginde buffer biriktirir ve Isolate'e gonderir.
  void _onAudioData(Float32List data) {
    _accumulator.addAll(data);
    if (_accumulator.length < AppConstants.bufferSize) return;

    final buffer = Float32List.fromList(
      _accumulator.sublist(0, AppConstants.bufferSize),
    );
    _accumulator.removeRange(0, AppConstants.bufferSize);

    // Buffer'i Isolate'e gonder — UI thread'i bloklamaz
    _isolateManager.processBuffer(buffer);
  }

  /// Isolate'ten gelen sonuclari TunerState'e cevirir.
  void _onIsolateResult(PitchIsolateResult result) {
    final state = TunerState(
      status: result.status,
      currentNote: result.note,
      rawFrequency: result.rawFrequency,
      closestString: result.closestString,
      confidence: result.confidence,
    );
    _controller.add(state);
  }
}
