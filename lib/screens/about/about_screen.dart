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
        title: const Text('Hakkında'),
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
              'Nağme',
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
              title: 'Adanmış',
              body: 'Bu uygulama, vefat eden ağabeyimin anısına ve '
                  'hayrına yapılmıştır. Ruhu şad olsun.',
            ),

            const SizedBox(height: AppConstants.paddingMD),

            // Amac
            _AboutCard(
              icon: Icons.music_note_rounded,
              iconColor: AppColors.inTune,
              title: 'Amacı',
              body: 'Nağme, müzisyenlerin enstrümanlarını hızlı ve '
                  'doğru bir şekilde akort edebilmesi için tasarlanmış '
                  'profesyonel bir kromatik akort uygulamasıdır.\n\n'
                  'Keman, gitar, bağlama, ud, viyola, çello, bas gitar '
                  've ukulele dahil 8 enstrüman destekler. '
                  'Kromatik modda tüm notaları algılar.',
            ),

            const SizedBox(height: AppConstants.paddingMD),

            // Soze
            _AboutCard(
              icon: Icons.verified_rounded,
              iconColor: AppColors.flat,
              title: 'Sözümüz',
              body: 'Nağme sonsuza kadar:\n'
                  '• Tamamen ücretsizdir\n'
                  '• Reklam içermez\n'
                  '• İnternet gerektirmez\n'
                  '• Kişisel veri toplamaz',
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // Alt bilgi
            Text(
              'Türkiye\'de sevgiyle yapıldı',
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
