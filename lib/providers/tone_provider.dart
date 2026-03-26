import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagme/services/tone_generator.dart';

/// Ton üretici provider'ı.
final toneGeneratorProvider = Provider<ToneGenerator>((ref) {
  final generator = ToneGenerator();
  ref.onDispose(generator.dispose);
  return generator;
});
