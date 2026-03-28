import 'dart:typed_data';

/// Sabit boyutlu dairesel buffer — audio sample biriktirmek icin.
///
/// Pre-allocated Float32List uzerinde calisir, gereksiz
/// kopyalama ve allocation yapmaz.
class RingBuffer {
  final Float32List _data;
  final int capacity;
  int _writePos = 0;
  int _available = 0;

  RingBuffer(this.capacity) : _data = Float32List(capacity);

  /// Buffer'daki mevcut sample sayisi.
  int get available => _available;

  /// Yeni veriyi buffer'a yazar.
  void write(Float32List input) {
    for (int i = 0; i < input.length; i++) {
      _data[_writePos] = input[i];
      _writePos = (_writePos + 1) % capacity;
    }
    _available += input.length;
    if (_available > capacity) _available = capacity;
  }

  /// Buffer'dan [count] sample okur ve yeni Float32List dondurur.
  ///
  /// Okunan sample'lar buffer'dan tuketilir.
  Float32List read(int count) {
    if (count > _available) {
      throw StateError('Not enough data: requested $count, available $_available');
    }

    final result = Float32List(count);
    final readPos = (_writePos - _available + capacity) % capacity;

    for (int i = 0; i < count; i++) {
      result[i] = _data[(readPos + i) % capacity];
    }

    _available -= count;
    return result;
  }

  /// Buffer'i sifirlar.
  void clear() {
    _writePos = 0;
    _available = 0;
  }
}
