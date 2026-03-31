import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nagme/config/constants.dart';

class MicrophonePermissionDeniedException implements Exception {
  const MicrophonePermissionDeniedException([this.message = 'Mikrofon izni reddedildi.']);
  final String message;

  @override
  String toString() => 'MicrophonePermissionDeniedException: $message';
}

class AudioService {
  AudioService() : _plugin = FlutterAudioCapture();

  final FlutterAudioCapture _plugin;
  final _controller = StreamController<Float32List>.broadcast();
  bool _isRecording = false;

  Stream<Float32List> get bufferStream => _controller.stream;
  bool get isRecording => _isRecording;

  Future<void> start() async {
    if (_isRecording) return;

    // İzin kontrolü
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw const MicrophonePermissionDeniedException();
    }

    await _plugin.start(
      _onBuffer,
      _onError,
      sampleRate: AppConstants.sampleRate,
      bufferSize: AppConstants.bufferSize,
    );
    _isRecording = true;
  }

  Future<void> stop() async {
    if (!_isRecording) return;
    await _plugin.stop();
    _isRecording = false;
  }

  void _onBuffer(dynamic samples) {
    if (samples is List<double>) {
      _controller.add(Float32List.fromList(samples.cast<double>()));
    } else if (samples is Float32List) {
      _controller.add(samples);
    }
  }

  void _onError(Object error) {
    _controller.addError(error);
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
