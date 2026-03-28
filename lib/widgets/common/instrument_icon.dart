import 'package:flutter/material.dart';
import 'package:nagme/models/instrument.dart';

/// Enstrüman ikonu — asset tabanlı, emoji yerine.
class InstrumentIcon extends StatelessWidget {
  final InstrumentTuning instrument;
  final double size;

  const InstrumentIcon({
    super.key,
    required this.instrument,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      instrument.iconAsset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback: emoji
        return Text(
          instrument.icon,
          style: TextStyle(fontSize: size * 0.8),
        );
      },
    );
  }
}
