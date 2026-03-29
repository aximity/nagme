import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/providers/settings_provider.dart';
import 'package:nagme/config/temperaments.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refA4 = ref.watch(refA4Provider);
    final notation = ref.watch(notationProvider);
    final threshold = ref.watch(tuneThresholdProvider);
    final temperament = ref.watch(temperamentProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ayarlar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMD),
        children: [
          // Referans frekansı
          _SectionTitle(title: 'Referans Frekansı'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMD),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('A4 = ${refA4.toStringAsFixed(0)} Hz',
                          style: Theme.of(context).textTheme.titleMedium),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _QuickButton(
                            label: '432',
                            isActive: refA4 == 432.0,
                            onTap: () => ref
                                .read(refA4Provider.notifier)
                                .set(432.0),
                          ),
                          const SizedBox(width: 8),
                          _QuickButton(
                            label: '440',
                            isActive: refA4 == 440.0,
                            onTap: () => ref
                                .read(refA4Provider.notifier)
                                .set(440.0),
                          ),
                          const SizedBox(width: 8),
                          _QuickButton(
                            label: '442',
                            isActive: refA4 == 442.0,
                            onTap: () => ref
                                .read(refA4Provider.notifier)
                                .set(442.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Slider(
                    value: refA4,
                    min: AppConstants.minRefHz,
                    max: AppConstants.maxRefHz,
                    divisions: ((AppConstants.maxRefHz - AppConstants.minRefHz))
                        .toInt(),
                    activeColor: AppColors.inTune,
                    inactiveColor: AppColors.gaugeTrack,
                    onChanged: (value) =>
                        ref.read(refA4Provider.notifier).set(value),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingMD),

          // Hassasiyet
          _SectionTitle(title: 'Hassasiyet'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Akort eşiği: ±${threshold.toStringAsFixed(0)} cent',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    value: threshold,
                    min: 2.0,
                    max: 10.0,
                    divisions: 8,
                    activeColor: AppColors.inTune,
                    inactiveColor: AppColors.gaugeTrack,
                    onChanged: (value) =>
                        ref.read(tuneThresholdProvider.notifier).state =
                            value,
                  ),
                  Text(
                    'Profesyonel: 3 · Standart: 5 · Başlangıç: 8',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingMD),

          // Temperament
          _SectionTitle(title: 'Akort Sistemi'),
          Card(
            child: RadioGroup<Temperament>(
              groupValue: temperament,
              onChanged: (value) {
                if (value != null) {
                  ref.read(temperamentProvider.notifier).state = value;
                }
              },
              child: Column(
                children: [
                  RadioListTile<Temperament>(
                    title: const Text('Pisagor (Saf Beşli)'),
                    subtitle: const Text('Keman, viyola, çello için önerilen'),
                    value: Temperament.pythagorean,
                    activeColor: AppColors.inTune,
                  ),
                  RadioListTile<Temperament>(
                    title: const Text('Eşit Temperament (12-TET)'),
                    subtitle: const Text('Gitar, piyano, fretli enstrümanlar'),
                    value: Temperament.equal,
                    activeColor: AppColors.inTune,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingMD),

          // Notasyon
          _SectionTitle(title: 'Nota Gösterimi'),
          Card(
            child: RadioGroup<String>(
              groupValue: notation,
              onChanged: (value) {
                if (value != null) {
                  ref.read(notationProvider.notifier).state = value;
                }
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Uluslararası (C, D, E, F...)'),
                    value: 'international',
                    activeColor: AppColors.inTune,
                  ),
                  RadioListTile<String>(
                    title: const Text('Türkçe (Do, Re, Mi, Fa...)'),
                    value: 'turkish',
                    activeColor: AppColors.inTune,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingMD),

          // Hakkında
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline_rounded,
                  color: AppColors.textMuted),
              title: const Text('Hakkında'),
              subtitle: Text('Nağme v0.1.0',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textMuted)),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted),
              onTap: () => context.push('/about'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.paddingXS,
        bottom: AppConstants.paddingSM,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.inTune,
            ),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _QuickButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusSM),
          color: isActive
              ? AppColors.inTune.withValues(alpha: 0.15)
              : AppColors.surfaceLight,
          border: Border.all(
            color: isActive ? AppColors.inTune : AppColors.surfaceBorder,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isActive ? AppColors.inTune : AppColors.textSecondary,
              ),
        ),
      ),
    );
  }
}
