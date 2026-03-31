import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nagme/config/constants.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences başlatılmadı. main() içinde override et.');
});

final referenceHzProvider = StateProvider<double>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getDouble(AppConstants.prefRefHz) ?? AppConstants.defaultRefHz;
});

final tuneThresholdProvider = StateProvider<int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getInt(AppConstants.prefTuneThreshold) ?? AppConstants.defaultTuneThreshold;
});

final noteNotationProvider = StateProvider<int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getInt(AppConstants.prefNoteNotation) ?? 0;
});

final toneEnabledProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool(AppConstants.prefToneEnabled) ?? true;
});

extension SettingsNotifierRef on Ref {
  void saveRefHz(double hz) {
    read(sharedPreferencesProvider).setDouble(AppConstants.prefRefHz, hz);
    read(referenceHzProvider.notifier).state = hz;
  }

  void saveTuneThreshold(int threshold) {
    read(sharedPreferencesProvider).setInt(AppConstants.prefTuneThreshold, threshold);
    read(tuneThresholdProvider.notifier).state = threshold;
  }

  void saveToneEnabled(bool enabled) {
    read(sharedPreferencesProvider).setBool(AppConstants.prefToneEnabled, enabled);
    read(toneEnabledProvider.notifier).state = enabled;
  }

  void saveNoteNotation(int notation) {
    read(sharedPreferencesProvider).setInt(AppConstants.prefNoteNotation, notation);
    read(noteNotationProvider.notifier).state = notation;
  }
}

extension SettingsNotifierWidgetRef on WidgetRef {
  void saveRefHz(double hz) {
    read(sharedPreferencesProvider).setDouble(AppConstants.prefRefHz, hz);
    read(referenceHzProvider.notifier).state = hz;
  }

  void saveTuneThreshold(int threshold) {
    read(sharedPreferencesProvider).setInt(AppConstants.prefTuneThreshold, threshold);
    read(tuneThresholdProvider.notifier).state = threshold;
  }

  void saveToneEnabled(bool enabled) {
    read(sharedPreferencesProvider).setBool(AppConstants.prefToneEnabled, enabled);
    read(toneEnabledProvider.notifier).state = enabled;
  }

  void saveNoteNotation(int notation) {
    read(sharedPreferencesProvider).setInt(AppConstants.prefNoteNotation, notation);
    read(noteNotationProvider.notifier).state = notation;
  }
}
