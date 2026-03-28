// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Nağme';

  @override
  String get instrumentSelect => 'Enstrüman Seçimi';

  @override
  String get tuningPreset => 'Akort Düzeni';

  @override
  String get chromatic => 'Kromatik';

  @override
  String get standard => 'Standart';

  @override
  String strings(int count) {
    return '$count tel';
  }

  @override
  String get settings => 'Ayarlar';

  @override
  String get referenceFrequency => 'Referans Frekans';

  @override
  String get sensitivity => 'Hassasiyet';

  @override
  String get theme => 'Tema';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get language => 'Dil';

  @override
  String get toneGenerator => 'Ton Üretici';

  @override
  String get waveformSine => 'Sinüs';

  @override
  String get waveformWarm => 'Sıcak';

  @override
  String get waveformBright => 'Parlak';

  @override
  String get inTune => 'Akortlu';

  @override
  String get sharp => 'Tiz';

  @override
  String get flat => 'Pes';

  @override
  String get noSignal => 'Sinyal yok';

  @override
  String get listening => 'Dinleniyor...';

  @override
  String get lowConfidence => 'Zayıf sinyal';

  @override
  String get micPermissionDenied => 'Mikrofon izni verilmedi.';

  @override
  String get tuningHistory => 'Akort Geçmişi';

  @override
  String get sessionDuration => 'Süre';

  @override
  String get successRate => 'Başarı Oranı';
}
