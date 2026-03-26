import 'package:go_router/go_router.dart';
import 'package:nagme/screens/tuner/tuner_screen.dart';
import 'package:nagme/screens/instruments/instrument_select_screen.dart';
import 'package:nagme/screens/settings/settings_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TunerScreen(),
    ),
    GoRoute(
      path: '/instruments',
      builder: (context, state) => const InstrumentSelectScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
