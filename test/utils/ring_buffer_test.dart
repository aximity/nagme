import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:nagme/utils/ring_buffer.dart';

void main() {
  group('RingBuffer', () {
    test('bos buffer available=0', () {
      final rb = RingBuffer(1024);
      expect(rb.available, 0);
    });

    test('write sonrasi available artar', () {
      final rb = RingBuffer(1024);
      rb.write(Float32List(100));
      expect(rb.available, 100);
    });

    test('read dogru veriyi dondurur', () {
      final rb = RingBuffer(1024);
      final input = Float32List.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      rb.write(input);

      final output = rb.read(5);
      expect(output.length, 5);
      expect(output[0], 1.0);
      expect(output[4], 5.0);
      expect(rb.available, 0);
    });

    test('parcali write + tek read calısır', () {
      final rb = RingBuffer(1024);
      rb.write(Float32List.fromList([1.0, 2.0]));
      rb.write(Float32List.fromList([3.0, 4.0]));
      rb.write(Float32List.fromList([5.0]));

      final output = rb.read(5);
      expect(output[0], 1.0);
      expect(output[2], 3.0);
      expect(output[4], 5.0);
    });

    test('wrap-around dogru calısır', () {
      final rb = RingBuffer(4);
      rb.write(Float32List.fromList([1.0, 2.0, 3.0]));
      rb.read(2); // 1.0, 2.0 tuketildi

      rb.write(Float32List.fromList([4.0, 5.0])); // wrap olur
      final output = rb.read(3);
      expect(output[0], 3.0);
      expect(output[1], 4.0);
      expect(output[2], 5.0);
    });

    test('clear buffer sifirlar', () {
      final rb = RingBuffer(1024);
      rb.write(Float32List(500));
      rb.clear();
      expect(rb.available, 0);
    });

    test('yetersiz veri read StateError firlatir', () {
      final rb = RingBuffer(1024);
      rb.write(Float32List(10));
      expect(() => rb.read(20), throwsStateError);
    });

    test('audio boyutunda buffer calısır (4096 samples)', () {
      final rb = RingBuffer(8192);
      // Mikrofon parcalari simule et
      for (int i = 0; i < 8; i++) {
        rb.write(Float32List(512));
      }
      expect(rb.available, 4096);

      final buffer = rb.read(4096);
      expect(buffer.length, 4096);
      expect(rb.available, 0);
    });
  });
}
