Nağme — Design System v2
Kromatik Akort Uygulaması — "Dark Teal Waveform"
Bu doküman Nağme'nin tüm ekranları için tek referans kaynağıdır. Google Stitch, Claude Code ve her tasarım aracında bu dosyayı referans al.
1. Felsefe
Koyu turkuaz + dalga formu + oyunsu hassasiyet. Bir ritim oyununun canlılığı ile profesyonel bir stüdyo aletinin hassasiyeti arasında. Öğrencilerin açmak İSTEYECEĞİ bir uygulama.
Abinin anısı sadece Hakkında sayfasında kendini gösterir — orada sıcak, samimi, duygusal. Geri kalan her yer canlı ve profesyonel.
Hedef kullanıcı: Kıbrıs Sanat öğrencileri ve öğretmenleri. Offline, ücretsiz, reklamsız.
2. Renk Paleti
Ana Zemin (Koyu Turkuaz)
Token Hex Kullanım bg-base #041615 En koyu arka plan, nav bg-primary #0C1F1D Ana sayfa arka planı bg-surface #132B28 Kartlar, waveform container bg-elevated #1A3633 Yükseltilmiş elemanlar border-default #2A8F88 Aktif kenarlıklar border-subtle #1A3633 Hafif ayırıcılar
Marka — Turkuaz
Token Hex Kullanım brand-primary #4ECDC4 Ana marka, aktif butonlar brand-light #6EE7DF Hover, parlak vurgu brand-dim #2A8F88 Subtle border, ikincil brand-on #0C1F1D Buton üzeri metin
Metin
Token Hex Kullanım text-primary #E8F5F3 Ana metin text-secondary #7FA8A3 İkincil metin text-muted #4A7B75 Placeholder, ipucu
Durum (Akort)
Token Hex Kullanım status-in-tune #10B981 Yeşil — akort tamam status-sharp #F43F5E Rose — diyez status-flat #F59E0B Amber — bemol
Hakkında (İstisna)
Token Hex Kullanım memorial-warm #E8A838 Anı aksanı memorial-text #FFC66B Başlık memorial-bg #161311 Sıcak koyu arka plan
3. Tipografi


Plus Jakarta Sans 800: Uygulama adı (22px), nota (64px)

Space Grotesk 500-700: Frekans, cent, tel isimleri

Be Vietnam Pro 500: Nav etiketleri (11px), ayar satırları (14px)
4. Bileşenler
Dalga Formu (Hero): 240px, bg-surface, SVG dalga + grid + glow
Nota Display: 64px nota + Hz + cent satırı
Pitch Bar: 6px track, hareketli gösterge daire
Tel Seçici: 4 sütun grid, aktif=turkuaz
Mikrofon FAB: 72px daire, pulse animasyonu
Bottom Nav: 3 tab (Akort/Enstrümanlar/Ayarlar), turkuaz aktif
Enstrüman Kart: bg-surface, 24px radius, ikon+isim+akort
5. Ekranlar


Tuner — Dalga formu + nota + pitch bar + tel seçici + mikrofon

Enstrüman Seçim — 2 sütun grid, 9 enstrüman

Ayarlar — Gruplu satırlar (akort, ses, görünüm, hakkında)

Hakkında — Amber sıcak istisna, anı metni
6. Geliştirme


Flutter + Riverpod

Her adım = commit + push

Telefonda test → sonraki adım

Offline, ücretsiz, reklamsız

com.aximity.nagme