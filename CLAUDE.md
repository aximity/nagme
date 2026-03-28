# Nağme — Claude Code Kuralları

> Bu dosya projenin kök dizininde durur. Claude Code her oturumda bunu okur.

---

## Proje Özeti

Nağme — Profesyonel kromatik tuner ve enstrüman akort uygulaması. Mikrofon frekans analizi ile çalınan notayı tespit eder, sent (cents) hassasiyetiyle akort durumunu gösterir. Keman, gitar, bağlama, ud ve daha fazla enstrüman desteği. Tamamen çevrimdışı çalışır, internet gerektirmez. Türkiye pazarı öncelikli, Türkçe + İngilizce.

## Stack

- **Framework:** Flutter 3.29+ (Dart 3.7+)
- **State:** Riverpod 2.x
- **Ses İşleme:** flutter_audio_capture (mikrofon raw PCM stream)
- **DSP:** Dart FFI + C/C++ (pitch detection algoritması — autocorrelation/YIN)
- **UI:** Custom painters (gauge, waveform, needle), Rive veya Lottie (animasyonlar)
- **Depolama:** SharedPreferences (kullanıcı tercihleri: referans Hz, tema, son enstrüman)
- **Font:** Google Fonts (Outfit + JetBrains Mono)
- **Platform:** Android + iOS (aynı anda)
- **İnternet:** Gerektirmez — tamamen offline

## Proje Yolu

```
C:\Users\stare\Desktop\nagme
```

## Komutlar

```bash
flutter analyze              # Lint — 0 issue olmalı
flutter test                 # Unit testler
flutter build apk --release  # Android APK
flutter build ios --release  # iOS build (Mac gerekli)
flutter run -d <device_id>   # Cihazda çalıştır
flutter pub get              # Bağımlılıkları yükle
```

---

## MİMARİ KURALLAR

### State Management

1. **Uygulama state'i Riverpod ile.** Audio stream → `StreamProvider`, tuner state → `StateNotifierProvider`, ayarlar → `Provider`.
2. **Lokal UI state (animasyon, modal) → StatefulWidget.** İş mantığı widget'ta OLMAMALI.
3. **Yeni özellik → ilgili provider dosyasını da oluştur.**

### Ses İşleme (Kritik Katman)

4. **Mikrofon erişimi → tek bir AudioService üzerinden.** Widget'tan doğrudan mikrofon çağırma.
5. **Pitch detection → ayrı Isolate'te çalışmalı.** UI thread'i bloklamak YASAK.
6. **Algoritma:** YIN veya Autocorrelation (normalized). Parabolic interpolation ile sub-sample hassasiyet.
7. **Sample rate:** 44100 Hz, buffer size: 4096 (iyi frekans çözünürlüğü için).
8. **Frekans aralığı:** 27.5 Hz (A0) — 4186 Hz (C8). Pratik kullanım: 55 Hz — 2000 Hz.

### Enstrüman Sistemi

9. **Her enstrüman bir `InstrumentTuning` model'i.** İsim, tel sayısı, her telin standart frekansı ve nota adı.
10. **Enstrümanlar `instruments.dart` config dosyasında tanımlı.** Hardcoded JSON değil, Dart const.
11. **Yeni enstrüman eklemek = sadece listeye yeni entry eklemek.** Kod değişikliği gerektirmemeli.

### UI Kuralları

12. **Renk sabitleri `AppColors`'da (theme.dart).** Hardcoded `Color(0xFF...)` YASAK.
13. **Padding/spacing sabitleri `AppConstants`'ta.**
14. **Font:** `Outfit` (başlıklar, genel), `JetBrains Mono` (frekans, Hz değerleri, teknik).
15. **Widget 100 satırı geçerse → alt widget'a parçala.**
16. **Gauge ve needle → CustomPainter ile çiz.** Hazır gauge paketi kullanma.
17. **Waveform → CustomPainter, performans için RepaintBoundary ile sar.**

### Dosya Yapısı

```
lib/
├── main.dart
├── app.dart
├── config/
│   ├── constants.dart       # AppConstants, varsayılan değerler
│   ├── routes.dart          # GoRouter (basit — 2-3 ekran)
│   ├── theme.dart           # AppColors, AppTheme
│   └── instruments.dart     # Tüm enstrüman tuning tanımları
├── core/
│   └── pitch_detector.dart  # YIN/Autocorrelation algoritması
├── models/
│   ├── note.dart            # Note (name, octave, frequency, cents)
│   ├── instrument.dart      # InstrumentTuning, StringTuning
│   └── tuner_state.dart     # TunerState (currentNote, cents, freq, isInTune)
├── services/
│   ├── audio_service.dart   # Mikrofon stream yönetimi
│   └── preferences_service.dart  # SharedPreferences wrapper
├── providers/
│   ├── tuner_provider.dart  # Ana tuner state + pitch detection
│   ├── instrument_provider.dart  # Seçili enstrüman
│   └── settings_provider.dart    # Referans Hz, hassasiyet
├── screens/
│   ├── tuner/
│   │   └── tuner_screen.dart     # Ana tuner ekranı
│   ├── instruments/
│   │   └── instrument_select_screen.dart  # Enstrüman seçim
│   └── settings/
│       └── settings_screen.dart  # Ayarlar ekranı
├── widgets/
│   ├── tuner/
│   │   ├── pitch_gauge.dart      # Dairesel veya lineer sent göstergesi
│   │   ├── needle_indicator.dart # İbre animasyonu
│   │   ├── note_display.dart     # Büyük nota gösterimi
│   │   ├── frequency_display.dart # Hz gösterimi
│   │   ├── waveform_painter.dart # Dalga formu
│   │   ├── string_indicator.dart # Enstrüman tel gösterimi
│   │   └── tuning_status.dart    # Akortlu/değil durumu
│   └── common/
│       ├── app_button.dart
│       └── instrument_card.dart
└── utils/
    ├── note_utils.dart      # Frekans → nota dönüşümü, cent hesaplama
    └── audio_utils.dart     # Buffer işleme yardımcıları
```

---

## DOSYA DEĞİŞTİRME KURALLARI

### Dokunmadan önce

1. Dosyanın tamamını oku
2. Import chain'i kontrol et
3. İlgili test dosyası varsa onu da oku

### Değişiklik sonrası

1. `flutter analyze` → 0 issue
2. `flutter test` → tüm testler geçmeli
3. Değiştirilen widget → cihazda ses ile test et (otomatik test yetersiz)

### Yeni dosya eklerken

- **Yeni model:** `lib/models/` + test `test/models/`
- **Yeni servis:** `lib/services/` + constructor injection
- **Yeni ekran:** `lib/screens/<alan>/` + route'a ekle
- **Yeni widget:** `lib/widgets/tuner/` veya `lib/widgets/common/`
- **Yeni provider:** `lib/providers/`
- **Yeni enstrüman:** `lib/config/instruments.dart`'a ekle (sadece data)

---

## BİLİNEN TUZAKLAR

| Tuzak | Açıklama | Çözüm |
|-------|----------|-------|
| Mikrofon izni | Android 13+ ve iOS farklı izin akışları | permission_handler paketi, info.plist + AndroidManifest |
| iOS ses oturumu | iOS'ta ses kaydı için AVAudioSession ayarı lazım | Audio session category doğru set edilmeli |
| Düşük frekans algılama | Bas teller (<80Hz) için buffer büyük olmalı | Buffer 4096+, belki 8192 |
| Gürültülü ortam | Arka plan gürültüsü yanlış nota algılatır | RMS eşik değeri + gürültü gate |
| UI jank | Pitch detection ana thread'de → kasma | Isolate'te çalıştır |
| Platform farkları | Android ve iOS mikrofon API'leri farklı davranır | Her platformda ayrı test |

---

## MEVCUT PROJE DURUMU

### Tamamlanan
- P0: Temel kromatik tuner (mikrofon → frekans → nota → gauge)
- P1: Enstrümana özel tuning modu (8 enstrüman + kromatik)
- P2: Premium UI redesign (spring gauge, haptic, glassmorphic, sayfa geçişleri)
- Stitch enstrüman ikonları entegrasyonu (emoji → asset)
- Akort değişikliklerinin anlık yansıması (provider listen)
- Gecikme optimizasyonu (hold time, stability, accumulator)
- Harmonik düzeltme iyileştirmesi

### Aktif Öncelik
- **P3:** App Store / Play Store yayını
- **P4:** Pitch detection'ı Isolate'e taşı (UI jank önleme)
- **P5:** Alternatif akort sistemleri (drop D, open G, vb.)
- **P6:** Ton üretici iyileştirmeleri

---

## ENSTRÜMAN LİSTESİ (v1.0)

| Enstrüman | Tel Sayısı | Standart Akort |
|-----------|-----------|----------------|
| Keman | 4 | G3(196), D4(293.7), A4(440), E5(659.3) |
| Gitar | 6 | E2(82.4), A2(110), D3(146.8), G3(196), B3(246.9), E4(329.6) |
| Bas Gitar | 4 | E1(41.2), A1(55), D2(73.4), G2(98) |
| Ukulele | 4 | G4(392), C4(261.6), E4(329.6), A4(440) |
| Bağlama | 7 | Alt: La2(110)×2, Orta: Re3(146.8)×2, Üst: Sol3(196)×2+Sol4(392) |
| Ud | 11 | Yegah: Re2(73.4)×2, Aşiran: Sol2(98)×2, Rast: La2(110)×2, Düga: Re3(146.8)×2, Neva: Sol3(196)×2, Bam: Do3(130.8) |
| Viyola | 4 | C3(130.8), G3(196), D4(293.7), A4(440) |
| Çello | 4 | C2(65.4), G2(98), D3(146.8), A3(220) |

---

## COMMIT MESAJI FORMATI

```
[ALAN]: Kısa açıklama
```

Alan etiketleri: `[TUNER]`, `[AUDIO]`, `[UI]`, `[INSTRUMENT]`, `[MODEL]`, `[SERVICE]`, `[SETTINGS]`, `[FIX]`, `[TEST]`, `[DOCS]`, `[CONFIG]`

---

## GÜVENLİK KURALLARI (OTONOM ÇALIŞMA)

### Yapabilirsin (onay gerekmez):
- Dosya oluştur / düzenle (lib/ ve test/ altında)
- flutter analyze çalıştır
- flutter test çalıştır
- Git: yeni branch oluştur (claude/ prefix)
- Git: commit at (claude/ branch'ine)
- pubspec.yaml'a paket ekle + flutter pub get
- todo.md'yi güncelle

### YAPAMAZSIN (asla):
- main/master branch'e doğrudan push
- Dosya SİLME (sadece oluştur/düzenle)
- Mevcut çalışan dosyaların fonksiyon imzasını değiştirme
- .env / API key / token / şifre içeren dosyalara dokunma
- İnternet'e veri gönderme (uygulama offline)
- 500+ satırlık tek dosya oluşturma

### Takıldığında:
- Hata 2. kez gelirse → DUR, sebep analizi yaz, sabah sor
- Mimari karar gerekiyorsa → DUR, seçenekleri yaz, sabah sor
- Emin değilsen → DUR, soru yaz, sabah sor

### Gece çalışma raporu formatı:
Her sabah şu özeti hazırla:
- Tamamlanan görevler [liste]
- Oluşturulan PR'lar [branch adı + açıklama]
- Çalıştırılan testler [geçti/kaldı]
- Takıldığım yerler [varsa]
- Sıradaki görev [todo'dan]
