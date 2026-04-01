import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.memorialBg,
      appBar: AppBar(
        backgroundColor: AppColors.memorialBg.withValues(alpha: 0.6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.memorialWarm),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Nağme',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.memorialText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Heart icon
            Icon(
              Icons.favorite,
              size: 48,
              color: AppColors.memorialWarm,
              shadows: [
                Shadow(
                  color: AppColors.memorialWarm.withValues(alpha: 0.4),
                  blurRadius: 8,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Divider line
            Container(
              width: 1,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.memorialWarm.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Main dedication text
            const Text(
              'Bu uygulama, Mehmet Akif Yıldız\'ın anısına geliştirilmiştir.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE9E1DD),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),

            // Divider
            Container(
              width: 32,
              height: 2,
              color: AppColors.memorialWarm.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 32),

            // Secondary text
            const Text(
              'Nağme, sadece bir akort aracı değil; onun ruhuna bırakılmış küçük bir hayrattır.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: AppColors.memorialMuted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 48),

            // Memorial placeholder
            AspectRatio(
              aspectRatio: 4 / 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B19),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.memorialWarm.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.music_note,
                      size: 64,
                      color: AppColors.memorialWarm.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Mehmet Akif Yıldız',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.memorialWarm.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '1965 – 2024',
                      style: TextStyle(
                        fontFamily: 'BeVietnamPro',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: AppColors.memorialMuted.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Quote card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF221F1D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF504535).withValues(alpha: 0.1),
                ),
              ),
              child: const Text(
                '"Sessizliğin içinde bile bir melodi vardır."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'BeVietnamPro',
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: AppColors.memorialMuted,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 64),

            // Footer info
            _buildInfoItem('GELİŞTİRİCİ', 'Ahmet'),
            const SizedBox(height: 24),
            _buildInfoItem('DURUM', 'Tamamen Ücretsiz'),
            const SizedBox(height: 24),
            _buildInfoItem('KULLANIM', 'Reklamsız / Çevrimdışı'),
            const SizedBox(height: 32),

            // Closing heart
            Icon(
              Icons.favorite,
              size: 18,
              color: AppColors.memorialWarm.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'BeVietnamPro',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: AppColors.memorialWarm.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'BeVietnamPro',
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: AppColors.memorialMuted,
          ),
        ),
      ],
    );
  }
}
