import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/utils/note_utils.dart';

/// Frekans (Hz) ve cent sapma gösterimi — premium stil.
class FrequencyDisplay extends StatelessWidget {
  final TunerState tunerState;

  const FrequencyDisplay({super.key, required this.tunerState});

  @override
  Widget build(BuildContext context) {
    final note = tunerState.currentNote;
    final freq = tunerState.rawFrequency;

    if (note == null || freq == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '— Hz',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                ),
          ),
        ],
      );
    }

    final isInTune = tunerState.isInTune;
    final centsColor = isInTune
        ? AppColors.inTune
        : (note.cents > 0 ? AppColors.sharp : AppColors.flat);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatFrequency(freq),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                fontSize: 24,
              ),
        ),
        const SizedBox(height: 4),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: AppConstants.noteTransitionDuration),
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: centsColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
          child: Text(formatCents(note.cents)),
        ),
      ],
    );
  }
}
