# Test Kuralları — Detaylı

## Temel Prensipler
- Yeni feature = en az 1 unit test ZORUNLU
- Bug fix = önce fail eden test yaz, sonra düzelt (Red-Green-Refactor)
- Mevcut testleri BOZMA — yeni kod eklerken coverage düşürme
- Test kodu da production kodu kadar temiz olmalı

## Test Türleri ve Ne Zaman Yazılır

### Unit Test (her zaman)
- Her yeni fonksiyon/metod için
- İş mantığı (business logic), hesaplama, veri dönüşümü
- Edge case'ler: null, boş string, max/min değer, Türkçe karakter (İ/ı/Ş/ş/Ğ/ğ/Ü/ü/Ö/ö/Ç/ç)

### Widget Test (Flutter — UI değişikliklerinde)
- Yeni ekran veya widget eklendiğinde
- Kullanıcı etkileşimi (tap, scroll, form submit) doğrulaması
- State değişikliği sonrası UI güncellenme testi

### Integration Test (kritik akışlarda)
- Kayıt/giriş akışı
- Ödeme/ilan oluşturma akışı
- API çağrısı → UI güncelleme zinciri

## Flutter Test Komutları
```bash
# Tüm testler
flutter test

# Tek dosya
flutter test test/unit/auth_test.dart

# Coverage raporu
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Widget test
flutter test test/widget/home_screen_test.dart
```

## Backend Test Komutları
```bash
# Node.js / Fastify
npm test
npm run test:coverage

# Python / FastAPI
pytest
pytest --cov=app tests/
pytest -v tests/test_auth.py
```

## Test Yazım Kuralları
- Test adı ne test ettiğini açıkça söylemeli: `test('should return null when user not found')`
- Arrange → Act → Assert (AAA) pattern
- Her test bağımsız olmalı — birbirine bağımlı test YASAK
- Mock/stub kullanarak external dependency'leri izole et
- Hardcoded değer yerine fixture/factory kullan

## Ne Zaman Test ATLANMAZ
- Auth/login akışı
- Ödeme/finansal işlem
- Veri silme/güncelleme
- Kullanıcı girdisi doğrulama
- API endpoint'ler (en azından happy path + error case)
