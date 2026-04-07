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
    defaultValue: 442.0,
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

final referenceSoundProvider =
    StateNotifierProvider<_PersistentBool, bool>(
  (ref) => _PersistentBool(
    ref.watch(sharedPrefsProvider),
    key: 'referenceSound',
    defaultValue: true,
  ),
);

// --- Ses Tipi ---

final soundTypeProvider =
    StateNotifierProvider<_PersistentSoundType, SoundType>(
  (ref) => _PersistentSoundType(ref.watch(sharedPrefsProvider)),
);

// --- Hassasiyet Seviyesi ---

final detectionLevelProvider =
    StateNotifierProvider<_PersistentDetectionLevel, DetectionLevel>(
  (ref) => _PersistentDetectionLevel(ref.watch(sharedPrefsProvider)),
);

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

class _PersistentBool extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  final String key;

  _PersistentBool(this._prefs, {required this.key, required bool defaultValue})
      : super(_prefs.getBool(key) ?? defaultValue);

  set value(bool v) {
    state = v;
    _prefs.setBool(key, v);
  }
}

class _PersistentSoundType extends StateNotifier<SoundType> {
  final SharedPreferences _prefs;
  static const _key = 'soundType';

  _PersistentSoundType(this._prefs)
      : super(_fromString(_prefs.getString(_key)));

  static SoundType _fromString(String? s) {
    switch (s) {
      case 'square':
        return SoundType.square;
      case 'triangle':
        return SoundType.triangle;
      default:
        return SoundType.sine;
    }
  }

  set value(SoundType v) {
    state = v;
    _prefs.setString(_key, v.name);
  }
}

class _PersistentDetectionLevel extends StateNotifier<DetectionLevel> {
  final SharedPreferences _prefs;
  static const _key = 'detection_level';

  _PersistentDetectionLevel(this._prefs)
      : super(_fromString(_prefs.getString(_key)));

  static DetectionLevel _fromString(String? s) {
    switch (s) {
      case 'beginner':
        return DetectionLevel.beginner;
      case 'advanced':
        return DetectionLevel.advanced;
      default:
        return DetectionLevel.intermediate;
    }
  }

  set value(DetectionLevel v) {
    state = v;
    _prefs.setString(_key, v.name);
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
