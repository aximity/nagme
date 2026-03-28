import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/config/instruments.dart';
import 'package:nagme/main.dart';

/// Secili enstruman provider'i — SharedPreferences ile kalici.
final selectedInstrumentProvider =
    StateProvider<InstrumentTuning>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  final savedId = prefs.instrumentId;
  final savedTuning = prefs.tuningName;

  // Once standart listede ara
  final standard = defaultInstruments.firstWhere(
    (i) => i.id == savedId,
    orElse: () => defaultInstruments.first,
  );

  // Kayitli tuning standart degilse alternatiflerden bul
  if (savedTuning != 'Standart') {
    final alts = alternativeTunings[savedId];
    if (alts != null) {
      final match = alts.where((t) => t.tuningName == savedTuning);
      if (match.isNotEmpty) return match.first;
    }
  }

  return standard;
});

/// Tum enstruman listesi provider'i.
final instrumentListProvider = Provider<List<InstrumentTuning>>((ref) {
  return [chromaticMode, ...defaultInstruments];
});

/// Belirli bir enstruman icin mevcut akort duzenleri.
/// Standart + alternatifler dondurur.
List<InstrumentTuning> tuningsForInstrument(String instrumentId) {
  final standard = defaultInstruments.where((i) => i.id == instrumentId);
  if (standard.isEmpty) return [];

  final alts = alternativeTunings[instrumentId] ?? [];
  return [standard.first, ...alts];
}
