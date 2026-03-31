import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagme/config/instruments.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/providers/settings_provider.dart';

final selectedInstrumentProvider = StateProvider<InstrumentTuning>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final savedId = prefs.getString(AppConstants.prefSelectedInstrument);
  if (savedId != null) {
    final found = kInstruments.where((i) => i.id == savedId).firstOrNull;
    if (found != null) return found;
  }
  // Varsayılan: keman
  return kInstruments.firstWhere((i) => i.id == 'violin');
});

extension InstrumentNotifierRef on Ref {
  void selectInstrument(InstrumentTuning instrument) {
    read(sharedPreferencesProvider)
        .setString(AppConstants.prefSelectedInstrument, instrument.id);
    read(selectedInstrumentProvider.notifier).state = instrument;
  }
}

extension InstrumentNotifierWidgetRef on WidgetRef {
  void selectInstrument(InstrumentTuning instrument) {
    read(sharedPreferencesProvider)
        .setString(AppConstants.prefSelectedInstrument, instrument.id);
    read(selectedInstrumentProvider.notifier).state = instrument;
  }
}
