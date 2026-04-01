import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tuner_state.dart';

final referenceFreqProvider = StateProvider<double>((ref) => 440.0);

final tuningThresholdProvider = StateProvider<int>((ref) => 5);

final noteNotationProvider = StateProvider<NoteNotation>((ref) => NoteNotation.letter);

final referenceSoundProvider = StateProvider<bool>((ref) => true);

final soundTypeProvider = StateProvider<SoundType>((ref) => SoundType.sine);

final darkThemeProvider = StateProvider<bool>((ref) => true);
