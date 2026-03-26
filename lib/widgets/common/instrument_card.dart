import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/instrument.dart';

/// Enstrüman seçim kartı.
class InstrumentCard extends StatelessWidget {
  final InstrumentTuning instrument;
  final bool isSelected;
  final VoidCallback onTap;

  const InstrumentCard({
    super.key,
    required this.instrument,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.inTune.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(
            color: isSelected ? AppColors.inTune : AppColors.surfaceBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Seçim tik işareti
            if (isSelected)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.inTune,
                  size: 20,
                ),
              ),

            // İçerik
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    instrument.icon,
                    style: const TextStyle(fontSize: 36),
                  ),
                  const SizedBox(height: AppConstants.paddingSM),
                  Text(
                    instrument.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? AppColors.inTune
                              : AppColors.textPrimary,
                        ),
                  ),
                  if (!instrument.isChromatic)
                    Text(
                      '${instrument.stringCount} tel',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
