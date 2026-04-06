import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/tuner_state.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/settings_bottom_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refFreq = ref.watch(referenceFreqProvider);
    final threshold = ref.watch(tuningThresholdProvider);
    final notation = ref.watch(noteNotationProvider);
    final refSound = ref.watch(referenceSoundProvider);
    final soundType = ref.watch(soundTypeProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => context.go('/tuner'),
        ),
        title: Text('Ayarlar', style: AppTypography.heading2),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AKORT
            _buildSectionHeader('AKORT'),
            _buildCard([
              _buildSettingsRow(
                'Referans Frekansı',
                trailing: _buildValueChevron('A4 = ${refFreq.round()} Hz'),
                onTap: () => _showFrequencySheet(context, ref, refFreq),
              ),
              _buildSettingsRow(
                'Akort Eşiği',
                trailing: _buildValueChevron('± $threshold cent'),
                onTap: () => _showThresholdSheet(context, ref, threshold),
              ),
              _buildSettingsRow(
                'Nota Gösterimi',
                trailing: _buildValueChevron(
                  notation == NoteNotation.letter ? 'C D E' : 'Do Re Mi',
                ),
                onTap: () => _showNotationSheet(context, ref, notation),
                showDivider: false,
              ),
            ]),
            const SizedBox(height: 24),

            // SES
            _buildSectionHeader('SES'),
            _buildCard([
              _buildSettingsRow(
                'Referans Sesi',
                trailing: _buildToggle(
                  refSound,
                  (v) => ref.read(referenceSoundProvider.notifier).value = v,
                ),
              ),
              _buildSettingsRow(
                'Ses Tipi',
                trailing: _buildValueChevron(_soundTypeLabel(soundType)),
                onTap: () => _showSoundTypeSheet(context, ref, soundType),
                showDivider: false,
              ),
            ]),
            const SizedBox(height: 24),

            // HAKKINDA
            _buildSectionHeader('HAKKINDA'),
            _buildCard([
              _buildSettingsRow(
                'Nağme Hakkında',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onTap: () => context.push('/about'),
              ),
              _buildSettingsRow(
                'Sürüm',
                trailing: Text('2.0.0', style: AppTypography.bodySecondary),
              ),
              _buildSettingsRow(
                'Geri Bildirim',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onTap: () => _sendFeedback(),
                showDivider: false,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // --- Bottom Sheets ---

  void _showFrequencySheet(BuildContext context, WidgetRef ref, double current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => FrequencyBottomSheet(
        value: current,
        onChanged: (v) => ref.read(referenceFreqProvider.notifier).value = v,
      ),
    );
  }

  void _showThresholdSheet(BuildContext context, WidgetRef ref, int current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SettingsBottomSheet<int>(
        title: 'Akort Eşiği',
        options: const [1, 2, 3, 5, 10],
        selected: current,
        labelBuilder: (v) => '± $v cent',
        onSelected: (v) =>
            ref.read(tuningThresholdProvider.notifier).value = v,
      ),
    );
  }

  void _showNotationSheet(
      BuildContext context, WidgetRef ref, NoteNotation current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SettingsBottomSheet<NoteNotation>(
        title: 'Nota Gösterimi',
        options: NoteNotation.values,
        selected: current,
        labelBuilder: (v) =>
            v == NoteNotation.letter ? 'C D E F G A B' : 'Do Re Mi Fa Sol La Si',
        onSelected: (v) =>
            ref.read(noteNotationProvider.notifier).value = v,
      ),
    );
  }

  void _showSoundTypeSheet(
      BuildContext context, WidgetRef ref, SoundType current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SettingsBottomSheet<SoundType>(
        title: 'Ses Tipi',
        options: SoundType.values,
        selected: current,
        labelBuilder: _soundTypeLabel,
        onSelected: (v) => ref.read(soundTypeProvider.notifier).value = v,
      ),
    );
  }

  String _soundTypeLabel(SoundType t) {
    switch (t) {
      case SoundType.sine:
        return 'Sinüs';
      case SoundType.square:
        return 'Kare';
      case SoundType.triangle:
        return 'Üçgen';
    }
  }

  Future<void> _sendFeedback() async {
    final uri = Uri.parse('mailto:info@aximity.dev?subject=Nağme Geri Bildirim');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // --- Shared Widgets ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.brandPrimary,
          letterSpacing: 2.2,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildSettingsRow(
    String title, {
    Widget? trailing,
    bool showDivider = true,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTypography.body),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            color: AppColors.bgElevated,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  Widget _buildValueChevron(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTypography.bodySecondary),
        const SizedBox(width: 8),
        const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildToggle(bool value, ValueChanged<bool>? onChanged) {
    final enabled = onChanged != null;
    return GestureDetector(
      onTap: enabled ? () => onChanged(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: value
              ? (enabled ? AppColors.brandPrimary : AppColors.brandPrimary.withValues(alpha: 0.4))
              : AppColors.bgElevated,
          borderRadius: BorderRadius.circular(99),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
