import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/instrument.dart';

final selectedInstrumentProvider = StateProvider<Instrument>((ref) {
  return Instruments.violin;
});
