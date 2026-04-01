# CLAUDE.md — Evrensel Proje Kuralları
# Her projenin ROOT klasörüne kopyala. Detaylı kurallar .claude/rules/ altında.

## 🚫 YASAK LİSTESİ

1. **TAHMİNİ İŞLEM YAPMA** — Bilmiyorsan ÖNCE sor veya kontrol et. "Muhtemelen/herhalde" ile işlem başlatma.
2. **HALÜSİNASYON** — PNG/SVG/görsel içini göremezsin. İçerik hakkında tahmin yapma, kullanıcıya sor.
3. **"HER ŞEY TAMAM" DEME** — Her kontrolde bulgu listesi çıkar. Emin değilsen "TEST GEREKLİ" yaz.
4. **YANLIŞ KLASÖR** — İşlem öncesi `pwd` ile teyit et. Path'i açıkça belirt.
5. **EZBERE BİLGİ** — API/lib versiyonu, fonksiyon signature'ı bilmiyorsan docs'a bak veya sor.
6. **GÖRSELDEN KOD ÜRETME** — Design token'ları (renk, font, spacing) metin olarak iste.

## ✅ HER İŞLEMDE ZORUNLU

### ÖNCE
- İstenen görevi madde madde listele
- Etkilenecek dosyaları listele
- Mevcut yapıyı kontrol et (`ls`, `cat`, `find`)
- Emin değilsen ÖNCE SOR — işleme başlama

### SIRASINDA
- Her değişiklik sonrası doğrulama (`cat`/`grep`)
- Import/dependency, null-safety, UTF-8, tip uyumu kontrol et

### SONRASI — KAPANIŞ PROTOKOLÜ
- Prompttaki istekleri MADDE MADDE kontrol et
- Build/test komutu çalıştır veya öner
- Değişiklik özeti: hangi dosyada ne değişti
- Sorunları severity ile listele (KRİTİK/ORTA/DÜŞÜK)
- `git diff` ile değişiklikleri göster

## 🔍 KOD İNCELEME — 5 ADIM ZORUNLU

1. Import/dependency eksikleri
2. Null-safety — `!` operatörü gereksiz mi?
3. Türkçe/UTF-8 sorunları
4. Tip uyumsuzlukları
5. Edge case — boş liste, null, network hatası, izin reddi

Rapor formatı: KRİTİK → ORTA → DÜŞÜK → TEST GEREKLİ

## 🔒 GÜVENLİK — HER KOD YAZIMINDA KONTROL ET

- SQL/NoSQL: Parameterized query ZORUNLU, raw query YASAK
- API key/secret koda gömme → `.env` + `.gitignore`
- Kullanıcı girdisi doğrulama: client VE server
- Firebase Security Rules tanımlı mı?
- Token/şifre: `flutter_secure_storage`, düz metin YASAK
- Hata mesajlarında hassas bilgi (stack trace, DB yapısı) sızdırma
- Detaylı kurallar: @.claude/rules/security.md

## 🧪 TEST KURALLARI

- Yeni feature = en az 1 unit test ZORUNLU
- Bug fix = önce fail eden test yaz, sonra düzelt (TDD)
- Test coverage düşürme — yeni kod eklerken mevcut testleri bozma
- Edge case testleri: null, boş string, max length, Türkçe karakter
- Flutter: `flutter test` her PR öncesi çalıştır
- Backend: `pytest` / `npm test` her değişiklik sonrası
- Detaylı kurallar: @.claude/rules/testing.md

## 📊 GIT/VERSİYON KONTROL

- Her mantıksal değişiklik = 1 commit (atomik commit)
- Commit mesajı formatı: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`
- Commit mesajı Türkçe veya İngilizce — proje içinde tutarlı ol
- Commit ÖNCE: `flutter analyze` / `npm run lint` çalıştır
- .env, .db, .sqlite, node_modules, build/ ASLA commit'leme
- Branch stratejisi: `main` (stable) → `feature/xxx` → PR → merge
- Detaylı kurallar: @.claude/rules/git.md

## ⚡ PERFORMANS

- Gereksiz rebuild önle: `const` widget kullan (Flutter)
- Liste render: `ListView.builder` kullan, `ListView(children: [])` YASAK (100+ item)
- Image: cache ve lazy loading uygula, tam boyut yükleme
- API çağrısı: debounce/throttle uygula (arama, form submit)
- State management: gereksiz provider rebuild'den kaçın
- Bundle size: kullanılmayan import ve dependency kaldır
- Detaylı kurallar: @.claude/rules/performance.md

## 📐 HESAPLAMA

- Para dönüşümü ÖNCE güncel kuru doğrula — ezbere kur YASAK
- Adım adım göster: `$99 × 44.48 = 4,403 TL`
- Yuvarlama yapıyorsan belirt

## 💬 İLETİŞİM

- Bilmiyorsan "bilmiyorum, kontrol lazım" de
- "Sanırım/muhtemelen/herhalde" ile işlem YAPMA
- Kullanıcı 2. kez soruyorsa → ilk seferde düzgün yapılmamış, kökeni bul
- Uzun işlemlerde ara ara durum raporu ver

## 🏗️ FLUTTER/DART ÖZEL

- `google_fonts` yerine font bundle et (FPS fix)
- Timestamp null-safety (Firebase)
- `BuildContext` async gap dikkat
- GoRouter route tanımı kontrol
- Asset path'ler `pubspec.yaml`'da tanımlı mı
- `dispose()` listener/controller temizliği

## 🔄 HATA ÖĞRENİM DÖNGÜSÜ

Her düzeltmeden SONRA:
1. Hatanın kökeni ne? (neden oldu?)
2. `tasks/lessons.md`'ye kural ekle
3. Aynı hatayı tekrarlama

## PROJE KURALLARI
<!-- Bu bölümü projeye göre doldur -->
# CLAUDE.md — Nağme Proje Kuralları
# Bu dosya evrensel CLAUDE.md'nin PROJE KURALLARI bölümüne yapıştırılır

## PROJE KURALLARI — NAĞME

- **Proje:** Nağme — Kromatik Akort Uygulaması
- **Path:** `C:\Users\stare\Desktop\nagme`
- **Package:** `com.aximity.nagme`
- **Stack:** Flutter 3.29.2 + Riverpod + GoRouter
- **Branch:** `v2-dark-teal`

### ÖNEMLİ
- Bu bir ANI PROJESİDİR — Ahmet'in vefat eden kardeşinin anısına
- SONSUZA KADAR ücretsiz, reklamsız, offline kalacak
- Monetizasyon ÖNERİLMEYECEK — ASLA
- Abinin anısı SADECE Hakkında sayfasında — geri kalan canlı ve profesyonel

### Tasarım Sistemi
- Tema: Dark Teal Waveform
- Base: `#041615`, Surface: `#132B28`, Elevated: `#1A3633`
- Brand: `#4ECDC4` (primary), `#6EE7DF` (light), `#2A8F88` (dim)
- Status: `#10B981` (in-tune), `#F43F5E` (sharp), `#F59E0B` (flat)
- Memorial (sadece Hakkında): `#161311` bg, `#E8A838` warm, `#FFC66B` text
- Font: Plus Jakarta Sans 800, Space Grotesk 500-700, Be Vietnam Pro 500
- Font'lar BUNDLE edilecek (google_fonts KULLANMA — FPS sorunu)

### Enstrümanlar
keman, gitar, bağlama, ud, bas gitar, ukulele, viyola, çello

### Hedef Kullanıcı
Kıbrıs Sanat öğrencileri ve öğretmenleri

### Dosya Yapısı
```
lib/
  ├── theme/        # renk, tipografi, spacing token'ları
  ├── models/       # enstrüman, tuning modelleri
  ├── providers/    # riverpod state management
  ├── screens/      # tuner, instruments, settings, about
  └── widgets/      # reusable UI parçaları
assets/
  ├── icons/        # 9 SVG enstrüman ikonu
  └── fonts/        # bundle edilmiş fontlar
```
