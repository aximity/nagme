import 'dart:math';

/// Akort temperament (dizge) sistemleri.
enum Temperament {
  /// 12-TET. Gitar, piyano, fretli enstrümanlar.
  equal,

  /// Pisagor saf beşli (3:2). Keman, viyola, çello.
  pythagorean,
}

/// Temperament'e göre tel frekanslarını hesaplar.
class TemperamentCalculator {
  /// Keman: G3-D4-A4-E5
  static List<double> violin(double refA4, Temperament t) {
    return switch (t) {
      Temperament.pythagorean => [
          refA4 / 1.5 / 1.5, // G3 = 195.556
          refA4 / 1.5, // D4 = 293.333
          refA4, // A4 = 440.000
          refA4 * 1.5, // E5 = 660.000
        ],
      Temperament.equal => [
          refA4 * pow(2, -14 / 12), // G3 = 195.998
          refA4 * pow(2, -7 / 12), // D4 = 293.665
          refA4, // A4 = 440.000
          refA4 * pow(2, 7 / 12), // E5 = 659.255
        ],
    };
  }

  /// Viyola: C3-G3-D4-A4
  static List<double> viola(double refA4, Temperament t) {
    return switch (t) {
      Temperament.pythagorean => [
          refA4 / 1.5 / 1.5 / 1.5, // C3
          refA4 / 1.5 / 1.5, // G3
          refA4 / 1.5, // D4
          refA4, // A4
        ],
      Temperament.equal => [
          refA4 * pow(2, -21 / 12),
          refA4 * pow(2, -14 / 12),
          refA4 * pow(2, -7 / 12),
          refA4,
        ],
    };
  }

  /// Çello: C2-G2-D3-A3
  static List<double> cello(double refA4, Temperament t) {
    final a3 = refA4 / 2;
    return switch (t) {
      Temperament.pythagorean => [
          a3 / 1.5 / 1.5 / 1.5,
          a3 / 1.5 / 1.5,
          a3 / 1.5,
          a3,
        ],
      Temperament.equal => [
          a3 * pow(2, -21 / 12),
          a3 * pow(2, -14 / 12),
          a3 * pow(2, -7 / 12),
          a3,
        ],
    };
  }
}
