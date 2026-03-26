import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/routes.dart';

class NagmeApp extends StatelessWidget {
  const NagmeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nağme',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
