# Nağme — Görev Listesi

> Claude Code otonom çalışma için bu dosyayı referans alır.
> Tamamlanan görevler [x] ile işaretlenir.
> Son güncelleme: 2026-03-28

---

## Faz A — Temel Tuner (TAMAMLANDI)

- [x] A.1 — Proje iskeleti ve config
- [x] A.2 — Nota/frekans modelleri + testler
- [x] A.3 — YIN pitch detection algoritması + testler
- [x] A.4 — Mikrofon servisi (AudioService)
- [x] A.5 — PitchService + TunerProvider
- [x] A.6 — Ana tuner ekranı UI
- [x] A.7 — Enstrüman seçim ekranı + tel göstergesi
- [x] A.8 — Ayarlar ekranı + ton üretici

## Faz B — Premium UI (TAMAMLANDI)

- [x] B.1 — Tema sistemi (renkler, gradyanlar, gölgeler)
- [x] B.2 — Spring physics gauge redesign
- [x] B.3 — Mikrofon butonu breathing glow + haptic feedback
- [x] B.4 — Sayfa geçiş animasyonları
- [x] B.5 — Stitch enstrüman ikonları entegrasyonu (emoji → asset)
- [x] B.6 — App icon + splash + feature graphic

## Faz C — Performans & Kararlılık

- [x] C.1 — Pitch detection'ı Isolate'e taşı
  **Ne:** UI thread bloklamadan ses işleme. compute() veya custom Isolate.
  **Dosyalar:** lib/core/pitch_detector.dart, lib/services/pitch_service.dart
  **Test:** 60fps korunmalı, flutter run --profile ile jank kontrolü.

- [x] C.2 — Seamless enstrüman geçişi
  **Ne:** Enstrüman değiştiğinde mikrofon stream kesilmeden yeni ayarlarla devam.
  **Dosyalar:** lib/providers/tuner_provider.dart, lib/services/pitch_service.dart
  **Not:** PitchService.updateConfig() ile mikrofon kesmeden isolate hot-swap.

- [x] C.3 — Ring buffer + bellek optimizasyonu
  **Ne:** Audio buffer'ların gereksiz kopyalanmasını önle.
  **Dosyalar:** lib/utils/ring_buffer.dart, lib/services/pitch_service.dart
  **Test:** 8 unit test, wrap-around ve audio boyutu dogrulanmis.

- [x] C.4 — App lifecycle yönetimi
  **Ne:** Arka plana alındığında mikrofonu durdur, geri gelince başlat.
  **Dosyalar:** lib/screens/tuner/tuner_screen.dart (WidgetsBindingObserver)
  **Test:** Uygulamayı arka plana al → mikrofon kapansın, geri gel → otomatik başlasın.

## Faz D — Özellik Genişletme

- [x] D.1 — Alternatif akort sistemleri
  **Ne:** Drop D, Open G, DADGAD, Half Step Down, Bağlama düzenleri vb.
  **Dosyalar:** lib/config/instruments.dart, lib/screens/instruments/instrument_select_screen.dart
  **Not:** tuningName field + bottom sheet akort duzeni secici.

- [x] D.2 — Akort oturumu geçmişi
  **Ne:** Son 20 akort oturumunu kaydet (tarih, enstrüman, süre, sonuç).
  **Dosyalar:** lib/models/tuning_session.dart, lib/services/preferences_service.dart
  **Test:** 6 unit test (serialization, round-trip, edge cases).

- [x] D.3 — Gelişmiş ton üretici
  **Ne:** 3 dalga formu: sine, warm (4 harmonik), bright (8 harmonik).
  **Dosyalar:** lib/services/tone_generator.dart
  **Not:** Cosine fade-in/out, Nyquist koruması, WaveForm enum.

- [x] D.4 — Açık tema seçeneği
  **Ne:** Koyu + açık tema. themeModeProvider + SharedPreferences.
  **Dosyalar:** lib/config/theme.dart, lib/providers/settings_provider.dart, lib/app.dart

- [x] D.5 — Çoklu dil desteği (i18n)
  **Ne:** Türkçe + İngilizce. flutter_localizations + ARB dosyaları.
  **Dosyalar:** lib/l10n/app_tr.arb, lib/l10n/app_en.arb, l10n.yaml, pubspec.yaml

## Faz E — Store Yayını

- [x] E.1 — Play Store listing hazırlığı
  **Ne:** Açıklama, ekran görüntüleri. Feature graphic hazır (assets/icon/).
  **Not:** store/play_store/ altinda TR+EN listing dosyalari.

- [x] E.2 — Release build + imzalama
  **Ne:** build.gradle.kts release signing, key.properties sablonu.
  **Dosyalar:** android/app/build.gradle.kts, android/key.properties.example

- [x] E.3 — ProGuard / R8 kuralları
  **Ne:** proguard-rules.pro, minify + shrink aktif.
  **Dosyalar:** android/app/proguard-rules.pro

- [ ] E.4 — iOS build hazırlığı (opsiyonel — Mac gerekli)

---

## İLERLEME

| Faz | Toplam | Tamamlanan | Durum |
|-----|--------|------------|-------|
| A   | 8      | 8          | TAMAM |
| B   | 6      | 6          | TAMAM |
| C   | 4      | 4          | TAMAM |
| D   | 5      | 5          | TAMAM |
| E   | 4      | 3          | Sırada |

**Sıradaki:** C.1 → Isolate pitch detection
