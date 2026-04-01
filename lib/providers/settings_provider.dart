import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tuner_state.dart';

// SharedPreferences instance — main.dart'ta override edilir
final sharedPrefsProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('SharedPreferences not initialized'),
);

// --- Referans Frekansı ---

final referenceFreqProvider =
    StateNotifierProvider<_PersistentDouble, double>(
  (ref) => _PersistentDouble(
    ref.watch(sharedPrefsProvider),
    key: 'referenceFreq',
    defaultValue: 440.0,
  ),
);

// --- Akort Eşiği ---

final tuningThresholdProvider =
    StateNotifierProvider<_PersistentInt, int>(
  (ref) => _PersistentInt(
    ref.watch(sharedPrefsProvider),
    key: 'tuningThreshold',
    defaultValue: 5,
  ),
);

// --- Nota Gösterimi ---

final noteNotationProvider =
    StateNotifierProvider<_PersistentNotation, NoteNotation>(
  (ref) => _PersistentNotation(ref.watch(sharedPrefsProvider)),
);

// --- Referans Sesi ---

final referenceSoundProvider = StateProvider<bool>((ref) => true);

// --- Ses Tipi ---

final soundTypeProvider = StateProvider<SoundType>((ref) => SoundType.sine);

// ---------------------------------------------------------------------------
// Persistent StateNotifier'lar
// ---------------------------------------------------------------------------

class _PersistentDouble extends StateNotifier<double> {
  final SharedPreferences _prefs;
  final String key;

  _PersistentDouble(this._prefs, {required this.key, required double defaultValue})
      : super(_prefs.getDouble(key) ?? defaultValue);

  set value(double v) {
    state = v;
    _prefs.setDouble(key, v);
  }
}

class _PersistentInt extends StateNotifier<int> {
  final SharedPreferences _prefs;
  final String key;

  _PersistentInt(this._prefs, {required this.key, required int defaultValue})
      : super(_prefs.getInt(key) ?? defaultValue);

  set value(int v) {
    state = v;
    _prefs.setInt(key, v);
  }
}

class _PersistentNotation extends StateNotifier<NoteNotation> {
  final SharedPreferences _prefs;
  static const _key = 'noteNotation';

  _PersistentNotation(this._prefs)
      : super(
          _prefs.getString(_key) == 'solfege'
              ? NoteNotation.solfege
              : NoteNotation.letter,
        );

  set value(NoteNotation v) {
    state = v;
    _prefs.setString(_key, v == NoteNotation.solfege ? 'solfege' : 'letter');
  }
}
