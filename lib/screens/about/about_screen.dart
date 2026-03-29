import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hakkinda'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLG),
        child: Column(
          children: [
            const SizedBox(height: AppConstants.paddingXL),

            // App icon
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
              child: Image.asset(
                'assets/icon/app_icon.png',
                width: 96,
                height: 96,
              ),
            ),

            const SizedBox(height: AppConstants.paddingMD),

            Text(
              'Nagme',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),

            const SizedBox(height: AppConstants.paddingXS),

            Text(
              'v0.1.0',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // Adanmis
            _AboutCard(
              icon: Icons.favorite_rounded,
              iconColor: AppColors.sharp,
              title: 'Adanmis',
              body: 'Bu uygulama, vefat eden agabeyimin anisina ve '
                  'hayrina yapilmistir. Ruhu sad olsun.',
            ),

            const SizedBox(height: AppConstants.paddingMD),

            // Amac
            _AboutCard(
              icon: Icons.music_note_rounded,
              iconColor: AppColors.inTune,
              title: 'Amaci',
              body: 'Nagme, muzisyenlerin enstrumanlarini hizli ve '
                  'dogru bir sekilde akort edebilmesi icin tasarlanmis '
                  'profesyonel bir kromatik tuner uygulamasidir.\n\n'
                  'Keman, gitar, baglama, ud, viyola, cello, bas gitar '
                  've ukulele dahil 8 enstruman destekler. '
                  'Kromatik modda tum notalari algilar.',
            ),

            const SizedBox(height: AppConstants.paddingMD),

            // Soze
            _AboutCard(
              icon: Icons.verified_rounded,
              iconColor: AppColors.flat,
              title: 'Sozumuz',
              body: 'Nagme sonsuza kadar:\n'
                  '• Tamamen ucretsizdir\n'
                  '• Reklam icermez\n'
                  '• Internet gerektirmez\n'
                  '• Kisisel veri toplamaz',
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // Alt bilgi
            Text(
              'Turkiye\'de sevgiyle yapildi',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),

            const SizedBox(height: AppConstants.paddingXL),
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  const _AboutCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: AppConstants.paddingSM),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSM),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
