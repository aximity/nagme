# Nağme v2 — TODO

## ✅ Tamamlanan
- [x] Proje iskeleti + bağımlılıklar
- [x] Tema sistemi (renkler, tipografi, ThemeData)
- [x] Enstrüman modeli + 9 enstrüman verisi (tel sayıları doğru)
- [x] Providers (instrument, tuner state, settings — 8 provider)
- [x] Bottom nav (3 tab: Akort/Enstrümanlar/Ayarlar)
- [x] Tuner ekranı (waveform, nota display, pitch bar, dinamik tel seçici, mic FAB)
- [x] Enstrüman seçim ekranı (2 sütun grid, 9 kart, SVG ikonlar, provider bağlı)
- [x] Ayarlar ekranı (4 bölüm, tüm satırlar çalışıyor, bottom sheet'ler)
- [x] Hakkında ekranı (memorial amber tema, doğru metinler)
- [x] Splash ekranı (2s, sadece metin, alt yazı)
- [x] Waveform painter (CustomPainter)
- [x] Mikrofon izin diyaloğu (permission_handler bağlı)
- [x] 9 SVG enstrüman ikonu (assets/icons/)
- [x] App ikonu entegrasyonu (flutter_launcher_icons, 1024x1024, adaptive)
- [x] Tasarıma uyumluluk denetimi (70+ kontrol maddesi geçti)
- [x] Bundled fontlar (PlusJakartaSans, SpaceGrotesk, BeVietnamPro)
- [x] Duruma göre renk değişimi (idle/flat/sharp/inTune)
- [x] Simülasyon modu (FAB tıklama → rastgele durum)
- [x] Geri bildirim (url_launcher, mailto:info@gdyon.dev)
- [x] Paket ismi: com.gdyon.nagme

## 📋 Sıradaki — Ses Motoru
- [ ] Mikrofon erişimi (permission_handler — izin altyapısı hazır)
- [ ] Ses yakalama (audio stream)
- [ ] Pitch detection algoritması (YIN veya autocorrelation)
- [ ] Frekans → nota çevrimi
- [ ] Cent sapma hesaplama
- [ ] Gerçek zamanlı UI güncelleme
- [ ] Waveform canlı render
- [ ] Referans sesi üretimi (sinüs ton generator)

## 📋 Sonraki — İyileştirmeler
- [ ] Hakkında fotoğraf alanı (kullanıcıyla gözden geçirilecek)

## 📋 Yayın Öncesi
- [ ] Play Store listing metinleri (Türkçe)
- [ ] Play Store ekran görüntüleri
- [ ] Feature graphic (1024x500)
- [ ] Privacy policy sayfası
- [ ] Gerçek enstrümanlarla test (keman, gitar)
- [ ] APK boyut optimizasyonu
- [ ] ProGuard/R8 ayarları
- [ ] Sürüm: 2.0.0+1
