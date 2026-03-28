// ignore_for_file: experimental_member_use
import 'dart:math';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';

/// Dalga formu tipleri.
enum WaveForm {
  /// Saf sinus dalgasi.
  sine,

  /// Harmonik zengin — enstrumana yakin sicak ton.
  warm,

  /// Parlak — daha fazla harmonik, gitar benzeri.
  bright,
}

/// Referans ton uretici — farkli dalga formlari destekler.
class ToneGenerator {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  WaveForm waveForm = WaveForm.warm;

  bool get isPlaying => _isPlaying;

  /// Belirli frekansta referans ton cal.
  Future<void> play(double frequency, {int durationMs = 1500}) async {
    if (_isPlaying) await stop();
    _isPlaying = true;

    try {
      final wavBytes = _generateWav(
        frequency: frequency,
        durationMs: durationMs,
        waveForm: waveForm,
      );

      final source = _WavAudioSource(wavBytes);
      await _player.setAudioSource(source);
      await _player.play();

      // Calma bitince state guncelle
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

  /// WAV dosyasi (byte array) uretir.
  Uint8List _generateWav({
    required double frequency,
    int durationMs = 1500,
    int sampleRate = 44100,
    double amplitude = 0.3,
    WaveForm waveForm = WaveForm.warm,
  }) {
    final sampleCount = (sampleRate * durationMs / 1000).toInt();
    final fadeInLength = (sampleRate * 0.03).toInt(); // 30ms fade-in
    final fadeOutLength = (sampleRate * 0.08).toInt(); // 80ms fade-out
    final dataSize = sampleCount * 2;
    final fileSize = 44 + dataSize;

    final buffer = ByteData(fileSize);

    // WAV header
    _writeWavHeader(buffer, fileSize, dataSize, sampleRate);

    // PCM data
    final nyquist = sampleRate / 2.0;
    for (int i = 0; i < sampleCount; i++) {
      final t = i / sampleRate;
      double sample = _synthesize(frequency, t, waveForm, nyquist);
      sample *= amplitude;

      // Fade-in (cosine curve — yumusak baslangic)
      if (i < fadeInLength) {
        final fade = 0.5 * (1.0 - cos(pi * i / fadeInLength));
        sample *= fade;
      }
      // Fade-out (cosine curve — yumusak bitis)
      if (i > sampleCount - fadeOutLength) {
        final remaining = sampleCount - i;
        final fade = 0.5 * (1.0 - cos(pi * remaining / fadeOutLength));
        sample *= fade;
      }

      final int16 = (sample * 32767).round().clamp(-32768, 32767);
      buffer.setInt16(44 + i * 2, int16, Endian.little);
    }

    return buffer.buffer.asUint8List();
  }

  /// Dalga formu sentezi.
  double _synthesize(
      double freq, double t, WaveForm waveForm, double nyquist) {
    switch (waveForm) {
      case WaveForm.sine:
        return sin(2.0 * pi * freq * t);

      case WaveForm.warm:
        // Temel + 3 harmonik, azalan genliklerle — sicak, dolu ton
        double s = sin(2.0 * pi * freq * t);
        if (freq * 2 < nyquist) s += 0.5 * sin(2.0 * pi * freq * 2 * t);
        if (freq * 3 < nyquist) s += 0.25 * sin(2.0 * pi * freq * 3 * t);
        if (freq * 4 < nyquist) s += 0.125 * sin(2.0 * pi * freq * 4 * t);
        return s / 1.875; // normalize

      case WaveForm.bright:
        // Daha fazla harmonik — parlak, testere benzeri
        double s = 0.0;
        double norm = 0.0;
        for (int h = 1; h <= 8; h++) {
          if (freq * h >= nyquist) break;
          final amp = 1.0 / h;
          s += amp * sin(2.0 * pi * freq * h * t);
          norm += amp;
        }
        return norm > 0 ? s / norm : 0.0;
    }
  }

  void _writeWavHeader(ByteData buffer, int fileSize, int dataSize, int sr) {
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
    buffer.setUint32(16, 16, Endian.little);
    buffer.setUint16(20, 1, Endian.little); // PCM
    buffer.setUint16(22, 1, Endian.little); // mono
    buffer.setUint32(24, sr, Endian.little);
    buffer.setUint32(28, sr * 2, Endian.little);
    buffer.setUint16(32, 2, Endian.little);
    buffer.setUint16(34, 16, Endian.little);
    // "data"
    buffer.setUint8(36, 0x64); buffer.setUint8(37, 0x61);
    buffer.setUint8(38, 0x74); buffer.setUint8(39, 0x61);
    buffer.setUint32(40, dataSize, Endian.little);
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
