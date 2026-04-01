import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/instrument.dart';
import '../models/tuner_state.dart';
import '../providers/instrument_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/tuner_provider.dart';
import '../services/note_calculator.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/waveform_painter.dart';
import '../widgets/pitch_bar.dart';
import '../widgets/mic_permission_dialog.dart';

class TunerScreen extends ConsumerStatefulWidget {
  const TunerScreen({super.key});

  @override
  ConsumerState<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends ConsumerState<TunerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    ref.read(tunerStateProvider.notifier).stopListening();
    super.dispose();
  }

  void _syncWaveAnimation(bool isListening) {
    if (isListening && !_waveController.isAnimating) {
      _waveController.repeat();
    } else if (!isListening && _waveController.isAnimating) {
      _waveController.stop();
      _waveController.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final instrument = ref.watch(selectedInstrumentProvider);
    final isListening = ref.watch(isListeningProvider);
    final isChromatic = instrument.id == 'chromatic';

    _syncWaveAnimation(isListening);

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
                  _WaveformSection(animation: _waveController),
                  const SizedBox(height: 32),
                  const _NoteSection(),
                  const SizedBox(height: 32),
                  const _PitchBarSection(),
                  const SizedBox(height: 32),
                  if (!isChromatic) _StringSelector(instrument: instrument),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: _MicFab(
                  isListening: isListening,
                  onTap: _onMicTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onMicTap() async {
    final isListening = ref.read(isListeningProvider);
    final notifier = ref.read(tunerStateProvider.notifier);

    if (isListening) {
      await notifier.stopListening();
      return;
    }

    // Check permission
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      if (!mounted) return;
      final result = await showDialog<bool>(
        context: context,
        barrierColor: AppColors.bgBase.withValues(alpha: 0.7),
        builder: (_) => const MicPermissionDialog(),
      );
      if (result != true) return;
      status = await Permission.microphone.request();
      if (!status.isGranted) return;
    }

    await notifier.startListening();
  }
}

// ---------------------------------------------------------------------------
// Waveform hero — AnimationBuilder ile phase animasyonu
// ---------------------------------------------------------------------------
class _WaveformSection extends ConsumerWidget {
  final Animation<double> animation;

  const _WaveformSection({required this.animation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tunerStateProvider);
    final isListening = ref.watch(isListeningProvider);
    final isIdle = state.status == TunerStatus.idle;
    final color = _statusColor(state.status);

    // Amplitude: idle 0.05, listening+idle 0.10, ses algılandığında confidence'a göre
    final double amplitude;
    if (!isListening || isIdle) {
      amplitude = isListening ? 0.10 : 0.05;
    } else {
      // 0.15 - 0.5 arası, confidence 0-1
      amplitude = 0.15 + (state.cents.abs() / 50).clamp(0.0, 1.0) * 0.35;
    }

    return RepaintBoundary(
      child: Container(
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
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return CustomPaint(
                      size: const Size(double.infinity, 128),
                      painter: WaveformPainter(
                        color: isIdle
                            ? AppColors.brandPrimary.withValues(alpha: 0.2)
                            : color.withValues(alpha: 0.8),
                        amplitude: amplitude,
                        phase: animation.value * 6.2832, // 2π
                        showDashed: state.status == TunerStatus.flat,
                        dashedColor: color,
                      ),
                    );
                  },
                ),
              ),
            ),
            if (isIdle)
              Center(
                child: Text(
                  isListening
                      ? 'Dinleniyor...'
                      : 'Akort etmek için mikrofona dokun',
                  style: const TextStyle(
                    fontFamily: 'BeVietnamPro',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 3,
                  ),
                ),
              ),
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Nota gösterimi
// ---------------------------------------------------------------------------
class _NoteSection extends ConsumerWidget {
  const _NoteSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tunerStateProvider);
    final notation = ref.watch(noteNotationProvider);
    final isIdle = state.status == TunerStatus.idle;
    final color = _statusColor(state.status);

    final displayNote = isIdle
        ? state.noteDisplay
        : notation == NoteNotation.solfege
            ? '${NoteCalculator.toTurkish(state.note)}${state.octave}'
            : state.noteDisplay;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              displayNote,
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
}

// ---------------------------------------------------------------------------
// PitchBar
// ---------------------------------------------------------------------------
class _PitchBarSection extends ConsumerWidget {
  const _PitchBarSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tunerStateProvider);
    final color = _statusColor(state.status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: PitchBar(
        cents: state.cents,
        indicatorColor: color,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tel seçici
// ---------------------------------------------------------------------------
class _StringSelector extends ConsumerWidget {
  final Instrument instrument;

  const _StringSelector({required this.instrument});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedStringProvider);
    final notation = ref.watch(noteNotationProvider);
    final strings = instrument.strings;
    final uniqueStrings = <StringTuning>[];
    final seen = <String>{};
    for (final s in strings) {
      if (seen.add(s.name)) uniqueStrings.add(s);
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
        final s = uniqueStrings[index];
        final isSelected = selected?.name == s.name;
        final displayName = notation == NoteNotation.solfege
            ? NoteCalculator.toTurkish(s.name)
            : s.name;

        return GestureDetector(
          onTap: () {
            final notifier = ref.read(selectedStringProvider.notifier);
            notifier.state = isSelected ? null : s;
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.brandPrimary : AppColors.bgElevated,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                displayName,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.brandPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Mikrofon FAB
// ---------------------------------------------------------------------------
class _MicFab extends StatelessWidget {
  final bool isListening;
  final VoidCallback onTap;

  const _MicFab({required this.isListening, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
}

// ---------------------------------------------------------------------------
// Ortak yardımcı
// ---------------------------------------------------------------------------
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
