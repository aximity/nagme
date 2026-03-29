import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/screens/tuner/tuner_screen.dart';
import 'package:nagme/screens/instruments/instrument_select_screen.dart';
import 'package:nagme/screens/settings/settings_screen.dart';
import 'package:nagme/screens/about/about_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TunerScreen(),
    ),
    GoRoute(
      path: '/instruments',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const InstrumentSelectScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuint,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(
              opacity: curved,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(
            milliseconds: AppConstants.pageTransitionDuration),
        reverseTransitionDuration: const Duration(milliseconds: 250),
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuint,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.3, 0),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(
              opacity: curved,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(
            milliseconds: AppConstants.pageTransitionDuration),
        reverseTransitionDuration: const Duration(milliseconds: 250),
      ),
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const AboutScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuint,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.3, 0),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(
              opacity: curved,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(
            milliseconds: AppConstants.pageTransitionDuration),
        reverseTransitionDuration: const Duration(milliseconds: 250),
      ),
    ),
  ],
);
