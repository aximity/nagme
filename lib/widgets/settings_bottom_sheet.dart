import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class SettingsBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T selected;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onSelected;

  const SettingsBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(title, style: AppTypography.heading3),
          const SizedBox(height: 16),
          // Options
          ...options.map((option) {
            final isActive = option == selected;
            return InkWell(
              onTap: () {
                onSelected(option);
                Navigator.of(context).pop();
              },
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      labelBuilder(option),
                      style: AppTypography.body.copyWith(
                        color: isActive
                            ? AppColors.brandPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    if (isActive)
                      const Icon(
                        Icons.check,
                        color: AppColors.brandPrimary,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

class FrequencyBottomSheet extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const FrequencyBottomSheet({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<FrequencyBottomSheet> createState() => _FrequencyBottomSheetState();
}

class _FrequencyBottomSheetState extends State<FrequencyBottomSheet> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text('Referans Frekansı', style: AppTypography.heading3),
          const SizedBox(height: 24),
          Text(
            'A4 = ${_value.round()} Hz',
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.brandPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.brandPrimary,
                inactiveTrackColor: AppColors.bgElevated,
                thumbColor: AppColors.brandPrimary,
                overlayColor: AppColors.brandPrimary.withValues(alpha: 0.2),
              ),
              child: Slider(
                min: 432,
                max: 446,
                divisions: 14,
                value: _value,
                onChanged: (v) => setState(() => _value = v),
                onChangeEnd: (v) {
                  widget.onChanged(v);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('432 Hz', style: AppTypography.caption),
                Text('446 Hz', style: AppTypography.caption),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
        ],
      ),
    );
  }
}
