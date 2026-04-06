import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AppScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  DateTime? _lastBackPress;

  StatefulNavigationShell get navigationShell => widget.navigationShell;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // If not on the first tab, go back to tuner tab
        if (navigationShell.currentIndex != 0) {
          navigationShell.goBranch(0, initialLocation: true);
          return;
        }

        // Double-tap to exit
        final now = DateTime.now();
        if (_lastBackPress != null &&
            now.difference(_lastBackPress!) < const Duration(seconds: 2)) {
          SystemNavigator.pop();
          return;
        }
        _lastBackPress = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Çıkmak için tekrar basın'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColors.bgBase,
            border: Border(
              top: BorderSide(color: AppColors.bgElevated, width: 1),
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.tune_outlined,
                    selectedIcon: Icons.tune,
                    label: 'Akort',
                    isSelected: navigationShell.currentIndex == 0,
                    onTap: () => _onTap(0),
                  ),
                  _buildNavItem(
                    icon: Icons.straighten_outlined,
                    selectedIcon: Icons.straighten,
                    label: 'Enstrümanlar',
                    isSelected: navigationShell.currentIndex == 1,
                    onTap: () => _onTap(1),
                  ),
                  _buildNavItem(
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    label: 'Ayarlar',
                    isSelected: navigationShell.currentIndex == 2,
                    onTap: () => _onTap(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? AppColors.brandPrimary : AppColors.textMuted;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.bgSurface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
