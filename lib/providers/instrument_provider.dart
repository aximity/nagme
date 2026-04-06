import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/instrument.dart';
import 'settings_provider.dart';

final selectedInstrumentProvider =
    StateNotifierProvider<_PersistentInstrument, Instrument>(
  (ref) => _PersistentInstrument(ref.watch(sharedPrefsProvider)),
);

class _PersistentInstrument extends StateNotifier<Instrument> {
  final SharedPreferences _prefs;
  static const _key = 'selectedInstrumentId';

  _PersistentInstrument(this._prefs)
      : super(
          Instruments.all.firstWhere(
            (i) => i.id == _prefs.getString(_key),
            orElse: () => Instruments.violin,
          ),
        );

  set value(Instrument v) {
    state = v;
    _prefs.setString(_key, v.id);
  }
}
