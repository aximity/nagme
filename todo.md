# Nağme — Görev Listesi

> Her görev mini-brief: bağlam, dosyalar, test senaryoları dahil.
> Claude Code Kit (01-gorev-sablonu.md) formatıyla uyumlu.
> Son güncelleme: 2026-03-24

---

## FAZ A — Temel Tuner Çekirdeği (P0 — EN ÖNCELİKLİ)

Mikrofon → frekans → nota → ekrana yaz. Her şeyin temeli.

---

### [ ] A.1 — Proje iskeleti ve config

**Ne yapılacak:** Flutter projesi oluştur, klasör yapısını kur, tema/renkler/sabitler tanımla.

**Adımlar:**
1. `flutter create nagme` → proje oluştur
2. `pubspec.yaml` → riverpod, go_router, google_fonts, permission_handler ekle
3. `lib/config/theme.dart` → AppColors (stüdyo teması), AppTheme
4. `lib/config/constants.dart` → AppConstants (defaultRefHz: 440, tuneThreshold: 5, vb.)
5. `lib/config/routes.dart` → GoRouter (3 route: /, /instruments, /settings)
6. `lib/app.dart` → MaterialApp.router, tema, ProviderScope
7. Klasör yapısını oluştur (models/, services/, providers/, screens/, widgets/, utils/, core/)

**Dokunulacak dosyalar:**
- Tüm config dosyaları (yeni)
- `lib/main.dart`, `lib/app.dart`
- `pubspec.yaml`

**Test:** `flutter analyze` → 0 issue, `flutter run` → boş ekran tema ile açılıyor

---

### [ ] A.2 — Nota/frekans modelleri ve yardımcı fonksiyonlar

**Ne yapılacak:** Note, InstrumentTuning, TunerState modellerini ve frekans↔nota dönüşüm fonksiyonlarını yaz.

**Mevcut durum:** Henüz model yok.

**Beklenen davranış:**
1. `noteFromFrequency(440.0, refA4: 440)` → Note(name: "A", octave: 4, cents: 0.0)
2. `noteFromFrequency(445.0, refA4: 440)` → Note(name: "A", octave: 4, cents: +19.6)
3. `noteFromFrequency(430.0, refA4: 440)` → Note(name: "A", octave: 4, cents: -40.0)
4. `nearestString(442.0, violin)` → StringTuning(name: "A4", freq: 440.0)

**Dokunulacak dosyalar:**
- `lib/models/note.dart` (yeni)
- `lib/models/instrument.dart` (yeni)
- `lib/models/tuner_state.dart` (yeni)
- `lib/core/note_calculator.dart` (yeni)
- `lib/utils/note_utils.dart` (yeni)
- `lib/config/instruments.dart` (yeni — tüm enstrüman tanımları)

**Dokunma:** config/theme.dart, config/routes.dart — bunlar A.1'de bitti

**Test senaryoları:**
- A4=440Hz → "A4", 0 cents ✓
- A4=442Hz → "A4", +7.9 cents ✓
- 329.6Hz → "E4", ~0 cents ✓
- 82.4Hz → "E2", ~0 cents ✓ (bas gitar en kalın tel)
- 27.5Hz → "A0" (en düşük sınır)
- 4186Hz → "C8" (en yüksek sınır)
- refA4=432 ile 432Hz → "A4", 0 cents ✓
- nearestString: keman + 300Hz → D4 teli

**Test dosyası:** `test/core/note_calculator_test.dart`, `test/models/instrument_test.dart`

---

### [ ] A.3 — Pitch detection algoritması (YIN)

**Ne yapılacak:** YIN algoritmasını Dart'ta implement et, Isolate'te çalışacak şekilde.

**Mevcut durum:** Algoritma yok.

**Beklenen davranış:**
1. Float32 PCM buffer girer → frekans (Hz) çıkar
2. Sessizlik → -1 döner (sinyal yok)
3. UI thread bloklanmaz (Isolate)
4. 44100Hz sample rate, 4096 buffer size ile çalışır

**Dokunulacak dosyalar:**
- `lib/core/pitch_detector.dart` (yeni)
- `lib/utils/audio_utils.dart` (yeni — RMS hesaplama)

**Dokunma:** Model ve config dosyaları

**TEKNİK DETAYLAR:**
- YIN algoritması adımları: difference function → cumulative mean normalized → absolute threshold (0.15) → parabolic interpolation
- RMS eşik: 0.008 altı = sessizlik
- Isolate: `Isolate.spawn` + `SendPort`/`ReceivePort` veya `compute()`

**Test:** Sentetik sinüs dalgası (440Hz, 880Hz, 220Hz) üret, pitch detector'a ver, doğru frekans döndüğünü assert et.
**Test dosyası:** `test/core/pitch_detector_test.dart`

---

### [ ] A.4 — Mikrofon servisi (AudioService)

**Ne yapılacak:** Mikrofon stream'ini başlat/durdur, ham PCM verisini sağla.

**Mevcut durum:** Servis yok.

**Beklenen davranış:**
1. `audioService.start()` → mikrofon açılır, Float32 buffer stream'i başlar
2. `audioService.stop()` → mikrofon kapanır, stream durur
3. `audioService.isRecording` → true/false
4. İzin yoksa → hata fırlatır (exception, crash değil)

**Dokunulacak dosyalar:**
- `lib/services/audio_service.dart` (yeni)
- `android/app/src/main/AndroidManifest.xml` (RECORD_AUDIO izni)
- `ios/Runner/Info.plist` (NSMicrophoneUsageDescription)

**Dokunma:** Core ve model dosyaları

**Tuzak:** iOS'ta AVAudioSession category ayarlanmalı. Android 13+ mikrofon izni granüler.

---

### [ ] A.5 — PitchService (orkestratör) + TunerProvider

**Ne yapılacak:** AudioService + PitchDetector'ı birleştiren servis ve Riverpod provider.

**Beklenen davranış:**
1. Kullanıcı "Başlat" → tunerProvider mikrofonu açar
2. Her buffer geldiğinde → Isolate'te pitch detect → TunerState güncellenir
3. TunerState: { note: "A", octave: 4, frequency: 441.2, cents: +4.7, isInTune: true, closestString: "A4" }
4. Kullanıcı "Durdur" → mikrofon kapanır, state sıfırlanır

**Dokunulacak dosyalar:**
- `lib/services/pitch_service.dart` (yeni)
- `lib/providers/tuner_provider.dart` (yeni)
- `lib/providers/instrument_provider.dart` (yeni)
- `lib/providers/settings_provider.dart` (yeni)

**Dokunma:** AudioService ve PitchDetector (zaten tamamlanmış)

---

### [ ] A.6 — Ana tuner ekranı (temel UI)

**Ne yapılacak:** Tuner ekranının temel iskeletini oluştur — nota, Hz, sent göstergesi.

**Mevcut durum:** Ekran yok.

**Beklenen davranış:**
1. Ekran açılır → "Başlat" butonu görünür
2. Butona bas → mikrofon açılır, nota algılanır
3. Büyük nota harfi ortada (A, B, C#...), altında Hz
4. Sent göstergesi -50/+50 arası
5. ±5 cent içinde → amber/altın glow (akortlu)
6. Dışında → mercan kırmızı

**Dokunulacak dosyalar:**
- `lib/screens/tuner/tuner_screen.dart` (yeni)
- `lib/widgets/tuner/note_display.dart` (yeni)
- `lib/widgets/tuner/frequency_display.dart` (yeni)
- `lib/widgets/tuner/pitch_gauge.dart` (yeni — CustomPainter)
- `lib/widgets/tuner/needle_indicator.dart` (yeni — CustomPainter)
- `lib/widgets/tuner/tuning_status.dart` (yeni)

**Dokunma:** Servisler, modeller, provider'lar (bunlar bitti)

**TASARIM REFERANSI:** Stitch'ten export edilen HTML (docs/stitch-prompts.md'deki Ekran 1)

---

## FAZ B — Enstrüman Desteği (P1)

---

### [ ] B.1 — Enstrüman seçim ekranı

**Ne yapılacak:** Enstrüman seçim ekranı — grid layout, 9 enstrüman kartı.

**Beklenen davranış:**
1. Tuner ekranındaki enstrüman chip'ine tıkla → seçim ekranı açılır
2. 2 sütunlu grid: Keman, Gitar, Bas Gitar, Ukulele, Bağlama, Ud, Viyola, Çello, Kromatik
3. Seçili enstrümanın kartı amber kenarlı + tik işareti
4. "Onayla" → tuner ekranına dön, seçili enstrüman güncellenir
5. Seçim SharedPreferences'a kaydedilir

**Dokunulacak dosyalar:**
- `lib/screens/instruments/instrument_select_screen.dart` (yeni)
- `lib/widgets/common/instrument_card.dart` (yeni)

**TASARIM REFERANSI:** Stitch Ekran 2

---

### [ ] B.2 — Tel göstergesi (string indicator)

**Ne yapılacak:** Tuner ekranına enstrüman tellerini gösteren yatay gösterge ekle.

**Beklenen davranış:**
1. Keman seçili → 4 daire: G, D, A, E
2. Algılanan frekansa en yakın tel amber ile highlight
3. Kromatik modda → tel göstergesi gizli
4. Bir tele tıklayınca → o telin referans frekansı gösterilir

**Dokunulacak dosyalar:**
- `lib/widgets/tuner/string_indicator.dart` (yeni)
- `lib/screens/tuner/tuner_screen.dart` (string indicator ekle)

---

### [ ] B.3 — Waveform görselleştirme

**Ne yapılacak:** Audio buffer'ı dalga formu olarak çiz.

**Dokunulacak dosyalar:**
- `lib/widgets/tuner/waveform_painter.dart` (yeni — CustomPainter)
- `lib/screens/tuner/tuner_screen.dart` (waveform ekle)

**TEKNİK:** RepaintBoundary ile sar, her frame'de sadece waveform repaint olsun.

---

## FAZ C — Ayarlar + Polish (P2)

---

### [ ] C.1 — Ayarlar ekranı

**Ne yapılacak:** Referans Hz, hassasiyet, tema, notasyon ayarları.

**Dokunulacak dosyalar:**
- `lib/screens/settings/settings_screen.dart` (yeni)
- `lib/services/preferences_service.dart` (yeni)

**TASARIM REFERANSI:** Stitch Ekran 3

---

### [ ] C.2 — Ton üretici (referans ses)

**Ne yapılacak:** Bir tele tıklayınca o telin referans frekansını sinüs dalgası olarak çal.

**Beklenen davranış:**
1. String indicator'da "A4" teline uzun bas → 440Hz sinüs tonu çalar (1-2 sn)
2. Ses ayarlardan kapatılabilir
3. Tuner dinlerken referans ses çalınmaz (feedback loop)

**Dokunulacak dosyalar:**
- `lib/services/tone_generator.dart` (yeni)
- `lib/widgets/tuner/string_indicator.dart` (uzun basma eklenir)

---

### [ ] C.3 — Animasyon polish

**Ne yapılacak:** Gauge, needle ve nota geçişlerinde smooth animasyonlar.

**Detaylar:**
- Needle: `AnimatedBuilder` ile smooth hareket (spring physics)
- Nota değişimi: fade + scale transition
- Akortlu anı: amber pulse glow efekti
- Waveform: amber gradient line

---

## FAZ D — Yayın Hazırlığı (P3)

---

### [ ] D.1 — App ikonları ve splash screen

### [ ] D.2 — Play Store listing hazırla (ekran görüntüleri, açıklama)

### [ ] D.3 — App Store listing hazırla

### [ ] D.4 — Release build + smoke test (Android + iOS)

---

## İLERLEME TAKİBİ

| Faz | Görev | Durum | Tarih |
|-----|-------|-------|-------|
| A | A.1 Proje iskeleti | [x] | 2026-03-26 |
| A | A.2 Modeller + nota hesaplama | [x] | 2026-03-26 |
| A | A.3 Pitch detection (YIN) | [x] | 2026-03-26 |
| A | A.4 Mikrofon servisi | [x] | 2026-03-26 |
| A | A.5 PitchService + Provider | [x] | 2026-03-26 |
| A | A.6 Ana tuner ekranı | [x] | 2026-03-26 |
| B | B.1 Enstrüman seçim ekranı | [x] | 2026-03-26 |
| B | B.2 Tel göstergesi | [x] | 2026-03-26 |
| B | B.3 Waveform | [x] | 2026-03-26 |
| C | C.1 Ayarlar ekranı | [x] | 2026-03-26 |
| C | C.2 Ton üretici | [x] | 2026-03-26 |
| C | C.3 Animasyon polish | [x] | 2026-03-26 |
| D | D.1 İkonlar + splash | [x] | 2026-03-26 |
| D | D.2 Play Store | [x] | 2026-03-26 |
| D | D.3 App Store | [x] | 2026-03-26 |
| D | D.4 Release build | [x] | 2026-03-26 |
