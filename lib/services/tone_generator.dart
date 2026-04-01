import 'dart:math';
import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';

import '../models/tuner_state.dart';

class ToneGenerator {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  double _currentFrequency = 0;
  SoundType _currentType = SoundType.sine;

  bool get isPlaying => _isPlaying;

  Future<void> play(double frequency, SoundType type) async {
    if (_isPlaying &&
        (_currentFrequency - frequency).abs() < 0.01 &&
        _currentType == type) {
      return;
    }

    await stop();

    _currentFrequency = frequency;
    _currentType = type;

    final wavBytes = _generateWav(frequency, type);
    final source = _WavAudioSource(wavBytes);

    await _player.setAudioSource(source);
    await _player.setLoopMode(LoopMode.one);
    await _player.setVolume(0.5);
    await _player.play();
    _isPlaying = true;
  }

  Future<void> stop() async {
    if (!_isPlaying) return;
    _isPlaying = false;
    await _player.stop();
  }

  Future<void> dispose() async {
    await stop();
    await _player.dispose();
  }

  /// 1 saniyelik WAV dosyası üretir (44100 Hz, 16-bit mono)
  Uint8List _generateWav(double frequency, SoundType type) {
    const sampleRate = 44100;
    const duration = 1; // saniye
    const numSamples = sampleRate * duration;
    const bitsPerSample = 16;
    const numChannels = 1;
    const byteRate = sampleRate * numChannels * bitsPerSample ~/ 8;
    const blockAlign = numChannels * bitsPerSample ~/ 8;
    const dataSize = numSamples * blockAlign;
    const fileSize = 36 + dataSize;

    final buffer = ByteData(44 + dataSize);
    var offset = 0;

    // RIFF header
    void writeString(String s) {
      for (var i = 0; i < s.length; i++) {
        buffer.setUint8(offset++, s.codeUnitAt(i));
      }
    }

    writeString('RIFF');
    buffer.setUint32(offset, fileSize, Endian.little);
    offset += 4;
    writeString('WAVE');

    // fmt chunk
    writeString('fmt ');
    buffer.setUint32(offset, 16, Endian.little);
    offset += 4;
    buffer.setUint16(offset, 1, Endian.little);
    offset += 2; // PCM
    buffer.setUint16(offset, numChannels, Endian.little);
    offset += 2;
    buffer.setUint32(offset, sampleRate, Endian.little);
    offset += 4;
    buffer.setUint32(offset, byteRate, Endian.little);
    offset += 4;
    buffer.setUint16(offset, blockAlign, Endian.little);
    offset += 2;
    buffer.setUint16(offset, bitsPerSample, Endian.little);
    offset += 2;

    // data chunk
    writeString('data');
    buffer.setUint32(offset, dataSize, Endian.little);
    offset += 4;

    // Generate samples
    for (var i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      double sample;

      switch (type) {
        case SoundType.sine:
          sample = sin(2 * pi * frequency * t);
        case SoundType.square:
          sample = sin(2 * pi * frequency * t) >= 0 ? 1.0 : -1.0;
        case SoundType.triangle:
          final phase = (frequency * t) % 1.0;
          sample = 4 * (phase < 0.5 ? phase : 1.0 - phase) - 1.0;
      }

      // Fade in/out to avoid clicks (10ms)
      const fadeLen = sampleRate * 0.01;
      if (i < fadeLen) {
        sample *= i / fadeLen;
      } else if (i > numSamples - fadeLen) {
        sample *= (numSamples - i) / fadeLen;
      }

      final intSample = (sample * 32767 * 0.7).round().clamp(-32768, 32767);
      buffer.setInt16(offset, intSample, Endian.little);
      offset += 2;
    }

    return buffer.buffer.asUint8List();
  }
}

class _WavAudioSource extends StreamAudioSource {
  final Uint8List _wavBytes;

  _WavAudioSource(this._wavBytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final s = start ?? 0;
    final e = end ?? _wavBytes.length;
    return StreamAudioResponse(
      sourceLength: _wavBytes.length,
      contentLength: e - s,
      offset: s,
      stream: Stream.value(_wavBytes.sublist(s, e)),
      contentType: 'audio/wav',
    );
  }
}
