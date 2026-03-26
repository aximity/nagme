import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nagme/app.dart';
import 'package:nagme/services/preferences_service.dart';

/// SharedPreferences provider — uygulama başlangıcında initialize edilir.
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError('Must be overridden at startup');
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Portre modunda kilitle (tuner uygulaması)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Status bar stili
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final prefsService = PreferencesService(prefs);

  runApp(
    ProviderScope(
      overrides: [
        preferencesServiceProvider.overrideWithValue(prefsService),
      ],
      child: const NagmeApp(),
    ),
  );
}
