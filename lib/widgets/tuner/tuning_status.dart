import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';

enum TuningStatusType { inTune, flat, sharp, listening, idle }

class TuningStatus extends StatelessWidget {
  const TuningStatus({super.key, required this.status, required this.cents});

  final TuningStatusType status;
  final double cents;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      TuningStatusType.inTune    => ('✓  AKORTLU', AppColors.primaryContainer),
      TuningStatusType.flat      => ('♭  BEMOL',   AppColors.secondary),
      TuningStatusType.sharp     => ('♯  DİYEZ',   AppColors.secondary),
      TuningStatusType.listening => ('DİNLİYOR...', AppColors.onSurfaceVariant),
      TuningStatusType.idle      => ('BAŞLAT',      AppColors.surfaceContainerHighest),
    };

    return AnimatedSwitcher(
      duration: AppConstants.animFast,
      child: Container(
        key: ValueKey(status),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingM,
          vertical: AppConstants.paddingXs + 2,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}
