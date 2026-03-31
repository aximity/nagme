import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

/// Belirtilen frekansta sinüs dalgası üretip çalan servis.
/// WAV verisini bellekte üretir — disk I/O yok.
class ToneGenerator {
  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  /// [frequency] Hz cinsinden — örn. 440.0 (A4)
  /// [durationMs] çalış süresi milisaniye cinsinden (varsayılan 1500ms)
  Future<void> playTone(double frequency, {int durationMs = 1500}) async {
    if (_isPlaying) await stop();

    final bytes = _buildWav(frequency, durationMs);
    _isPlaying = true;

    await _player.play(BytesSource(bytes));

    // Ses bitince bayrağı sıfırla
    _player.onPlayerComplete.first.then((_) => _isPlaying = false);
  }

  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

  // ─────────────────────────────────────────────
  // WAV oluşturma (PCM 16-bit mono, 44100 Hz)
  // ─────────────────────────────────────────────

  static const int _sampleRate = 44100;
  static const double _amplitude = 0.55; // %55 — çok yüksek olmayan referans ses

  Uint8List _buildWav(double frequency, int durationMs) {
    final numSamples = (_sampleRate * durationMs / 1000).round();
    final dataSize = numSamples * 2; // 16-bit = 2 bayt/örnek

    final bd = ByteData(44 + dataSize);

    // RIFF header
    _writeStr(bd, 0, 'RIFF');
    bd.setUint32(4, 36 + dataSize, Endian.little);
    _writeStr(bd, 8, 'WAVE');

    // fmt  chunk
    _writeStr(bd, 12, 'fmt ');
    bd.setUint32(16, 16, Endian.little); // PCM chunk boyutu
    bd.setUint16(20, 1, Endian.little);  // PCM format
    bd.setUint16(22, 1, Endian.little);  // mono
    bd.setUint32(24, _sampleRate, Endian.little);
    bd.setUint32(28, _sampleRate * 2, Endian.little); // byte rate
    bd.setUint16(32, 2, Endian.little);  // block align
    bd.setUint16(34, 16, Endian.little); // bits per sample

    // data chunk
    _writeStr(bd, 36, 'data');
    bd.setUint32(40, dataSize, Endian.little);

    // PCM örnekleri — fade-in/out ile sinüs
    final fadeSamples = (_sampleRate * 0.04).round(); // 40ms fade

    for (int i = 0; i < numSamples; i++) {
      final t = i / _sampleRate;
      double s = sin(2 * pi * frequency * t) * _amplitude;

      if (i < fadeSamples) s *= i / fadeSamples;
      if (i > numSamples - fadeSamples) s *= (numSamples - i) / fadeSamples;

      final int16 = (s * 32767).round().clamp(-32768, 32767);
      bd.setInt16(44 + i * 2, int16, Endian.little);
    }

    return bd.buffer.asUint8List();
  }

  void _writeStr(ByteData bd, int offset, String s) {
    for (int i = 0; i < s.length; i++) {
      bd.setUint8(offset + i, s.codeUnitAt(i));
    }
  }
}
