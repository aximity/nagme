# Performans Optimizasyon Kuralları — Detaylı

## Flutter / Dart

### Widget Rebuild Önleme
- `const` constructor kullan mümkün olan her yerde
- `StatelessWidget` tercih et — `StatefulWidget` sadece gerektiğinde
- Riverpod: `select()` ile sadece gerekli state parçasını dinle
- `Consumer` widget'ı mümkün olduğunca dar scope'ta kullan

### Liste Performansı
- 20+ item: `ListView.builder` / `GridView.builder` ZORUNLU
- `ListView(children: [...])` → 100+ item'da ANR riski
- `itemExtent` veya `prototypeItem` belirt (scroll performansı)
- Sonsuz scroll: pagination uygula (20-50 item/sayfa)

### Görsel Performans
- Büyük görseller: `cached_network_image` + resize
- SVG: karmaşık SVG'leri build time'da PNG'ye çevir
- Placeholder ve shimmer loading efekti kullan
- `Image.asset` için `cacheWidth`/`cacheHeight` belirt

### Font Performansı
- `google_fonts` paketi yerine font'ları `assets/fonts/` içinde bundle et
- Sadece kullanılan weight'leri dahil et (400, 500, 700 — tümünü değil)

### Build Performansı
- `flutter build apk --split-per-abi` (APK boyutunu %50 küçültür)
- `--tree-shake-icons` (kullanılmayan Material icon'ları kaldırır)
- ProGuard/R8 kurallarını doğru yapılandır
- `flutter build apk --analyze-size` ile boyut analizi

### State Management
- Gereksiz provider rebuild'den kaçın
- `ref.watch` sadece UI'da, `ref.read` event handler'larda
- Büyük state objelerini parçala — tek büyük provider YASAK
- Computed/derived state için `Provider` (auto-dispose)

## Backend (Fastify / FastAPI)

### API Performansı
- Arama endpoint'lerinde debounce: client tarafında 300-500ms
- Pagination ZORUNLU: default 20, max 100 item/sayfa
- Response'da sadece gerekli alanları döndür (field selection)
- Ağır sorgular için cache (Redis veya in-memory)

### Database
- Index: sık sorgulanan alanlar (email, username, created_at)
- N+1 sorgu problemi: eager loading / join kullan
- Büyük tablo: cursor-based pagination (offset YASAK)
- Connection pooling ayarla

### Genel
- Gereksiz log'ları production'da kapat
- Gzip/Brotli compression aktif et
- Static asset'ler için CDN kullan
- Health check endpoint ekle

## Mobil Genel

### Network
- Offline-first düşün: önce cache, sonra API
- Retry mekanizması (exponential backoff)
- Timeout ayarla: connect 10s, read 30s
- Büyük dosya upload: multipart + progress indicator

### Battery & Memory
- Background task'ları minimize et
- Location tracking: sadece gerektiğinde (GPS battery drain)
- Listener/subscription'ları `dispose()` ile temizle
- Büyük liste: item'ları memory'den temizle (AutomaticKeepAlive kapatılabilir)

## Ölçüm
- Flutter DevTools: widget rebuild sayısı, frame render süresi
- `flutter run --profile` ile performance profiling
- Firebase Performance Monitoring (production)
- APK boyutu hedefi: <30MB (split ABI ile)
