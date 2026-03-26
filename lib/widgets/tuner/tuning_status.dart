import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/models/tuner_state.dart';

/// Tuner durumunu gösteren metin/ikon.
class TuningStatus extends StatelessWidget {
  final TunerState tunerState;

  const TuningStatus({super.key, required this.tunerState});

  @override
  Widget build(BuildContext context) {
    final (String text, Color color, IconData icon) = switch (tunerState.status) {
      TunerStatus.idle => ('Başlatmak için dokunun', AppColors.textMuted, Icons.mic_off),
      TunerStatus.listening => ('Dinleniyor...', AppColors.textSecondary, Icons.mic),
      TunerStatus.noSignal => ('Sinyal yok', AppColors.textMuted, Icons.mic),
      TunerStatus.lowConfidence => ('Enstrüman sesi bekleniyor...', AppColors.textMuted, Icons.hearing),
      TunerStatus.detected => tunerState.isInTune
          ? ('Akortlu!', AppColors.inTune, Icons.check_circle)
          : (tunerState.currentNote!.cents > 0 ? 'Yüksek ↑' : 'Düşük ↓',
              AppColors.sharp, Icons.tune),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
              ),
        ),
      ],
    );
  }
}
