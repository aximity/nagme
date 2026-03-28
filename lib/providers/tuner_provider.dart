import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/models/tuning_session.dart';
import 'package:nagme/services/pitch_service.dart';
import 'package:nagme/providers/instrument_provider.dart';
import 'package:nagme/providers/settings_provider.dart';
import 'package:nagme/providers/sensitivity_provider.dart';
import 'package:nagme/main.dart';

/// Hata mesajı provider'ı — UI'da göstermek için.
final tunerErrorProvider = StateProvider<String?>((ref) => null);

/// Ana tuner state provider.
final tunerProvider =
    StateNotifierProvider<TunerNotifier, TunerState>((ref) {
  return TunerNotifier(ref);
});

class TunerNotifier extends StateNotifier<TunerState> {
  final Ref _ref;
  PitchService? _pitchService;
  StreamSubscription<TunerState>? _subscription;
  bool _busy = false; // Race condition koruması

  // Oturum tracking
  DateTime? _sessionStart;
  int _detectedCount = 0;
  int _inTuneCount = 0;

  TunerNotifier(this._ref) : super(TunerState.initial) {
    // Enstrüman, referans frekans veya hassasiyet değiştiğinde
    // tuner aktifse otomatik yeniden başlat.
    _ref.listen(selectedInstrumentProvider, (prev, next) {
      _restartIfActive();
    });
    _ref.listen(refA4Provider, (prev, next) {
      _restartIfActive();
    });
    _ref.listen(sensitivityProvider, (prev, next) {
      _restartIfActive();
    });
  }

  bool get isActive => _pitchService != null;

  /// Tuner aktifse mikrofonu kesmeden ayarlari gunceller.
  Future<void> _restartIfActive() async {
    if (!isActive || _busy) return;
    _busy = true;
    try {
      final instrument = _ref.read(selectedInstrumentProvider);
      final refA4 = _ref.read(refA4Provider);
      final sens = _ref.read(sensitivityProvider);
      await _pitchService!.updateConfig(
        instrument: instrument,
        refA4: refA4,
        sensitivity: sens,
      );
    } catch (e) {
      debugPrint('Tuner updateConfig error: $e');
      _ref.read(tunerErrorProvider.notifier).state = e.toString();
    } finally {
      _busy = false;
    }
  }

  Future<void> start() async {
    if (isActive || _busy) return;
    _busy = true;

    _ref.read(tunerErrorProvider.notifier).state = null;

    final instrument = _ref.read(selectedInstrumentProvider);
    final refA4 = _ref.read(refA4Provider);

    final sens = _ref.read(sensitivityProvider);

    _pitchService = PitchService(
      instrument: instrument,
      refA4: refA4,
      sensitivity: sens,
    );

    _sessionStart = DateTime.now();
    _detectedCount = 0;
    _inTuneCount = 0;

    _subscription = _pitchService!.stateStream.listen((newState) {
      if (mounted) {
        // Oturum istatistikleri
        if (newState.status == TunerStatus.detected) {
          _detectedCount++;
          if (newState.isInTune) _inTuneCount++;
        }
        state = newState;
      }
    });

    try {
      await _pitchService!.start();
    } catch (e) {
      debugPrint('Tuner start error: $e');
      _ref.read(tunerErrorProvider.notifier).state = e.toString();
      await _cleanup();
    } finally {
      _busy = false;
    }
  }

  Future<void> stop() async {
    if (!isActive || _busy) return;
    _busy = true;
    try {
      await _cleanup();
    } finally {
      _busy = false;
    }
  }

  Future<void> _cleanup() async {
    // Oturumu kaydet (en az 3 saniye surmusse ve algılama yapilmissa)
    if (_sessionStart != null && _detectedCount > 0) {
      final now = DateTime.now();
      if (now.difference(_sessionStart!).inSeconds >= 3) {
        final instrument = _ref.read(selectedInstrumentProvider);
        final session = TuningSession(
          startTime: _sessionStart!,
          endTime: now,
          instrumentId: instrument.id,
          instrumentName: instrument.name,
          tuningName: instrument.tuningName,
          detectedCount: _detectedCount,
          inTuneCount: _inTuneCount,
        );
        try {
          await _ref.read(preferencesServiceProvider).addSession(session);
        } catch (e) {
          debugPrint('Session save error: $e');
        }
      }
    }
    _sessionStart = null;
    _detectedCount = 0;
    _inTuneCount = 0;

    await _subscription?.cancel();
    _subscription = null;
    await _pitchService?.dispose();
    _pitchService = null;
    if (mounted) state = TunerState.initial;
  }

  Future<void> toggle() async {
    if (isActive) {
      await stop();
    } else {
      await start();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _pitchService?.dispose();
    super.dispose();
  }
}
