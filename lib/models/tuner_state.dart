import 'package:nagme/models/note.dart';
import 'package:nagme/models/instrument.dart';

/// Tuner durumu
enum TunerStatus { idle, listening, detected, noSignal, lowConfidence }

class TunerState {
  final TunerStatus status;
  final Note? currentNote;
  final double? rawFrequency;
  final StringTuning? closestString;
  final double confidence; // 0.0 — 1.0

  const TunerState({
    this.status = TunerStatus.idle,
    this.currentNote,
    this.rawFrequency,
    this.closestString,
    this.confidence = 0.0,
  });

  bool get isInTune =>
      currentNote != null && currentNote!.cents.abs() <= 5.0;

  TunerState copyWith({
    TunerStatus? status,
    Note? currentNote,
    double? rawFrequency,
    StringTuning? closestString,
    double? confidence,
  }) {
    return TunerState(
      status: status ?? this.status,
      currentNote: currentNote ?? this.currentNote,
      rawFrequency: rawFrequency ?? this.rawFrequency,
      closestString: closestString ?? this.closestString,
      confidence: confidence ?? this.confidence,
    );
  }

  static const initial = TunerState();
}
