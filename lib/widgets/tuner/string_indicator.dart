import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/instrument.dart';

/// Enstrüman tellerini gösteren yatay gösterge.
///
/// Tıklama: tel bilgisi. Uzun basma: referans ton çalar.
class StringIndicator extends StatelessWidget {
  final InstrumentTuning instrument;
  final StringTuning? activeString;
  final ValueChanged<StringTuning>? onStringTap;
  final ValueChanged<StringTuning>? onStringLongPress;

  const StringIndicator({
    super.key,
    required this.instrument,
    this.activeString,
    this.onStringTap,
    this.onStringLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (instrument.isChromatic) return const SizedBox.shrink();

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.paddingLG),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: instrument.strings.map((string) {
          final isActive = activeString != null &&
              activeString!.name == string.name &&
              activeString!.octave == string.octave;

          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingXS),
            child: GestureDetector(
              onTap: () => onStringTap?.call(string),
              onLongPress: () => onStringLongPress?.call(string),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? AppColors.inTune.withValues(alpha: 0.15)
                      : AppColors.surfaceLight,
                  border: Border.all(
                    color: isActive
                        ? AppColors.inTune
                        : AppColors.surfaceBorder,
                    width: isActive ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    string.name,
                    style:
                        Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: isActive
                                  ? AppColors.inTune
                                  : AppColors.textSecondary,
                              fontWeight: isActive
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
