import 'dart:convert';

/// Tek bir akort oturumu kaydi.
class TuningSession {
  final DateTime startTime;
  final DateTime endTime;
  final String instrumentId;
  final String instrumentName;
  final String tuningName;
  final int detectedCount;
  final int inTuneCount;

  const TuningSession({
    required this.startTime,
    required this.endTime,
    required this.instrumentId,
    required this.instrumentName,
    required this.tuningName,
    required this.detectedCount,
    required this.inTuneCount,
  });

  Duration get duration => endTime.difference(startTime);

  /// Akort basari yuzdesi (0.0 — 1.0).
  double get successRate =>
      detectedCount > 0 ? inTuneCount / detectedCount : 0.0;

  Map<String, dynamic> toJson() => {
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'instrumentId': instrumentId,
        'instrumentName': instrumentName,
        'tuningName': tuningName,
        'detectedCount': detectedCount,
        'inTuneCount': inTuneCount,
      };

  factory TuningSession.fromJson(Map<String, dynamic> json) => TuningSession(
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: DateTime.parse(json['endTime'] as String),
        instrumentId: json['instrumentId'] as String,
        instrumentName: json['instrumentName'] as String,
        tuningName: (json['tuningName'] as String?) ?? 'Standart',
        detectedCount: json['detectedCount'] as int,
        inTuneCount: json['inTuneCount'] as int,
      );

  static String encodeList(List<TuningSession> sessions) =>
      jsonEncode(sessions.map((s) => s.toJson()).toList());

  static List<TuningSession> decodeList(String json) {
    final list = jsonDecode(json) as List;
    return list
        .map((e) => TuningSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
