import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:nagme/widgets/common/instrument_icon.dart';

class TunerScreen extends ConsumerStatefulWidget {
  const TunerScreen({super.key});

  @override
  ConsumerState<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends ConsumerState<TunerScreen>
    with WidgetsBindingObserver {
  bool _wasInTune = false;
  bool _wasActiveBeforePause = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notifier = ref.read(tunerProvider.notifier);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Arka plana alindi — mikrofonu durdur
      if (notifier.isActive) {
        _wasActiveBeforePause = true;
        notifier.stop();
      }
    } else if (state == AppLifecycleState.resumed) {
      // On plana dondu — mikrofonu yeniden baslat
      if (_wasActiveBeforePause) {
        _wasActiveBeforePause = false;
        notifier.start();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tunerState = ref.watch(tunerProvider);
    final instrument = ref.watch(selectedInstrumentProvider);
    final isActive = ref.watch(tunerProvider.notifier).isActive;
    final error = ref.watch(tunerErrorProvider);
    final sensitivity = ref.watch(sensitivityProvider);

    // Haptic feedback: akort olduğunda
    if (tunerState.isInTune && !_wasInTune) {
      HapticFeedback.mediumImpact();
    }
    _wasInTune = tunerState.isInTune;

    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
        ref.read(tunerErrorProvider.notifier).state = null;
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          // Arka plan — vignette + gauge glow
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: AppGradients.backgroundVignette,
              ),
            ),
          ),

          // Gauge arkası glow (aktifken)
          if (isActive && tunerState.status == TunerStatus.detected)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.5,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: tunerState.isInTune ? 1.0 : 0.3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, 0.2),
                      radius: 0.8,
                      colors: [
                        (tunerState.isInTune ? AppColors.inTune : AppColors.textMuted)
                            .withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Ana içerik
          SafeArea(
            child: Column(
              children: [
                // Üst bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMD,
                    vertical: AppConstants.paddingSM,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Glassmorphic enstrüman chip
                      GestureDetector(
                        onTap: () => context.push('/instruments'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                            border: Border.all(
                              color: AppColors.surfaceBorder.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InstrumentIcon(
                                instrument: instrument,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                instrument.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textMuted,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_rounded,
                            color: AppColors.textMuted, size: 22),
                        onPressed: () => context.push('/settings'),
                      ),
                    ],
                  ),
                ),

                // Gauge alanı
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PitchGauge(
                        cents: tunerState.currentNote?.cents ?? 0,
                        isActive:
                            tunerState.status == TunerStatus.detected,
                      ),

                      const SizedBox(height: AppConstants.paddingLG),

                      // Nota + frekans
                      NoteDisplay(tunerState: tunerState),
                      const SizedBox(height: AppConstants.paddingSM),
                      FrequencyDisplay(tunerState: tunerState),
                    ],
                  ),
                ),

                // Strobe + durum + teller
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Strobe
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingXL + 8),
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
                          Icon(Icons.hearing_rounded,
                              size: 14, color: AppColors.textMuted),
                          Expanded(
                            child: Slider(
                              value: sensitivity,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (v) => ref
                                  .read(sensitivityProvider.notifier)
                                  .state = v,
                            ),
                          ),
                          Icon(Icons.volume_up_rounded,
                              size: 14, color: AppColors.textMuted),
                        ],
                      ),

                      const SizedBox(height: AppConstants.paddingSM),

                      // Premium mikrofon butonu
                      _MicButton(
                        isActive: isActive,
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          ref.read(tunerProvider.notifier).toggle();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium mikrofon butonu — breathing glow + press animation.
class _MicButton extends StatefulWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _MicButton({required this.isActive, required this.onTap});

  @override
  State<_MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<_MicButton>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppConstants.buttonScaleDuration),
    );
    _pressAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant _MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_breathController.isAnimating) {
      _breathController.repeat(reverse: true);
    } else if (!widget.isActive) {
      _breathController.stop();
      _breathController.value = 0;
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pressAnimation, _breathController]),
        builder: (context, child) {
          final breathValue = _breathController.value;
          final accentColor =
              widget.isActive ? AppColors.sharp : AppColors.inTune;

          return Transform.scale(
            scale: _pressAnimation.value,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.08 + breathValue * 0.04),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.5 + breathValue * 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor
                        .withValues(alpha: widget.isActive ? 0.15 + breathValue * 0.1 : 0.08),
                    blurRadius: widget.isActive ? 20 + breathValue * 8 : 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                widget.isActive ? Icons.stop_rounded : Icons.mic_rounded,
                color: accentColor,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}
