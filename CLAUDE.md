# Nağme — Claude Code Kuralları

## Proje Özeti

Nağme — Profesyonel kromatik akort cihazı. Mikrofon → frekans analizi → nota tespiti → görsel gösterge. Tamamen offline, Türkçe UI.

## Stack

- **Framework:** Flutter 3.29 (Dart 3.7.2)
- **State:** Riverpod 2.x
- **Routing:** GoRouter 14.x
- **Audio:** flutter_audio_capture (mikrofon PCM stream)
- **Pitch Detection:** YIN algoritması (Dart, Isolate-ready)
- **Ton Üretici:** audioplayers (sinüs dalgası)
- **Storage:** SharedPreferences
- **Font:** Epilogue (headline) + Manrope (body) + Space Grotesk (teknik veri)

## Proje Yolu

```
C:\Users\stare\Desktop\nagme
```

## Komutlar

```bash
flutter analyze              # Lint — 0 issue olmalı
flutter test                 # Unit testler
flutter build apk --debug    # Android debug APK
flutter build apk --release  # Android release APK
flutter run -d <device_id>   # Cihazda çalıştır
flutter pub get              # Bağımlılıkları yükle
```

---

## MİMARİ KURALLAR

### Klasör Yapısı
- `lib/config/` — tema, sabitler, enstrüman tanımları, route'lar
- `lib/core/` — pitch detection, nota hesaplama (saf Dart, UI bağımsız)
- `lib/models/` — Note, InstrumentTuning, TunerState
- `lib/services/` — AudioService, PitchService, ToneGenerator, PreferencesService
- `lib/providers/` — Riverpod provider'ları
- `lib/screens/` — 3 ekran: tuner, instruments, settings
- `lib/widgets/` — tuner widget'ları (gauge, needle, waveform, string indicator)
- `lib/utils/` — audio_utils, note_utils

### Kurallar
1. **Core ve services UI'dan bağımsız olmalı** — Flutter import yok
2. **Tüm state Riverpod ile** — setState sadece lokal UI state için
3. **Enstrüman tanımları `config/instruments.dart`'ta** — yeni enstrüman eklerken sadece buraya ekle
4. **Renk sabitleri `AppColors`'da** — hardcoded renk YASAK
5. **Font: Epilogue/Manrope/Space Grotesk** — başka font kullanma
6. **Türkçe UI** — kullanıcıya görünen tüm text Türkçe olmalı

---

## DOĞRULAMA KURALI (ZORUNLU — HER DEĞİŞİKLİKTEN SONRA)

Her kod değişikliğinden sonra, build'den ÖNCE şu adımları MUTLAKA yap:

### Adım 1: Ne değişti? (git diff)
```
git diff --stat
git diff --name-only
```

### Adım 2: İstenen değişiklikler gerçekten uygulandı mı? (grep doğrulama)
- Eklenmesi istenen text/widget varsa → grep ile dosyada ARA, bulunmalı
- Silinmesi istenen text varsa → grep ile ARA, bulunmamalı
- Türkçeleştirme yapıldıysa → İngilizce kelimeler grep ile ARA, kalmamalı

### Adım 3: Sonuç tablosu göster
```
┌────────────────────┬────────┬─────────────────────────┐
│ İstenen Değişiklik  │ Durum  │ Doğrulama               │
├────────────────────┼────────┼─────────────────────────┤
│ X eklendi          │ ✅/❌  │ grep sonucu: bulundu/yok │
│ Y silindi          │ ✅/❌  │ grep sonucu: yok/hâlâ var│
└────────────────────┴────────┴─────────────────────────┘
```

### Adım 4: Hata varsa otomatik düzelt
- Tabloda ❌ varsa → düzelt ve tabloyu TEKRAR göster
- Tüm satırlar ✅ olana kadar build'e GEÇME

### Adım 5: Build ve yükle
```
flutter analyze
flutter clean && flutter pub get && flutter build apk --debug
```

## YAPMA LİSTESİ
- İstenmemiş dosyaya DOKUNMA
- "Düzelttim" demeden önce grep ile KANITLA
- Kullanıcı sormadan ekstra özellik EKLEME
- Mevcut çalışan kodu bozma riski varsa → ÖNCE sor
- Core algoritmayı (pitch_detector.dart) değiştirirken test'leri de çalıştır

## ENSTRÜMAN EKLEMESİ

Yeni enstrüman eklerken sadece `lib/config/instruments.dart`'a ekle:
```dart
InstrumentTuning(
  id: 'unique_id',
  name: 'Türkçe Ad',
  nameEn: 'English Name',
  icon: '🎵',
  strings: [
    StringTuning(name: 'Tel1', noteName: 'A', octave: 4, frequency: 440.0),
  ],
),
```

## BİLİNEN TUZAKLAR

| Tuzak | Çözüm |
|-------|-------|
| iOS mikrofon izni | Info.plist'te NSMicrophoneUsageDescription olmalı |
| Android 13+ mikrofon | permission_handler ile runtime izin iste |
| Düşük frekans tespiti (bas gitar) | bufferSize 4096 ile yeterli, küçültme |
| Feedback loop | Ton çalarken tuner'ı durdur |
