// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nagme';

  @override
  String get instrumentSelect => 'Select Instrument';

  @override
  String get tuningPreset => 'Tuning Preset';

  @override
  String get chromatic => 'Chromatic';

  @override
  String get standard => 'Standard';

  @override
  String strings(int count) {
    return '$count strings';
  }

  @override
  String get settings => 'Settings';

  @override
  String get referenceFrequency => 'Reference Frequency';

  @override
  String get sensitivity => 'Sensitivity';

  @override
  String get theme => 'Theme';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get toneGenerator => 'Tone Generator';

  @override
  String get waveformSine => 'Sine';

  @override
  String get waveformWarm => 'Warm';

  @override
  String get waveformBright => 'Bright';

  @override
  String get inTune => 'In Tune';

  @override
  String get sharp => 'Sharp';

  @override
  String get flat => 'Flat';

  @override
  String get noSignal => 'No Signal';

  @override
  String get listening => 'Listening...';

  @override
  String get lowConfidence => 'Weak Signal';

  @override
  String get micPermissionDenied => 'Microphone permission denied.';

  @override
  String get tuningHistory => 'Tuning History';

  @override
  String get sessionDuration => 'Duration';

  @override
  String get successRate => 'Success Rate';
}
