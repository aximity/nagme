import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tuner_state.dart';

final tunerStateProvider = StateProvider<TunerState>((ref) {
  return const TunerState();
});

final isListeningProvider = StateProvider<bool>((ref) => false);
