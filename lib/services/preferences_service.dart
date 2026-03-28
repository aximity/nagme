import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences wrapper — kullanıcı tercihlerini kalıcı depolar.
class PreferencesService {
  static const _keyRefA4 = 'refA4';
  static const _keyInstrumentId = 'instrumentId';
  static const _keyTuningName = 'tuningName';
  static const _keyNotation = 'notation';
  static const _keyTuneThreshold = 'tuneThreshold';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  // Referans A4
  double get refA4 => _prefs.getDouble(_keyRefA4) ?? 440.0;
  Future<void> setRefA4(double value) => _prefs.setDouble(_keyRefA4, value);

  // Seçili enstrüman
  String get instrumentId => _prefs.getString(_keyInstrumentId) ?? 'violin';
  Future<void> setInstrumentId(String id) =>
      _prefs.setString(_keyInstrumentId, id);

  // Seçili akort düzeni
  String get tuningName => _prefs.getString(_keyTuningName) ?? 'Standart';
  Future<void> setTuningName(String name) =>
      _prefs.setString(_keyTuningName, name);

  // Notasyon
  String get notation => _prefs.getString(_keyNotation) ?? 'international';
  Future<void> setNotation(String value) =>
      _prefs.setString(_keyNotation, value);

  // Hassasiyet eşiği
  double get tuneThreshold => _prefs.getDouble(_keyTuneThreshold) ?? 5.0;
  Future<void> setTuneThreshold(double value) =>
      _prefs.setDouble(_keyTuneThreshold, value);
}
