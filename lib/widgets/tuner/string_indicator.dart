import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/providers/settings_provider.dart';
import 'package:nagme/providers/tone_provider.dart';
import 'package:nagme/providers/tuner_provider.dart';

class StringIndicator extends ConsumerWidget {
  const StringIndicator({
    super.key,
    required this.instrument,
    required this.closestString,
  });

  final InstrumentTuning instrument;
  final StringTuning? closestString;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (instrument.isChromatic) return const SizedBox.shrink();

    // Çift telli enstrümanlarda benzersiz frekansları göster
    final unique = <StringTuning>[];
    final seen = <double>{};
    for (final s in instrument.strings) {
      if (seen.add(s.frequency)) unique.add(s);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: unique.map((string) {
        final isActive = closestString?.frequency == string.frequency;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingS),
          child: _StringDot(
            string: string,
            isActive: isActive,
            onTap: () => _playTone(ref, string.frequency),
          ),
        );
      }).toList(),
    );
  }

  void _playTone(WidgetRef ref, double frequency) {
    // Tuner aktifken çalma — feedback loop önleme
    final isListening = ref.read(tunerProvider).isActive;
    if (isListening) return;

    // Ses kapalıysa çalma
    final toneEnabled = ref.read(toneEnabledProvider);
    if (!toneEnabled) return;

    ref.read(toneGeneratorProvider).playTone(frequency);
  }
}

class _StringDot extends StatelessWidget {
  const _StringDot({
    required this.string,
    required this.isActive,
    required this.onTap,
  });

  final StringTuning string;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? AppColors.primaryContainer.withValues(alpha: 0.20)
              : AppColors.surfaceContainerHighest,
          border: Border.all(
            color: isActive
                ? AppColors.primaryContainer
                : AppColors.surfaceContainerHighest,
            width: isActive ? 2 : 1.5,
          ),
          // Aktif tel için glow
          boxShadow: isActive
              ? [BoxShadow(
                  color: AppColors.primaryContainer.withValues(alpha: 0.35),
                  blurRadius: 12,
                  spreadRadius: 1,
                )]
              : [],
        ),
        child: Center(
          child: Text(
            string.noteName,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? AppColors.primaryContainer
                  : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
