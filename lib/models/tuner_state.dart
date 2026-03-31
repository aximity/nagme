import 'package:nagme/models/note.dart';
import 'package:nagme/models/instrument.dart';

class TunerState {
  const TunerState({
    this.currentNote,
    this.frequency,
    this.cents = 0.0,
    this.isInTune = false,
    this.isActive = false,
    this.closestString,
  });

  final Note? currentNote;
  final double? frequency;
  final double cents;
  final bool isInTune;
  final bool isActive;
  final StringTuning? closestString;

  static const TunerState idle = TunerState();

  TunerState copyWith({
    Note? currentNote,
    double? frequency,
    double? cents,
    bool? isInTune,
    bool? isActive,
    StringTuning? closestString,
    bool clearNote = false,
    bool clearFrequency = false,
    bool clearClosestString = false,
  }) {
    return TunerState(
      currentNote: clearNote ? null : (currentNote ?? this.currentNote),
      frequency: clearFrequency ? null : (frequency ?? this.frequency),
      cents: cents ?? this.cents,
      isInTune: isInTune ?? this.isInTune,
      isActive: isActive ?? this.isActive,
      closestString: clearClosestString ? null : (closestString ?? this.closestString),
    );
  }
}
