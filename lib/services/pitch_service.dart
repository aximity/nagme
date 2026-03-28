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
  double _refA4;
  InstrumentTuning _instrument;
  double _sensitivity;

  StreamSubscription<Float32List>? _audioSub;
  StreamSubscription<PitchIsolateResult>? _isolateSub;
  final StreamController<TunerState> _controller =
      StreamController<TunerState>.broadcast();

  final List<double> _accumulator = [];
  final PitchIsolateManager _isolateManager = PitchIsolateManager();

  PitchService({
    AudioService? audioService,
    double refA4 = AppConstants.defaultRefHz,
    required InstrumentTuning instrument,
    double sensitivity = 0.5,
  })  : _audioService = audioService ?? AudioService(),
        _refA4 = refA4,
        _instrument = instrument,
        _sensitivity = sensitivity;

  Stream<TunerState> get stateStream => _controller.stream;

  Future<void> start() async {
    await _audioService.start();

    // Isolate'i baslat
    await _isolateManager.start(_currentConfig());

    // Isolate sonuclarini dinle
    _isolateSub = _isolateManager.resultStream.listen(_onIsolateResult);

    // Mikrofon verisini dinle
    _audioSub = _audioService.stream.listen(_onAudioData);
    _controller.add(const TunerState(status: TunerStatus.listening));
  }

  /// Mikrofon stream'ini kesmeden ayarlari gunceller.
  ///
  /// Enstruman, referans Hz veya hassasiyet degistiginde cagirilir.
  /// Sadece worker isolate yeniden baslatilir, mikrofon devam eder.
  Future<void> updateConfig({
    InstrumentTuning? instrument,
    double? refA4,
    double? sensitivity,
  }) async {
    if (instrument != null) _instrument = instrument;
    if (refA4 != null) _refA4 = refA4;
    if (sensitivity != null) _sensitivity = sensitivity;

    // Eski isolate listener'ini kaldir
    await _isolateSub?.cancel();

    // Accumulator'u temizle — eski config ile biriken veri yeni isolate'e gitmesin
    _accumulator.clear();

    // Yeni config ile isolate'i yeniden baslat (mikrofon devam ediyor)
    await _isolateManager.start(_currentConfig());

    // Yeni isolate'in sonuclarini dinle
    _isolateSub = _isolateManager.resultStream.listen(_onIsolateResult);
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

  PitchIsolateConfig _currentConfig() => PitchIsolateConfig(
        sampleRate: _audioService.actualSampleRate,
        refA4: _refA4,
        sensitivity: _sensitivity,
        instrument: _instrument,
      );

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
