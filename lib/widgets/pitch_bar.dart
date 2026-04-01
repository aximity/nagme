import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PitchBar extends StatelessWidget {
  /// -50 to +50 cent, 0 = in tune
  final double cents;
  final Color indicatorColor;

  const PitchBar({
    super.key,
    required this.cents,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    // Normalize cents to 0.0 - 1.0 range (-50 = 0.0, 0 = 0.5, +50 = 1.0)
    final position = ((cents + 50) / 100).clamp(0.0, 1.0);

    return Column(
      children: [
        SizedBox(
          height: 24,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Track
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 9,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  // Center notch
                  Positioned(
                    left: trackWidth / 2 - 1,
                    top: 4,
                    child: Container(
                      width: 2,
                      height: 16,
                      color: AppColors.brandPrimary.withValues(alpha: 0.3),
                    ),
                  ),
                  // Animated indicator dot
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    left: trackWidth * position - 10,
                    top: 2,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: indicatorColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.bgBase,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: indicatorColor.withValues(alpha: 0.6),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('-50 CENT',
                style: AppTypography.caption.copyWith(
                  fontSize: 10,
                  letterSpacing: 1.5,
                )),
            Text('0',
                style: AppTypography.caption.copyWith(
                  fontSize: 10,
                  letterSpacing: 1.5,
                )),
            Text('+50 CENT',
                style: AppTypography.caption.copyWith(
                  fontSize: 10,
                  letterSpacing: 1.5,
                )),
          ],
        ),
      ],
    );
  }
}
