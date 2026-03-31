import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/providers/settings_provider.dart';
import 'package:nagme/providers/tone_provider.dart';
import 'package:nagme/screens/instruments/instrument_select_screen.dart';
import 'package:nagme/widgets/common/bottom_nav_item.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: _TopBar(onBack: () => Navigator.of(context).pop()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM,
                vertical: AppConstants.paddingM,
              ),
              children: const [
                _SectionLabel('AKORT'),
                _AkortSection(),
                SizedBox(height: AppConstants.paddingL),
                _SectionLabel('GÖRÜNÜM'),
                _GorununSection(),
                SizedBox(height: AppConstants.paddingL),
                _SectionLabel('SES'),
                _SesSection(),
                SizedBox(height: AppConstants.paddingL),
                _SectionLabel('HAKKINDA'),
                _HakkindaSection(),
                SizedBox(height: AppConstants.paddingXxl),
                _DesignedForResonance(),
                SizedBox(height: AppConstants.paddingXxl),
              ],
            ),
          ),
        ],
      ),
      // Bottom nav (ayarlar ekranında da mevcut)
      bottomNavigationBar: _BottomNavStub(),
    );
  }
}

// ─────────────────────────────────────────────
// Top Bar
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
          vertical: AppConstants.paddingM),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Icon(Icons.arrow_back,
                color: AppColors.primaryContainer, size: 24),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Text(
            'Ayarlar',
            style: GoogleFonts.epilogue(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.tertiaryFixed,
            ),
          ),
          const Spacer(),
          const Icon(Icons.tune, color: AppColors.primaryContainer, size: 22),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppConstants.paddingS,
          bottom: AppConstants.paddingS),
      child: Text(
        text,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 11,
          letterSpacing: 3,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// AKORT bölümü
// ─────────────────────────────────────────────
class _AkortSection extends ConsumerWidget {
  const _AkortSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refHz = ref.watch(referenceHzProvider);
    final threshold = ref.watch(tuneThresholdProvider);

    return _Card(children: [
      // Referans A4
      _Row(
        label: 'Referans Ses (A4)',
        sublabel: 'Standart Frekans',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _IconBtn(
              icon: Icons.remove,
              onTap: () => ref.saveRefHz((refHz - 1).clamp(415, 466)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '${refHz.toInt()} Hz',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            _IconBtn(
              icon: Icons.add,
              onTap: () => ref.saveRefHz((refHz + 1).clamp(415, 466)),
            ),
          ],
        ),
      ),

      _Divider(),

      // Akort eşiği
      Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Akort Eşiği',
                style: GoogleFonts.manrope(
                    color: AppColors.tertiaryFixed,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: AppConstants.paddingM),
            Row(
              children: [
                for (final t in [10, 5, 3])
                  Expanded(
                    child: GestureDetector(
                      onTap: () => ref.saveTuneThreshold(t),
                      child: AnimatedContainer(
                        duration: AppConstants.animFast,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: threshold == t
                              ? AppColors.surfaceContainerHighest
                              : Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusS),
                        ),
                        child: Center(
                          child: Text(
                            '±$t',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: threshold == t
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
// GÖRÜNÜM bölümü
// ─────────────────────────────────────────────
class _GorununSection extends ConsumerWidget {
  const _GorununSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notation = ref.watch(noteNotationProvider);

    return _Card(children: [
      _Row(
        label: 'Karanlık Mod',
        sublabel: 'Varsayılan tema',
        trailing: _Toggle(value: true, onChanged: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Açık tema yakında eklenecek'),
              duration: Duration(seconds: 1),
            ),
          );
        }),
      ),

      _Divider(),

      _Row(
        label: 'Nota Gösterimi',
        trailing: _SegmentControl(
          options: const ['C D E', 'Do Re Mi'],
          selected: notation,
          onSelect: (i) => ref.saveNoteNotation(i),
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
// SES bölümü
// ─────────────────────────────────────────────
class _SesSection extends ConsumerWidget {
  const _SesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toneEnabled = ref.watch(toneEnabledProvider);

    return _Card(children: [
      _Row(
        label: 'Akort Sesi',
        sublabel: 'Tele tıklayınca referans ses çalar',
        trailing: _Toggle(
          value: toneEnabled,
          onChanged: (v) {
            ref.saveToneEnabled(v);
            if (!v) ref.read(toneGeneratorProvider).stop();
          },
        ),
      ),
      _Divider(),
      GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Piyano ve gitar sesleri yakında eklenecek'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: _Row(
          label: 'Ses Tipi',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sinüs',
                  style: GoogleFonts.spaceGrotesk(
                      color: AppColors.primary, fontSize: 13)),
              const SizedBox(width: 4),
              const Icon(Icons.unfold_more,
                  size: 16, color: AppColors.primary),
            ],
          ),
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
// HAKKINDA bölümü
// ─────────────────────────────────────────────
class _HakkindaSection extends StatelessWidget {
  const _HakkindaSection();

  @override
  Widget build(BuildContext context) {
    return _Card(children: [
      _Row(
        label: 'Sürüm',
        trailing: Text('1.0.0',
            style: GoogleFonts.spaceGrotesk(
                fontSize: 13, color: AppColors.onSurfaceVariant)),
      ),
      _Divider(),
      GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Geri bildirim için teşekkürler! info@kibrissanat.com adresine yazabilirsiniz.'),
            ),
          );
        },
        child: _Row(
          label: 'Geri Bildirim Gönder',
          trailing: const Icon(Icons.chevron_right,
              color: AppColors.onSurfaceVariant, size: 20),
        ),
      ),
      _Divider(),
      GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Play Store değerlendirmesi yakında aktif olacak.'),
            ),
          );
        },
        child: _Row(
          label: 'Değerlendir',
          trailing: const Icon(Icons.star_outline,
              color: AppColors.onSurfaceVariant, size: 20),
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
// "Designed for Resonance" dekorasyon
// ─────────────────────────────────────────────
class _DesignedForResonance extends StatelessWidget {
  const _DesignedForResonance();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.3,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final h in [16.0, 24.0, 40.0, 24.0, 16.0])
                Container(
                  width: 4,
                  height: h,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'REZONANS İÇİN TASARLANDI',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10,
              letterSpacing: 4,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom nav stub (ayarlar'da Tuner aktif değil)
// ─────────────────────────────────────────────
class _BottomNavStub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Color(0x55000000), blurRadius: 24, offset: Offset(0, -8)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingM,
              vertical: AppConstants.paddingS),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavItem(
                icon: Icons.vibration,
                label: 'AKORT',
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 48),
              BottomNavItem(
                icon: Icons.library_music_outlined,
                label: 'ENSTRÜMAN',
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const InstrumentSelectScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// _NavItem kaldırıldı — lib/widgets/common/bottom_nav_item.dart kullanılıyor

// ─────────────────────────────────────────────
// Ortak alt bileşenler
// ─────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Column(children: children),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, this.sublabel, required this.trailing});
  final String label;
  final String? sublabel;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingM,
          vertical: AppConstants.paddingM),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.manrope(
                        color: AppColors.tertiaryFixed,
                        fontWeight: FontWeight.w500)),
                if (sublabel != null)
                  Text(sublabel!,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 11, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      color: AppColors.surfaceContainerHighest.withValues(alpha: 0.2),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        width: 48,
        height: 26,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onPrimaryFixed,
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentControl extends StatelessWidget {
  const _SegmentControl({
    required this.options,
    required this.selected,
    required this.onSelect,
  });
  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < options.length; i++)
            GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: AppConstants.animFast,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: selected == i
                      ? AppColors.surfaceContainerHighest
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS - 2),
                ),
                child: Text(
                  options[i],
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: selected == i
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingXs),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppConstants.radiusS),
        ),
        child: Icon(icon, color: AppColors.onSurface, size: 18),
      ),
    );
  }
}
