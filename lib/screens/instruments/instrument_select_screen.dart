import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/config/instruments.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/providers/instrument_provider.dart';
import 'package:nagme/widgets/common/instrument_card.dart';

class InstrumentSelectScreen extends ConsumerStatefulWidget {
  const InstrumentSelectScreen({super.key});

  @override
  ConsumerState<InstrumentSelectScreen> createState() =>
      _InstrumentSelectScreenState();
}

class _InstrumentSelectScreenState
    extends ConsumerState<InstrumentSelectScreen> {
  late InstrumentTuning _pending;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _pending = ref.read(selectedInstrumentProvider);
  }

  List<InstrumentTuning> get _filtered {
    if (_query.isEmpty) return kInstruments;
    final q = _query.toLowerCase();
    return kInstruments.where((i) =>
        i.name.toLowerCase().contains(q) ||
        i.nameEn.toLowerCase().contains(q)).toList();
  }

  void _confirm() {
    ref.selectInstrument(_pending);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top bar
          SafeArea(
            bottom: false,
            child: _TopBar(onBack: () => Navigator.of(context).pop()),
          ),

          // İçerik
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM),
              child: Column(
                children: [
                  const SizedBox(height: AppConstants.paddingM),

                  // Arama çubuğu
                  _SearchBar(
                    onChanged: (v) => setState(() => _query = v),
                  ),

                  const SizedBox(height: AppConstants.paddingL),

                  // Grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(
                          bottom: AppConstants.paddingXxl * 3),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppConstants.paddingM,
                        mainAxisSpacing: AppConstants.paddingM,
                        childAspectRatio: 0.82,
                      ),
                      itemCount: _filtered.length,
                      itemBuilder: (ctx, i) {
                        final inst = _filtered[i];
                        return InstrumentCard(
                          instrument: inst,
                          isSelected: _pending.id == inst.id,
                          onTap: () => setState(() => _pending = inst),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Onayla butonu — glass panel
      bottomSheet: _ConfirmBar(onConfirm: _confirm),
    );
  }
}

// ─────────────────────────────────────────────
// Top bar
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingM,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Icon(Icons.arrow_back,
                color: AppColors.onSurface, size: 24),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Text(
            'Enstrüman Seç',
            style: GoogleFonts.epilogue(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.tertiaryFixed,
            ),
          ),
          const Spacer(),
          Text(
            'Nağme',
            style: GoogleFonts.epilogue(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Arama çubuğu
// ─────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: TextField(
        onChanged: onChanged,
        style: GoogleFonts.manrope(color: AppColors.onSurface),
        decoration: InputDecoration(
          hintText: 'Ara...',
          hintStyle: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
          prefixIcon: const Icon(Icons.search,
              color: AppColors.onSurfaceVariant, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: AppConstants.paddingM),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Onayla butonu — Stitch glass panel
// ─────────────────────────────────────────────
class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({required this.onConfirm});
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingM,
            vertical: AppConstants.paddingL,
          ),
          child: SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: onConfirm,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: AppConstants.paddingM + 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(-0.3, -0.3),
                    end: Alignment(1, 1),
                    colors: [AppColors.primary, AppColors.primaryContainer],
                  ),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryContainer.withValues(alpha: 0.3),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Onayla',
                    style: GoogleFonts.epilogue(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimaryFixed,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
