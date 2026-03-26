import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';
import 'package:nagme/providers/instrument_provider.dart';
import 'package:nagme/widgets/common/instrument_card.dart';

class InstrumentSelectScreen extends ConsumerWidget {
  const InstrumentSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instruments = ref.watch(instrumentListProvider);
    final selected = ref.watch(selectedInstrumentProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Enstrüman Seçimi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMD),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppConstants.paddingMD,
            crossAxisSpacing: AppConstants.paddingMD,
            childAspectRatio: 1.2,
          ),
          itemCount: instruments.length,
          itemBuilder: (context, index) {
            final instrument = instruments[index];
            final isSelected = instrument.id == selected.id;

            return InstrumentCard(
              instrument: instrument,
              isSelected: isSelected,
              onTap: () {
                ref.read(selectedInstrumentProvider.notifier).state =
                    instrument;
                context.pop();
              },
            );
          },
        ),
      ),
    );
  }
}
