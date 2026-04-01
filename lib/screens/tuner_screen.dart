import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/instrument.dart';
import '../models/tuner_state.dart';
import '../providers/instrument_provider.dart';
import '../providers/tuner_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/waveform_painter.dart';
import '../widgets/pitch_bar.dart';
import '../widgets/mic_permission_dialog.dart';

class TunerScreen extends ConsumerWidget {
  const TunerScreen({super.key});

  Color _statusColor(TunerStatus status) {
    switch (status) {
      case TunerStatus.idle:
        return AppColors.textMuted;
      case TunerStatus.flat:
        return AppColors.statusFlat;
      case TunerStatus.sharp:
        return AppColors.statusSharp;
      case TunerStatus.inTune:
        return AppColors.statusInTune;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instrument = ref.watch(selectedInstrumentProvider);
    final tunerState = ref.watch(tunerStateProvider);
    final isListening = ref.watch(isListeningProvider);
    final isChromatic = instrument.id == 'chromatic';
    final color = _statusColor(tunerState.status);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase,
        centerTitle: true,
        title: const Text(
          'Nağme',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.brandPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                children: [
                  _buildWaveformHero(tunerState, color),
                  const SizedBox(height: 32),
                  _buildNoteDisplay(tunerState, color),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: PitchBar(
                      cents: tunerState.cents,
                      indicatorColor: color,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (!isChromatic) _buildStringSelector(instrument),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: _buildMicFab(context, ref, isListening),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveformHero(TunerState state, Color color) {
    final isIdle = state.status == TunerStatus.idle;

    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, 240),
            painter: GridPainter(color: AppColors.brandDim),
          ),
          Center(
            child: SizedBox(
              height: 128,
              child: CustomPaint(
                size: const Size(double.infinity, 128),
                painter: WaveformPainter(
                  color: isIdle
                      ? AppColors.brandPrimary.withValues(alpha: 0.2)
                      : color.withValues(alpha: 0.8),
                  amplitude: isIdle ? 0.05 : 0.35,
                  showDashed: state.status == TunerStatus.flat,
                  dashedColor: color,
                ),
              ),
            ),
          ),
          if (isIdle)
            const Center(
              child: Text(
                'Dinleniyor...',
                style: TextStyle(
                  fontFamily: 'BeVietnamPro',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  letterSpacing: 3,
                ),
              ),
            ),
          // Flat/Sharp symbols
          Positioned(
            left: 16,
            top: 16,
            child: Text('♭',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: state.status == TunerStatus.flat
                      ? AppColors.statusFlat
                      : AppColors.textMuted.withValues(alpha: 0.2),
                )),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Text('♯',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: state.status == TunerStatus.sharp
                      ? AppColors.statusSharp
                      : AppColors.textMuted.withValues(alpha: 0.2),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteDisplay(TunerState state, Color color) {
    final isIdle = state.status == TunerStatus.idle;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              state.noteDisplay,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: isIdle ? AppColors.textSecondary : color,
                height: 1,
              ),
            ),
            if (state.status == TunerStatus.flat)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('♭',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: color,
                    )),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.frequencyDisplay, style: AppTypography.cent),
            const SizedBox(width: 16),
            Text(
              state.centsDisplay,
              style: AppTypography.cent.copyWith(
                color: isIdle ? AppColors.textSecondary : color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (state.statusText.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            state.statusText,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 3,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStringSelector(Instrument instrument) {
    final strings = instrument.strings;
    // Deduplicate string names for display
    final uniqueStrings = <String>[];
    for (final s in strings) {
      if (!uniqueStrings.contains(s.name)) uniqueStrings.add(s.name);
    }
    final count = uniqueStrings.length;
    final crossAxisCount = count <= 4 ? count : (count <= 6 ? count : 4);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount.clamp(1, 6),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: uniqueStrings.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.bgElevated),
          ),
          child: Center(
            child: Text(
              uniqueStrings[index],
              style: const TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMicFab(BuildContext context, WidgetRef ref, bool isListening) {
    return GestureDetector(
      onTap: () => _onMicTap(context, ref),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: isListening ? AppColors.statusSharp : AppColors.brandPrimary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isListening ? AppColors.statusSharp : AppColors.brandPrimary)
                  .withValues(alpha: 0.3),
              blurRadius: 20,
            ),
          ],
        ),
        child: Icon(
          isListening ? Icons.stop : Icons.mic,
          size: 32,
          color: isListening ? Colors.white : AppColors.brandOn,
        ),
      ),
    );
  }

  Future<void> _onMicTap(BuildContext context, WidgetRef ref) async {
    final isListening = ref.read(isListeningProvider);

    if (isListening) {
      // Stop listening
      ref.read(isListeningProvider.notifier).state = false;
      ref.read(tunerStateProvider.notifier).state = const TunerState();
      return;
    }

    // Check permission
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      if (!context.mounted) return;
      final result = await showDialog<bool>(
        context: context,
        barrierColor: AppColors.bgBase.withValues(alpha: 0.7),
        builder: (_) => const MicPermissionDialog(),
      );
      if (result != true) return;
      status = await Permission.microphone.request();
      if (!status.isGranted) return;
    }

    // Start listening — simulate tuning for now
    ref.read(isListeningProvider.notifier).state = true;
    _simulateTuning(ref);
  }

  void _simulateTuning(WidgetRef ref) {
    final rng = Random();
    final states = [
      const TunerState(
          status: TunerStatus.flat,
          note: 'A',
          octave: 4,
          frequency: 436.8,
          cents: -12),
      const TunerState(
          status: TunerStatus.sharp,
          note: 'A',
          octave: 4,
          frequency: 443.2,
          cents: 12),
      const TunerState(
          status: TunerStatus.inTune,
          note: 'A',
          octave: 4,
          frequency: 440.0,
          cents: 0),
    ];
    ref.read(tunerStateProvider.notifier).state = states[rng.nextInt(3)];
  }
}
