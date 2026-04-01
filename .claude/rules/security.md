# Güvenlik Kuralları — Detaylı

## 1. Injection Önleme
- **SQL Injection:** Raw SQL YASAK. Parameterized query / prepared statement zorunlu
  - YASAK: `"SELECT * FROM users WHERE id = $id"`
  - DOĞRU: `db.query("SELECT * FROM users WHERE id = ?", [id])`
- **NoSQL Injection:** Firebase/Firestore sorgularında kullanıcı girdisini tipine göre doğrula
- **Command Injection:** `Process.run()` / `exec()` kullanıyorsan girdiyi whitelist ile doğrula
- **XSS:** Kullanıcı girdisini HTML'e render etmeden ÖNCE escape et. WebView kullanıyorsan dikkat

## 2. Kimlik Doğrulama & Yetkilendirme
- Firebase Auth token doğrulama (backend)
- Firestore Security Rules MUTLAKA yaz — default open bırakma
- Admin endpoint'lere rol kontrolü
- JWT/token: `flutter_secure_storage` — düz metin YASAK
- Session timeout tanımla

## 3. Input Validation
- HER girdiyi doğrula — client VE server
- E-posta, telefon, fiyat aralığı, metin uzunluğu
- Dosya yükleme: MIME tipi, boyut limiti, dosya adı sanitizasyonu
- Regex: ReDoS riskini kontrol et

## 4. API Güvenliği
- Secret: `.env` + Secret Manager → `.gitignore` KONTROL ET
- HTTPS zorunlu
- Rate limiting (brute force koruması)
- CORS: `*` wildcard YASAK

## 5. Veri Saklama
- Şifre: bcrypt/argon2 hash (düz metin YASAK)
- Hassas veri loglarken maskele
- Firebase rules production deploy ÖNCE kontrol
- SQLite: sqlcipher şifreleme düşün
- KVKK/GDPR: kullanıcı veri silme endpoint'i

## 6. Dependency
- Paket eklemeden ÖNCE: güncelleme tarihi, indirme sayısı, zafiyet kontrolü
- `pub outdated` / `npm audit` / `pip audit` çalıştır
- Kullanılmayan bağımlılıkları kaldır

## 7. Hata Yönetimi
- Hata mesajında stack trace, DB yapısı, internal path GÖSTERİLMEMELİ
- Production'da debug logları kapat
- `catch(e) {}` boş yakalama YASAK — logla veya handle et

## Checklist
```
- [ ] Kullanıcı girdileri doğrulanıyor mu? (client + server)
- [ ] SQL/NoSQL injection riski var mı?
- [ ] API key/secret kodda gömülü mü?
- [ ] .env → .gitignore'da mı?
- [ ] Firebase Security Rules tanımlı mı?
- [ ] Token/şifre güvenli saklanıyor mu?
- [ ] Hata mesajları hassas bilgi sızdırıyor mu?
- [ ] HTTPS kullanılıyor mu?
- [ ] Rate limiting var mı?
```
