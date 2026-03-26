import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/tuner_state.dart';

/// Büyük nota harfi gösterimi (A, B, C#...) + oktav numarası.
class NoteDisplay extends StatelessWidget {
  final TunerState tunerState;

  const NoteDisplay({super.key, required this.tunerState});

  @override
  Widget build(BuildContext context) {
    final note = tunerState.currentNote;
    final isInTune = tunerState.isInTune;

    if (note == null || tunerState.status != TunerStatus.detected) {
      return Text(
        '—',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppColors.textMuted,
            ),
      );
    }

    final Color noteColor =
        isInTune ? AppColors.inTune : AppColors.textPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(
              milliseconds: AppConstants.noteTransitionDuration),
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: noteColor,
              ),
          child: Text(note.name),
        ),
        Text(
          '${note.octave}',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: noteColor.withValues(alpha: 0.7),
              ),
        ),
      ],
    );
  }
}
