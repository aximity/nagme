import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/utils/note_utils.dart';

/// Frekans (Hz) ve cent sapma gösterimi.
class FrequencyDisplay extends StatelessWidget {
  final TunerState tunerState;

  const FrequencyDisplay({super.key, required this.tunerState});

  @override
  Widget build(BuildContext context) {
    final note = tunerState.currentNote;
    final freq = tunerState.rawFrequency;

    if (note == null || freq == null) {
      return Text(
        '— Hz',
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.textMuted,
            ),
      );
    }

    final isInTune = tunerState.isInTune;
    final centsColor = isInTune ? AppColors.inTune : AppColors.sharp;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatFrequency(freq),
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 4),
        Text(
          formatCents(note.cents),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: centsColor,
              ),
        ),
      ],
    );
  }
}
