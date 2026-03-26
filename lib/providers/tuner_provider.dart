import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/services/pitch_service.dart';
import 'package:nagme/providers/instrument_provider.dart';
import 'package:nagme/providers/settings_provider.dart';
import 'package:nagme/providers/sensitivity_provider.dart';

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

  TunerNotifier(this._ref) : super(TunerState.initial);

  bool get isActive => _pitchService != null;

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

    _subscription = _pitchService!.stateStream.listen((newState) {
      if (mounted) state = newState;
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
