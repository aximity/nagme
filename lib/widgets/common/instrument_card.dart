import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/instrument.dart';

class InstrumentCard extends StatelessWidget {
  const InstrumentCard({
    super.key,
    required this.instrument,
    required this.isSelected,
    required this.onTap,
  });

  final InstrumentTuning instrument;
  final bool isSelected;
  final VoidCallback onTap;

  // Stitch'teki Material Symbols ikonlarına karşılık gelen Flutter ikonları
  static IconData _iconFor(String id) {
    return switch (id) {
      'violin'    => Icons.music_note,
      'guitar'    => Icons.queue_music,
      'bass'      => Icons.speaker,
      'ukulele'   => Icons.waves,
      'baglama'   => Icons.grid_4x4,
      'oud'       => Icons.blur_on,
      'viola'     => Icons.graphic_eq,
      'cello'     => Icons.music_note_outlined,
      'chromatic' => Icons.blur_circular,
      _           => Icons.music_note,
    };
  }

  String _tuningLabel() {
    if (instrument.isChromatic) return 'A–G# / 440Hz';
    final unique = <StringTuning>[];
    final seen = <double>{};
    for (final s in instrument.strings) {
      if (seen.add(s.frequency)) unique.add(s);
    }
    return unique.map((s) => s.noteName).join(' ');
  }

  String _telLabel() {
    if (instrument.isChromatic) return 'Tümü';
    return '${instrument.strings.length} tel';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        padding: const EdgeInsets.all(AppConstants.paddingM + 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          // Seçili: amber ring — değil: hafif border
          border: isSelected
              ? Border.all(color: AppColors.primaryContainer, width: 2)
              : Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.15),
                  width: 1,
                ),
          boxShadow: isSelected
              ? [BoxShadow(
                  color: AppColors.primaryContainer.withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: 0,
                )]
              : [],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // İkon container
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingS + 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: Icon(
                    _iconFor(instrument.id),
                    color: isSelected
                        ? AppColors.primaryContainer
                        : AppColors.tertiary,
                    size: 28,
                  ),
                ),

                const SizedBox(height: AppConstants.paddingM),

                // Enstrüman adı
                Text(
                  instrument.name,
                  style: GoogleFonts.epilogue(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.tertiaryFixed,
                  ),
                ),

                const SizedBox(height: 6),

                // Tel sayısı badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.onPrimary.withValues(alpha: 0.2)
                        : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  ),
                  child: Text(
                    _telLabel(),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Akort gösterimi
                Text(
                  _tuningLabel(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            // Seçili checkmark
            if (isSelected)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.primaryContainer,
                  size: 22,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
