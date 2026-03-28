import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/widgets/common/instrument_icon.dart';

/// Premium enstrüman seçim kartı — press animation + derinlik.
class InstrumentCard extends StatefulWidget {
  final InstrumentTuning instrument;
  final bool isSelected;
  final VoidCallback onTap;

  const InstrumentCard({
    super.key,
    required this.instrument,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<InstrumentCard> createState() => _InstrumentCardState();
}

class _InstrumentCardState extends State<InstrumentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppConstants.buttonScaleDuration),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1E1A14),
                          Color(0xFF161412),
                        ],
                      )
                    : AppGradients.cardSurface,
                borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                border: Border.all(
                  color: widget.isSelected
                      ? AppColors.inTune.withValues(alpha: 0.4)
                      : AppColors.surfaceBorder.withValues(alpha: 0.4),
                  width: widget.isSelected ? 1.5 : 1,
                ),
                boxShadow: widget.isSelected
                    ? AppShadows.glow(AppColors.inTune, blur: 16)
                    : null,
              ),
              child: Stack(
                children: [
                  if (widget.isSelected)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.inTune.withValues(alpha: 0.15),
                          border: Border.all(
                            color: AppColors.inTune.withValues(alpha: 0.5),
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: AppColors.inTune,
                          size: 13,
                        ),
                      ),
                    ),

                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InstrumentIcon(
                          instrument: widget.instrument,
                          size: 48,
                        ),
                        const SizedBox(height: AppConstants.paddingSM),
                        Text(
                          widget.instrument.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: widget.isSelected
                                    ? AppColors.inTune
                                    : AppColors.textPrimary,
                                fontWeight: widget.isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                        ),
                        if (!widget.instrument.isChromatic)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '${widget.instrument.stringCount} tel',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
