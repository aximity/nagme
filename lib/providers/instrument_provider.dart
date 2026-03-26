import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/config/instruments.dart';
import 'package:nagme/main.dart';

/// Seçili enstrüman provider'ı — SharedPreferences ile kalıcı.
final selectedInstrumentProvider =
    StateProvider<InstrumentTuning>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  final savedId = prefs.instrumentId;
  return defaultInstruments.firstWhere(
    (i) => i.id == savedId,
    orElse: () => defaultInstruments.first,
  );
});

/// Tüm enstrüman listesi provider'ı.
final instrumentListProvider = Provider<List<InstrumentTuning>>((ref) {
  return [chromaticMode, ...defaultInstruments];
});
