import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:record/record.dart';
import 'package:nagme/config/constants.dart';

/// Mikrofon erişimi ve ham PCM audio stream sağlar.
class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<List<int>>? _subscription;
  final StreamController<Float32List> _controller =
      StreamController<Float32List>.broadcast();
  bool _isRecording = false;

  int _actualSampleRate = AppConstants.sampleRate;
  int get actualSampleRate => _actualSampleRate;

  Stream<Float32List> get stream => _controller.stream;
  bool get isRecording => _isRecording;

  Future<void> start() async {
    if (_isRecording) return;

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw AudioServiceException('Mikrofon izni verilmedi.');
    }

    // Web'de Chrome default 48000Hz kullanır
    final sampleRate = kIsWeb ? 48000 : AppConstants.sampleRate;
    _actualSampleRate = sampleRate;

    final stream = await _recorder.startStream(
      RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: sampleRate,
        numChannels: 1,
        autoGain: false,
        echoCancel: false,
        noiseSuppress: false,
      ),
    );

    _isRecording = true;

    _subscription = stream.listen(
      (data) {
        final float32 = _int16ToFloat32(Uint8List.fromList(data));
        if (float32.isNotEmpty) {
          _controller.add(float32);
        }
      },
      onError: (error) {
        _controller.addError(error);
      },
    );
  }

  Future<void> stop() async {
    if (!_isRecording) return;
    _isRecording = false;
    await _subscription?.cancel();
    _subscription = null;
    try {
      await _recorder.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    await stop();
    await _controller.close();
    _recorder.dispose();
  }

  Float32List _int16ToFloat32(Uint8List bytes) {
    final int sampleCount = bytes.length ~/ 2;
    final result = Float32List(sampleCount);
    final byteData = ByteData.sublistView(bytes);
    for (int i = 0; i < sampleCount; i++) {
      final int16 = byteData.getInt16(i * 2, Endian.little);
      result[i] = int16 / 32768.0;
    }
    return result;
  }
}

class AudioServiceException implements Exception {
  final String message;
  const AudioServiceException(this.message);

  @override
  String toString() => 'AudioServiceException: $message';
}
