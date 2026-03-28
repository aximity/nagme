import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/main.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/providers/instrument_provider.dart';
import 'package:nagme/widgets/common/instrument_card.dart';

class InstrumentSelectScreen extends ConsumerWidget {
  const InstrumentSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instruments = ref.watch(instrumentListProvider);
    final selected = ref.watch(selectedInstrumentProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Enstrüman Seçimi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMD),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppConstants.paddingMD,
            crossAxisSpacing: AppConstants.paddingMD,
            childAspectRatio: 1.2,
          ),
          itemCount: instruments.length,
          itemBuilder: (context, index) {
            final instrument = instruments[index];
            final isSelected = instrument.id == selected.id;

            return InstrumentCard(
              instrument: instrument,
              isSelected: isSelected,
              onTap: () {
                final tunings = tuningsForInstrument(instrument.id);
                if (tunings.length > 1) {
                  // Birden fazla akort duzeni var — alt menu goster
                  _showTuningPicker(context, ref, tunings, selected);
                } else {
                  // Tek duzeni var (veya kromatik) — direkt sec
                  _selectInstrument(ref, instrument);
                  context.pop();
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _showTuningPicker(
    BuildContext context,
    WidgetRef ref,
    List<InstrumentTuning> tunings,
    InstrumentTuning selected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      builder: (context) => _TuningPickerSheet(
        tunings: tunings,
        selected: selected,
        onSelect: (tuning) {
          _selectInstrument(ref, tuning);
          Navigator.of(context).pop(); // bottom sheet kapat
          context.pop(); // instrument screen kapat
        },
      ),
    );
  }

  void _selectInstrument(WidgetRef ref, InstrumentTuning instrument) {
    ref.read(selectedInstrumentProvider.notifier).state = instrument;
    final prefs = ref.read(preferencesServiceProvider);
    prefs.setInstrumentId(instrument.id);
    prefs.setTuningName(instrument.tuningName);
  }
}

class _TuningPickerSheet extends StatelessWidget {
  final List<InstrumentTuning> tunings;
  final InstrumentTuning selected;
  final ValueChanged<InstrumentTuning> onSelect;

  const _TuningPickerSheet({
    required this.tunings,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final instrument = tunings.first;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMD,
        vertical: AppConstants.paddingLG,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baslik
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMD),
          Text(
            '${instrument.name} — Akort Düzeni',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppConstants.paddingMD),

          // Tuning listesi
          ...tunings.map((tuning) {
            final isActive = selected.id == tuning.id &&
                selected.tuningName == tuning.tuningName;
            return _TuningTile(
              tuning: tuning,
              isActive: isActive,
              onTap: () {
                HapticFeedback.lightImpact();
                onSelect(tuning);
              },
            );
          }),

          const SizedBox(height: AppConstants.paddingSM),
        ],
      ),
    );
  }
}

class _TuningTile extends StatelessWidget {
  final InstrumentTuning tuning;
  final bool isActive;
  final VoidCallback onTap;

  const _TuningTile({
    required this.tuning,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final stringNames = tuning.strings.map((s) => s.fullName).join(' ');

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMD,
            vertical: AppConstants.paddingSM + 4,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.inTune.withValues(alpha: 0.08)
                : AppColors.surfaceLight.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            border: Border.all(
              color: isActive
                  ? AppColors.inTune.withValues(alpha: 0.4)
                  : AppColors.surfaceBorder.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tuning.tuningName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isActive
                                ? AppColors.inTune
                                : AppColors.textPrimary,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stringNames,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                            fontFamily: 'JetBrains Mono',
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.inTune,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
