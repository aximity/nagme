import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/providers/tuner_provider.dart';
import 'package:nagme/providers/instrument_provider.dart';
import 'package:nagme/providers/sensitivity_provider.dart';
import 'package:nagme/providers/tone_provider.dart';
import 'package:nagme/widgets/tuner/note_display.dart';
import 'package:nagme/widgets/tuner/frequency_display.dart';
import 'package:nagme/widgets/tuner/pitch_gauge.dart';
import 'package:nagme/widgets/tuner/tuning_status.dart';
import 'package:nagme/widgets/tuner/string_indicator.dart';
import 'package:nagme/widgets/tuner/strobe_display.dart';

class TunerScreen extends ConsumerWidget {
  const TunerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tunerState = ref.watch(tunerProvider);
    final instrument = ref.watch(selectedInstrumentProvider);
    final isActive = ref.watch(tunerProvider.notifier).isActive;
    final error = ref.watch(tunerErrorProvider);
    final sensitivity = ref.watch(sensitivityProvider);

    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
        ref.read(tunerErrorProvider.notifier).state = null;
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.surface],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Üst bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMD,
                  vertical: AppConstants.paddingXS,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActionChip(
                      avatar: Text(instrument.icon,
                          style: const TextStyle(fontSize: 16)),
                      label: Text(instrument.name),
                      backgroundColor: AppColors.surfaceLight,
                      side: const BorderSide(color: AppColors.surfaceBorder),
                      onPressed: () => context.push('/instruments'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings,
                          color: AppColors.textSecondary),
                      onPressed: () => context.push('/settings'),
                    ),
                  ],
                ),
              ),

              // Orta alan
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gauge
                    PitchGauge(
                      cents: tunerState.currentNote?.cents ?? 0,
                      isActive:
                          tunerState.status == TunerStatus.detected,
                    ),

                    const SizedBox(height: AppConstants.paddingMD),

                    // Nota + frekans
                    NoteDisplay(tunerState: tunerState),
                    const SizedBox(height: AppConstants.paddingSM),
                    FrequencyDisplay(tunerState: tunerState),

                    const SizedBox(height: AppConstants.paddingMD),

                    // Strobe display
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingXL),
                      child: StrobeDisplay(
                        cents: tunerState.currentNote?.cents ?? 0,
                        isActive:
                            tunerState.status == TunerStatus.detected,
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingMD),

                    // Durum
                    TuningStatus(tunerState: tunerState),

                    const SizedBox(height: AppConstants.paddingMD),

                    // Tel göstergesi
                    StringIndicator(
                      instrument: instrument,
                      activeString: tunerState.closestString,
                      onStringLongPress: (string) {
                        if (!isActive) {
                          ref
                              .read(toneGeneratorProvider)
                              .play(string.frequency);
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Alt alan: sensitivity + mikrofon butonu
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.paddingLG,
                  left: AppConstants.paddingXL,
                  right: AppConstants.paddingXL,
                ),
                child: Column(
                  children: [
                    // Hassasiyet slider
                    Row(
                      children: [
                        Icon(Icons.hearing,
                            size: 16, color: AppColors.textMuted),
                        Expanded(
                          child: Slider(
                            value: sensitivity,
                            min: 0.0,
                            max: 1.0,
                            activeColor:
                                AppColors.inTune.withValues(alpha: 0.6),
                            inactiveColor: AppColors.gaugeTrack,
                            onChanged: (v) => ref
                                .read(sensitivityProvider.notifier)
                                .state = v,
                          ),
                        ),
                        Icon(Icons.volume_up,
                            size: 16, color: AppColors.textMuted),
                      ],
                    ),

                    const SizedBox(height: AppConstants.paddingSM),

                    // Mikrofon butonu
                    GestureDetector(
                      onTap: () =>
                          ref.read(tunerProvider.notifier).toggle(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? AppColors.sharp.withValues(alpha: 0.15)
                              : AppColors.inTune.withValues(alpha: 0.15),
                          border: Border.all(
                            color: isActive
                                ? AppColors.sharp
                                : AppColors.inTune,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          isActive ? Icons.stop : Icons.mic,
                          color: isActive
                              ? AppColors.sharp
                              : AppColors.inTune,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
