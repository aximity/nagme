# Hata Öğrenim Günlüğü (lessons.md)
# Her düzeltmeden sonra buraya kural ekle. Claude Code her session'da okur.
# Format: tarih | hata | kök neden | kural

## Geçmiş Hatalar

### 2026-03 | PNG içindeki metni kodda arama
- **Hata:** "Claim your discount" metni PNG görselinin içindeydi, Claude Code kodda aramaya çalıştı, 3 kez başarısız oldu
- **Kök neden:** Claude görsellerin içini göremez, tahminle işlem yaptı
- **Kural:** PNG/SVG içeriği hakkında ASLA tahmin yapma. Kullanıcıya sor veya görseli değiştirmesini iste

### 2026-03 | Yanlış kur ile hesaplama
- **Hata:** $99 = 3,200 TL hesaplandı, gerçek kur 44.48 idi ($99 = 4,403 TL)
- **Kök neden:** Ezbere/eski kur bilgisi kullanıldı
- **Kural:** Para dönüşümü ÖNCE güncel kuru web'den doğrula

### 2026-03 | "Her şey tamam" sonrası kritik hata
- **Hata:** Kod incelemesinde "sorun yok" dendi, son kontrolde 2-3 kritik hata çıktı
- **Kök neden:** Yüzeysel kontrol, edge case'ler taranmadı
- **Kural:** ASLA "her şey tamam" deme, her kontrolde 5 adımlı checklist uygula

---
<!-- Yeni hatalar buraya eklenecek -->
