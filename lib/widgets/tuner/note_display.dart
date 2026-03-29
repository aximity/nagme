import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/providers/settings_provider.dart';
import 'package:nagme/utils/note_utils.dart';

/// Premium nota gösterimi — scale pulse + glow efekti.
class NoteDisplay extends ConsumerStatefulWidget {
  final TunerState tunerState;

  const NoteDisplay({super.key, required this.tunerState});

  @override
  ConsumerState<NoteDisplay> createState() => _NoteDisplayState();
}

class _NoteDisplayState extends ConsumerState<NoteDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  String? _lastNoteName;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void didUpdateWidget(covariant NoteDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newName = widget.tunerState.currentNote?.name;
    if (newName != null && newName != _lastNoteName) {
      _lastNoteName = newName;
      _pulseController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _displayName(String name) {
    final notation = ref.watch(notationProvider);
    return notation == 'turkish' ? noteNameTurkish(name) : name;
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.tunerState.currentNote;
    final isInTune = widget.tunerState.isInTune;

    if (note == null || widget.tunerState.status != TunerStatus.detected) {
      return Text(
        '—',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppColors.textMuted.withValues(alpha: 0.3),
            ),
      );
    }

    final Color noteColor =
        isInTune ? AppColors.inTune : AppColors.textPrimary;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + Curves.easeOut.transform(_pulseController.value) * 0.04 *
            (1.0 - _pulseController.value);

        return Transform.scale(
          scale: scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Glow efekti (akortluyken)
              if (isInTune)
                Text(
                  _displayName(note.name),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppColors.inTune.withValues(alpha: 0.15),
                        shadows: [
                          Shadow(
                            color: AppColors.inTune.withValues(alpha: 0.3),
                            blurRadius: 40,
                          ),
                        ],
                      ),
                ),
              if (isInTune)
                // Overlay nota üzerine
                Padding(
                  padding: EdgeInsets.only(
                    top: 0,
                  ),
                  child: _buildNote(context, note, noteColor),
                )
              else
                _buildNote(context, note, noteColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNote(BuildContext context, dynamic note, Color noteColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(
              milliseconds: AppConstants.noteTransitionDuration),
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: noteColor,
              ),
          child: Text(_displayName(note.name)),
        ),
        const SizedBox(height: 2),
        AnimatedDefaultTextStyle(
          duration: const Duration(
              milliseconds: AppConstants.noteTransitionDuration),
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: noteColor.withValues(alpha: 0.5),
                fontSize: 18,
              ),
          child: Text('${note.octave}'),
        ),
      ],
    );
  }
}
