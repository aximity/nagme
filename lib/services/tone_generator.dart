// ignore_for_file: experimental_member_use
import 'dart:math';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';

/// Sinüs tonu üretici — referans ses çalmak için.
class ToneGenerator {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  /// Belirli frekansta referans ton çal.
  Future<void> play(double frequency, {int durationMs = 1500}) async {
    if (_isPlaying) await stop();
    _isPlaying = true;

    try {
      final wavBytes = _generateWav(
        frequency: frequency,
        durationMs: durationMs,
      );

      final source = _WavAudioSource(wavBytes);
      await _player.setAudioSource(source);
      await _player.play();

      // Çalma bitince state güncelle
      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
        }
      });
    } catch (_) {
      _isPlaying = false;
    }
  }

  /// Durdur.
  Future<void> stop() async {
    _isPlaying = false;
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }

  /// WAV dosyası (byte array) üretir.
  Uint8List _generateWav({
    required double frequency,
    int durationMs = 1500,
    int sampleRate = 44100,
    double amplitude = 0.3,
  }) {
    final sampleCount = (sampleRate * durationMs / 1000).toInt();
    final fadeLength = (sampleRate * 0.02).toInt();
    final dataSize = sampleCount * 2; // 16-bit = 2 bytes per sample
    final fileSize = 44 + dataSize;

    final buffer = ByteData(fileSize);

    // WAV header
    // "RIFF"
    buffer.setUint8(0, 0x52); buffer.setUint8(1, 0x49);
    buffer.setUint8(2, 0x46); buffer.setUint8(3, 0x46);
    buffer.setUint32(4, fileSize - 8, Endian.little);
    // "WAVE"
    buffer.setUint8(8, 0x57); buffer.setUint8(9, 0x41);
    buffer.setUint8(10, 0x56); buffer.setUint8(11, 0x45);
    // "fmt "
    buffer.setUint8(12, 0x66); buffer.setUint8(13, 0x6D);
    buffer.setUint8(14, 0x74); buffer.setUint8(15, 0x20);
    buffer.setUint32(16, 16, Endian.little); // chunk size
    buffer.setUint16(20, 1, Endian.little); // PCM
    buffer.setUint16(22, 1, Endian.little); // mono
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, sampleRate * 2, Endian.little); // byte rate
    buffer.setUint16(32, 2, Endian.little); // block align
    buffer.setUint16(34, 16, Endian.little); // bits per sample
    // "data"
    buffer.setUint8(36, 0x64); buffer.setUint8(37, 0x61);
    buffer.setUint8(38, 0x74); buffer.setUint8(39, 0x61);
    buffer.setUint32(40, dataSize, Endian.little);

    // PCM data
    for (int i = 0; i < sampleCount; i++) {
      double sample = amplitude * sin(2.0 * pi * frequency * i / sampleRate);

      // Fade-in/out
      if (i < fadeLength) sample *= i / fadeLength;
      if (i > sampleCount - fadeLength) {
        sample *= (sampleCount - i) / fadeLength;
      }

      final int16 = (sample * 32767).round().clamp(-32768, 32767);
      buffer.setInt16(44 + i * 2, int16, Endian.little);
    }

    return buffer.buffer.asUint8List();
  }
}

/// In-memory WAV audio source for just_audio.
class _WavAudioSource extends StreamAudioSource {
  final Uint8List _data;

  _WavAudioSource(this._data);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _data.length;
    return StreamAudioResponse(
      sourceLength: _data.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_data.sublist(start, end)),
      contentType: 'audio/wav',
    );
  }
}
