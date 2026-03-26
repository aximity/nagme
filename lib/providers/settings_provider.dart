import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagme/main.dart';

/// Referans A4 frekansı (Hz) provider'ı — SharedPreferences ile kalıcı.
final refA4Provider = StateNotifierProvider<RefA4Notifier, double>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return RefA4Notifier(prefs.refA4);
});

class RefA4Notifier extends StateNotifier<double> {
  RefA4Notifier(super.initial);
  void set(double value) => state = value;
}

/// Notasyon sistemi provider'ı.
final notationProvider = StateProvider<String>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return prefs.notation;
});

/// Hassasiyet eşiği (cent) provider'ı.
final tuneThresholdProvider = StateProvider<double>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return prefs.tuneThreshold;
});
