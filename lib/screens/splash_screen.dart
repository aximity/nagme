import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/tuner');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Nağme',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: AppColors.brandPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'KROMATİK AKORT',
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
