import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/providers/settings_provider.dart';
import 'package:nagme/utils/note_utils.dart';

/// Premium tel göstergesi — dokunma animasyonu + haptic feedback.
class StringIndicator extends ConsumerWidget {
  final InstrumentTuning instrument;
  final StringTuning? activeString;
  final ValueChanged<StringTuning>? onStringTap;
  final ValueChanged<StringTuning>? onStringLongPress;

  const StringIndicator({
    super.key,
    required this.instrument,
    this.activeString,
    this.onStringTap,
    this.onStringLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (instrument.isChromatic) return const SizedBox.shrink();
    final notation = ref.watch(notationProvider);

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.paddingLG),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: instrument.strings.map((string) {
          final isActive = activeString != null &&
              activeString!.name == string.name &&
              activeString!.octave == string.octave;

          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingXS + 2),
            child: _StringButton(
              string: string,
              isActive: isActive,
              notation: notation,
              onTap: () => onStringTap?.call(string),
              onLongPress: () {
                HapticFeedback.lightImpact();
                onStringLongPress?.call(string);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StringButton extends StatefulWidget {
  final StringTuning string;
  final bool isActive;
  final String notation;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _StringButton({
    required this.string,
    required this.isActive,
    required this.notation,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<_StringButton> createState() => _StringButtonState();
}

class _StringButtonState extends State<_StringButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppConstants.buttonScaleDuration),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _scaleController.reverse(),
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isActive
                    ? AppColors.inTune.withValues(alpha: 0.12)
                    : AppColors.surfaceLight,
                border: Border.all(
                  color: widget.isActive
                      ? AppColors.inTune.withValues(alpha: 0.6)
                      : AppColors.surfaceBorder.withValues(alpha: 0.5),
                  width: widget.isActive ? 1.5 : 1,
                ),
                boxShadow: widget.isActive
                    ? AppShadows.glow(AppColors.inTune, blur: 12)
                    : null,
              ),
              child: Center(
                child: Text(
                  widget.notation == 'turkish'
                      ? noteNameTurkish(widget.string.name)
                      : widget.string.name,
                  style:
                      Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: widget.isActive
                                ? AppColors.inTune
                                : AppColors.textSecondary,
                            fontWeight: widget.isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
