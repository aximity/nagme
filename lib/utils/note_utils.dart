/// Nota adını Türkçe gösterime dönüştürür.
String noteNameTurkish(String name) {
  const map = {
    'C': 'Do',
    'C#': 'Do#',
    'D': 'Re',
    'D#': 'Re#',
    'E': 'Mi',
    'F': 'Fa',
    'F#': 'Fa#',
    'G': 'Sol',
    'G#': 'Sol#',
    'A': 'La',
    'A#': 'La#',
    'B': 'Si',
  };
  return map[name] ?? name;
}

/// Cent değerini formatlı stringe dönüştürür.
/// Örnek: +4.7, -12.3, 0.0
String formatCents(double cents) {
  if (cents >= 0) {
    return '+${cents.toStringAsFixed(1)}';
  }
  return cents.toStringAsFixed(1);
}

/// Frekansı formatlı stringe dönüştürür.
/// Örnek: 440.0 Hz
String formatFrequency(double frequency) {
  return '${frequency.toStringAsFixed(1)} Hz';
}
