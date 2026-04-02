import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';

import '../models/pitch_result.dart';

// compute() için top-level fonksiyon — isolate'de çalışır
Future<PitchResult> _detectPitch(Map<String, dynamic> params) async {
  final buffer = params['buffer'] as List<double>;
  final sampleRate = params['sampleRate'] as int;
  final bufferSize = params['bufferSize'] as int;

  final detector = PitchDetector(
    audioSampleRate: sampleRate.toDouble(),
    bufferSize: bufferSize,
  );

  final result = await detector.getPitchFromFloatBuffer(buffer);

  return PitchResult(
    frequency: result.pitched ? result.pitch : 0,
    confidence: result.probability,
    timestamp: DateTime.now(),
  );
}

class AudioService {
  static const int sampleRate = 44100;
  static const int bufferSize = 2048;
  static const int _throttleMs = 50;

  final FlutterAudioCapture _audioCapture = FlutterAudioCapture();
  final StreamController<PitchResult> _pitchController =
      StreamController<PitchResult>.broadcast();

  bool _isCapturing = false;
  bool _initialized = false;
  bool _isProcessing = false;
  DateTime _lastEmit = DateTime(0);
  double? _minFreq;
  double? _maxFreq;
  double _confidenceThreshold = 0.5;

  Stream<PitchResult> get pitchStream => _pitchController.stream;
  bool get isCapturing => _isCapturing;

  Future<void> init() async {
    if (_initialized) return;

    final result = await _audioCapture.init();
    if (result != true) {
      throw AudioServiceException('Mikrofon başlatılamadı');
    }

    _initialized = true;
  }

  Future<void> startCapture({
    double? minFreq,
    double? maxFreq,
    double confidenceThreshold = 0.5,
  }) async {
    if (_isCapturing) return;
    if (!_initialized) await init();

    _minFreq = minFreq;
    _maxFreq = maxFreq;
    _confidenceThreshold = confidenceThreshold;
    _isCapturing = true;
    _isProcessing = false;
    _lastEmit = DateTime(0);

    await _audioCapture.start(
      _onAudioData,
      _onAudioError,
      sampleRate: sampleRate,
      bufferSize: bufferSize,
      androidAudioSource: ANDROID_AUDIOSRC_MIC,
    );
  }

  Future<void> stopCapture() async {
    if (!_isCapturing) return;
    _isCapturing = false;
    _isProcessing = false;
    await _audioCapture.stop();
  }

  void _onAudioData(Float32List buffer) {
    if (!_isCapturing) return;
    if (_isProcessing) return;
    if (buffer.length < bufferSize) return;

    final now = DateTime.now();
    if (now.difference(_lastEmit).inMilliseconds < _throttleMs) return;

    _isProcessing = true;

    // buffer.toList() burada gerekli: Float32List'i isolate'e göndermek için
    // standart List<double>'a çeviriyoruz
    compute(_detectPitch, {
      'buffer': buffer.toList(),
      'sampleRate': sampleRate,
      'bufferSize': bufferSize,
    }).then((result) {
      _isProcessing = false;
      if (!_isCapturing) return;

      // Confidence filtresi (enstrümana özel threshold)
      if (result.frequency > 0 && result.confidence < _confidenceThreshold) {
        _pitchController.add(PitchResult(
          frequency: 0,
          confidence: 0,
          timestamp: result.timestamp,
        ));
        return;
      }

      // Frekans aralığı filtresi
      if (result.frequency > 0) {
        if (_minFreq != null && result.frequency < _minFreq!) {
          _pitchController.add(PitchResult(
            frequency: 0,
            confidence: 0,
            timestamp: result.timestamp,
          ));
          return;
        }
        if (_maxFreq != null && result.frequency > _maxFreq!) {
          _pitchController.add(PitchResult(
            frequency: 0,
            confidence: 0,
            timestamp: result.timestamp,
          ));
          return;
        }
      }

      _lastEmit = DateTime.now();
      _pitchController.add(result);
    }).catchError((e) {
      _isProcessing = false;
    });
  }

  void _onAudioError(Object error) {
    if (!_isCapturing) return;
    _pitchController.addError(
      AudioServiceException('Ses yakalama hatası: $error'),
    );
  }

  Future<void> dispose() async {
    await stopCapture();
    await _pitchController.close();
    _initialized = false;
  }
}

class AudioServiceException implements Exception {
  final String message;
  const AudioServiceException(this.message);

  @override
  String toString() => 'AudioServiceException: $message';
}
