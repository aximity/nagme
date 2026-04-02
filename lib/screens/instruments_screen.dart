import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../models/instrument.dart';
import '../providers/instrument_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class InstrumentsScreen extends ConsumerWidget {
  const InstrumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedInstrumentProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => context.go('/tuner'),
        ),
        title: Text('Enstrüman Seç', style: AppTypography.heading2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: Instruments.all.length,
              itemBuilder: (context, index) {
                final instrument = Instruments.all[index];
                final isSelected = instrument.id == selected.id;
                return _buildInstrumentCard(
                  context,
                  ref,
                  instrument,
                  isSelected,
                );
              },
            ),
            const SizedBox(height: 24),
            _buildInfoCard(selected),
          ],
        ),
      ),
    );
  }

  String _stringCount(Instrument instrument) {
    if (instrument.id == 'chromatic') return 'Serbest Mod';
    final totalStrings = instrument.strings.length;
    final uniqueNotes = instrument.strings.map((s) => s.name).toSet().length;
    if (totalStrings == uniqueNotes) {
      return '$totalStrings tel';
    }
    return '$totalStrings tel · $uniqueNotes akort';
  }

  Widget _buildInstrumentCard(
    BuildContext context,
    WidgetRef ref,
    Instrument instrument,
    bool isSelected,
  ) {
    final iconColor = isSelected ? AppColors.brandPrimary : AppColors.textMuted;

    return GestureDetector(
      onTap: () {
        ref.read(selectedInstrumentProvider.notifier).state = instrument;
        context.go('/tuner');
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.brandPrimary : AppColors.bgElevated,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brandPrimary.withValues(alpha: 0.2),
                    blurRadius: 15,
                  )
                ]
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    instrument.iconAsset,
                    width: 28,
                    height: 28,
                    colorFilter: ColorFilter.mode(
                      iconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    instrument.name,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.brandPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _stringCount(instrument),
                    style: TextStyle(
                      fontFamily: 'BeVietnamPro',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.brandPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.statusInTune,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Instrument selected) {
    final rangeText = selected.minFrequency != null
        ? '${selected.minFrequency!.round()} – ${selected.maxFrequency!.round()} Hz aralığında optimize edilmiştir'
        : 'Tüm frekans aralığı aktif';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2D2C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.brandDim.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.info_outline,
              color: AppColors.brandPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Akort Yardımcısı',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Seçtiğiniz enstrümanın tel yapısına uygun hassas frekans analizi yapılır. Her enstrüman için özel optimize edilmiş algoritmalar kullanılır.',
                  style: TextStyle(
                    fontFamily: 'BeVietnamPro',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  rangeText,
                  style: const TextStyle(
                    fontFamily: 'BeVietnamPro',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
