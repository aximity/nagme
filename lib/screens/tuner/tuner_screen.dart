import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/providers/tuner_provider.dart';
import 'package:nagme/providers/instrument_provider.dart';
import 'package:nagme/widgets/tuner/note_display.dart';
import 'package:nagme/widgets/tuner/pitch_gauge.dart';
import 'package:nagme/widgets/tuner/needle_indicator.dart';
import 'package:nagme/widgets/tuner/tuning_status.dart';
import 'package:nagme/widgets/tuner/string_indicator.dart';
import 'package:nagme/widgets/tuner/waveform_painter.dart';
import 'package:nagme/services/audio_service.dart';

class TunerScreen extends ConsumerWidget {
  const TunerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tunerState = ref.watch(tunerProvider);
    final instrument = ref.watch(selectedInstrumentProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top app bar
          SafeArea(
            bottom: false,
            child: _TopBar(instrumentName: instrument.name),
          ),
          // Ana içerik
          Expanded(
            child: _TunerBody(state: tunerState),
          ),
        ],
      ),
      // Mic FAB
      floatingActionButton: _MicButton(
        isActive: tunerState.isActive,
        onTap: () => _toggleTuner(context, ref, tunerState),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // Bottom nav — Stitch tasarımına birebir
      bottomNavigationBar: const _BottomNav(),
    );
  }

  Future<void> _toggleTuner(
      BuildContext context, WidgetRef ref, TunerState state) async {
    final notifier = ref.read(tunerProvider.notifier);
    try {
      if (state.isActive) {
        await notifier.stop();
      } else {
        await notifier.start();
      }
    } on MicrophonePermissionDeniedException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Mikrofon izni gerekli. Ayarlardan izin verin.',
              style: GoogleFonts.manrope(),
            ),
            backgroundColor: AppColors.secondaryContainer,
          ),
        );
      }
    }
  }
}

// ─────────────────────────────────────────────
// Top Bar — "Nağme" amber + Keman chip + settings
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar({required this.instrumentName});
  final String instrumentName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingL,
        vertical: AppConstants.paddingM,
      ),
      child: Row(
        children: [
          // tune icon (Stitch'te sol üstte yer alıyor)
          const Icon(Icons.tune, color: AppColors.primaryContainer, size: 22),
          const SizedBox(width: 10),
          // Nağme — Epilogue, amber
          Text(
            'Nağme',
            style: GoogleFonts.epilogue(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryContainer,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          // Enstrüman chip
          GestureDetector(
            onTap: () => context.push('/instruments'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    instrumentName,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingS),
          // Settings icon
          GestureDetector(
            onTap: () => context.push('/settings'),
            child: const Icon(Icons.settings_outlined,
                color: AppColors.onSurfaceVariant, size: 22),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Ana tuner içerik alanı
// ─────────────────────────────────────────────
class _TunerBody extends ConsumerWidget {
  const _TunerBody({required this.state});
  final TunerState state;

  TuningStatusType _statusType() {
    if (!state.isActive) return TuningStatusType.idle;
    if (state.currentNote == null) return TuningStatusType.listening;
    if (state.isInTune) return TuningStatusType.inTune;
    return state.cents < 0 ? TuningStatusType.flat : TuningStatusType.sharp;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instrument = ref.watch(selectedInstrumentProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppConstants.paddingXl),

            // Nota + Hz
            NoteDisplay(note: state.currentNote, isInTune: state.isInTune),

            const SizedBox(height: AppConstants.paddingXxl),

            // Gauge + needle
            Stack(
              alignment: Alignment.center,
              children: [
                PitchGauge(
                  cents: state.cents,
                  isInTune: state.isInTune,
                  isActive: state.isActive,
                ),
                NeedleIndicator(
                  cents: state.cents,
                  isInTune: state.isInTune,
                  isActive: state.isActive && state.currentNote != null,
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingL),

            // Akort durumu badge
            TuningStatus(status: _statusType(), cents: state.cents),

            const SizedBox(height: AppConstants.paddingXxl),

            // Tel göstergesi
            StringIndicator(
              instrument: instrument,
              closestString: state.closestString,
            ),

            // Waveform (canlı audio buffer)
            const SizedBox(height: AppConstants.paddingL),
            WaveformWidget(isActive: state.isActive),

            // FAB + bottom nav için boşluk
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mic butonu (FAB)
// ─────────────────────────────────────────────
class _MicButton extends StatelessWidget {
  const _MicButton({required this.isActive, required this.onTap});
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animNormal,
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isActive
              ? const RadialGradient(
                  center: Alignment(-0.3, -0.3),
                  colors: [AppColors.primary, AppColors.primaryContainer],
                )
              : null,
          color: isActive ? null : AppColors.surfaceContainerHighest,
          boxShadow: isActive
              ? [BoxShadow(
                  color: AppColors.primaryContainer.withValues(alpha: 0.3),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                )]
              : [],
        ),
        child: Icon(
          isActive ? Icons.stop_rounded : Icons.mic,
          color: isActive ? AppColors.onPrimaryFixed : AppColors.onSurfaceVariant,
          size: 32,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom nav — TUNER / LIBRARY / METRONOME
// Stitch tasarımına birebir
// ─────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 32,
            offset: Offset(0, -12),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.paddingM,
            right: AppConstants.paddingM,
            top: AppConstants.paddingS,
            bottom: AppConstants.paddingM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Aktif: Tuner
              _NavItem(
                icon: Icons.vibration,
                label: 'AKORT',
                isActive: true,
              ),
              // Boş FAB slot
              const SizedBox(width: 80),
              // Library (henüz pasif)
              _NavItem(
                icon: Icons.library_music_outlined,
                label: 'ENSTRÜMAN',
                isActive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });
  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? AppColors.primaryContainer : AppColors.onSurface.withValues(alpha: 0.4);

    return AnimatedContainer(
      duration: AppConstants.animFast,
      padding: isActive
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.surfaceContainerHighest : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
