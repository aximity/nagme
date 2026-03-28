import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/tuner_state.dart';

/// Premium tuning status — animasyonlu geçiş.
class TuningStatus extends StatelessWidget {
  final TunerState tunerState;

  const TuningStatus({super.key, required this.tunerState});

  @override
  Widget build(BuildContext context) {
    final (String text, Color color, IconData icon) =
        switch (tunerState.status) {
      TunerStatus.idle => (
          'Başlatmak için dokunun',
          AppColors.textMuted,
          Icons.mic_off_rounded
        ),
      TunerStatus.listening => (
          'Dinleniyor...',
          AppColors.textSecondary,
          Icons.graphic_eq_rounded
        ),
      TunerStatus.noSignal => (
          'Sinyal yok',
          AppColors.textMuted,
          Icons.graphic_eq_rounded
        ),
      TunerStatus.lowConfidence => (
          'Enstrüman sesi bekleniyor...',
          AppColors.textMuted,
          Icons.hearing_rounded
        ),
      TunerStatus.detected => tunerState.isInTune
          ? ('Akortlu!', AppColors.inTune, Icons.check_circle_rounded)
          : (
              tunerState.currentNote!.cents > 0 ? 'Yüksek ↑' : 'Düşük ↓',
              tunerState.currentNote!.cents > 0
                  ? AppColors.sharp
                  : AppColors.flat,
              Icons.tune_rounded
            ),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: AppConstants.noteTransitionDuration),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Container(
        key: ValueKey('$text$color'),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMD,
          vertical: AppConstants.paddingSM,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: color,
                      letterSpacing: 0.3,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
