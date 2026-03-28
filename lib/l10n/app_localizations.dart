import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nağme'**
  String get appTitle;

  /// No description provided for @instrumentSelect.
  ///
  /// In tr, this message translates to:
  /// **'Enstrüman Seçimi'**
  String get instrumentSelect;

  /// No description provided for @tuningPreset.
  ///
  /// In tr, this message translates to:
  /// **'Akort Düzeni'**
  String get tuningPreset;

  /// No description provided for @chromatic.
  ///
  /// In tr, this message translates to:
  /// **'Kromatik'**
  String get chromatic;

  /// No description provided for @standard.
  ///
  /// In tr, this message translates to:
  /// **'Standart'**
  String get standard;

  /// No description provided for @strings.
  ///
  /// In tr, this message translates to:
  /// **'{count} tel'**
  String strings(int count);

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @referenceFrequency.
  ///
  /// In tr, this message translates to:
  /// **'Referans Frekans'**
  String get referenceFrequency;

  /// No description provided for @sensitivity.
  ///
  /// In tr, this message translates to:
  /// **'Hassasiyet'**
  String get sensitivity;

  /// No description provided for @theme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @toneGenerator.
  ///
  /// In tr, this message translates to:
  /// **'Ton Üretici'**
  String get toneGenerator;

  /// No description provided for @waveformSine.
  ///
  /// In tr, this message translates to:
  /// **'Sinüs'**
  String get waveformSine;

  /// No description provided for @waveformWarm.
  ///
  /// In tr, this message translates to:
  /// **'Sıcak'**
  String get waveformWarm;

  /// No description provided for @waveformBright.
  ///
  /// In tr, this message translates to:
  /// **'Parlak'**
  String get waveformBright;

  /// No description provided for @inTune.
  ///
  /// In tr, this message translates to:
  /// **'Akortlu'**
  String get inTune;

  /// No description provided for @sharp.
  ///
  /// In tr, this message translates to:
  /// **'Tiz'**
  String get sharp;

  /// No description provided for @flat.
  ///
  /// In tr, this message translates to:
  /// **'Pes'**
  String get flat;

  /// No description provided for @noSignal.
  ///
  /// In tr, this message translates to:
  /// **'Sinyal yok'**
  String get noSignal;

  /// No description provided for @listening.
  ///
  /// In tr, this message translates to:
  /// **'Dinleniyor...'**
  String get listening;

  /// No description provided for @lowConfidence.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf sinyal'**
  String get lowConfidence;

  /// No description provided for @micPermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Mikrofon izni verilmedi.'**
  String get micPermissionDenied;

  /// No description provided for @tuningHistory.
  ///
  /// In tr, this message translates to:
  /// **'Akort Geçmişi'**
  String get tuningHistory;

  /// No description provided for @sessionDuration.
  ///
  /// In tr, this message translates to:
  /// **'Süre'**
  String get sessionDuration;

  /// No description provided for @successRate.
  ///
  /// In tr, this message translates to:
  /// **'Başarı Oranı'**
  String get successRate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
