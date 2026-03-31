import 'package:shared_preferences/shared_preferences.dart';
import 'package:nagme/config/constants.dart';

class PreferencesService {
  const PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  double get refHz =>
      _prefs.getDouble(AppConstants.prefRefHz) ?? AppConstants.defaultRefHz;

  Future<void> setRefHz(double hz) =>
      _prefs.setDouble(AppConstants.prefRefHz, hz);

  int get tuneThreshold =>
      _prefs.getInt(AppConstants.prefTuneThreshold) ??
      AppConstants.defaultTuneThreshold;

  Future<void> setTuneThreshold(int t) =>
      _prefs.setInt(AppConstants.prefTuneThreshold, t);

  bool get toneEnabled =>
      _prefs.getBool(AppConstants.prefToneEnabled) ?? true;

  Future<void> setToneEnabled(bool v) =>
      _prefs.setBool(AppConstants.prefToneEnabled, v);

  String get noteNotation =>
      _prefs.getString(AppConstants.prefNoteNotation) ?? 'CDE';

  Future<void> setNoteNotation(String v) =>
      _prefs.setString(AppConstants.prefNoteNotation, v);
}
