import 'package:flutter_test/flutter_test.dart';
import 'package:nagme/models/tuning_session.dart';

void main() {
  group('TuningSession', () {
    final session = TuningSession(
      startTime: DateTime(2026, 3, 28, 20, 0, 0),
      endTime: DateTime(2026, 3, 28, 20, 5, 30),
      instrumentId: 'guitar',
      instrumentName: 'Gitar',
      tuningName: 'Drop D',
      detectedCount: 100,
      inTuneCount: 75,
    );

    test('duration dogru hesaplanir', () {
      expect(session.duration, const Duration(minutes: 5, seconds: 30));
    });

    test('successRate dogru hesaplanir', () {
      expect(session.successRate, 0.75);
    });

    test('successRate 0 detected icin 0 doner', () {
      final empty = TuningSession(
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        instrumentId: 'guitar',
        instrumentName: 'Gitar',
        tuningName: 'Standart',
        detectedCount: 0,
        inTuneCount: 0,
      );
      expect(empty.successRate, 0.0);
    });

    test('JSON serialization round-trip', () {
      final json = session.toJson();
      final restored = TuningSession.fromJson(json);
      expect(restored.instrumentId, session.instrumentId);
      expect(restored.instrumentName, session.instrumentName);
      expect(restored.tuningName, session.tuningName);
      expect(restored.detectedCount, session.detectedCount);
      expect(restored.inTuneCount, session.inTuneCount);
      expect(restored.startTime, session.startTime);
      expect(restored.endTime, session.endTime);
    });

    test('encodeList + decodeList round-trip', () {
      final sessions = [session, session];
      final encoded = TuningSession.encodeList(sessions);
      final decoded = TuningSession.decodeList(encoded);
      expect(decoded.length, 2);
      expect(decoded[0].instrumentId, 'guitar');
      expect(decoded[1].tuningName, 'Drop D');
    });

    test('fromJson tuningName yoksa Standart kullanir', () {
      final json = {
        'startTime': '2026-03-28T20:00:00.000',
        'endTime': '2026-03-28T20:05:00.000',
        'instrumentId': 'violin',
        'instrumentName': 'Keman',
        'detectedCount': 50,
        'inTuneCount': 40,
      };
      final restored = TuningSession.fromJson(json);
      expect(restored.tuningName, 'Standart');
    });
  });
}
