import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/models/note.dart';

class NoteDisplay extends StatefulWidget {
  const NoteDisplay({super.key, required this.note, required this.isInTune});

  final Note? note;
  final bool isInTune;

  @override
  State<NoteDisplay> createState() => _NoteDisplayState();
}

class _NoteDisplayState extends State<NoteDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    // Büyü → küçül → normale dön — kısa bir "snap" hissi
    _pulseScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.07)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.07, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 70,
      ),
    ]).animate(_pulseCtrl);
  }

  @override
  void didUpdateWidget(NoteDisplay old) {
    super.didUpdateWidget(old);
    // Sadece "akortlu değil → akortlu" geçişinde tetikle
    if (!old.isInTune && widget.isInTune) {
      _pulseCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseScale,
      builder: (_, child) => Transform.scale(
        scale: _pulseScale.value,
        child: child,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.84, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        ),
        child: widget.note == null
            ? _buildEmpty()
            : _buildNote(widget.note!, widget.isInTune),
      ),
    );
  }

  Widget _buildEmpty() {
    return Column(
      key: const ValueKey('empty'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '—',
          style: GoogleFonts.epilogue(
            fontSize: 120,
            fontWeight: FontWeight.w900,
            color: AppColors.surfaceContainerHighest,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '— Hz',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            letterSpacing: 3,
            color: AppColors.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }

  Widget _buildNote(Note note, bool inTune) {
    final color = inTune ? AppColors.primaryContainer : AppColors.primary;

    return Column(
      key: ValueKey(note.fullName),
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (inTune)
              _GlowText(
                text: note.name,
                style: GoogleFonts.epilogue(
                  fontSize: 120,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryContainer,
                  height: 1.0,
                ),
              )
            else
              Text(
                note.name,
                style: GoogleFonts.epilogue(
                  fontSize: 120,
                  fontWeight: FontWeight.w900,
                  color: color,
                  height: 1.0,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                '${note.octave}',
                style: GoogleFonts.epilogue(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: color.withValues(alpha: 0.6),
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${note.frequency.toStringAsFixed(1)} Hz',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            letterSpacing: 3,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Amber linear-gradient shader ile glow efekti
class _GlowText extends StatelessWidget {
  const _GlowText({required this.text, required this.style});
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.primary, AppColors.primaryContainer],
      ).createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}
