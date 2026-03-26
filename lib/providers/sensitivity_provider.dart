import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hassasiyet seviyesi: 0.0 (çok hassas) — 1.0 (toleranslı).
/// Güven eşiğini ve noise gate'i etkiler.
final sensitivityProvider = StateProvider<double>((ref) => 0.5);
