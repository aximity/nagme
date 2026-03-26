# Uygulama Yapma Kiti

> Claude Code'a "şu uygulamayı yap" de, gerisini o halletsin.
> Tasarım, mimari, kod, test — hepsi otomatik.

---

## Ne Yapar?

Bu kit Claude Code'a `/uygulama-yap` skill'i kazandırır. Skill şunu yapar:

1. **Fikir toplar** — Senden uygulama fikrini, platform tercihini, tasarım stilini sorar
2. **Planlar** — CLAUDE.md, architecture.md, todo.md otomatik üretir
3. **Tasarlar** — Stitch MCP ile UI tasarımı yapar (veya seni Stitch'e yönlendirir)
4. **İskelet kurar** — Flutter/React/Python projesi oluşturur, klasör yapısını kurar
5. **Kodu yazar** — Todo'daki görevleri sırayla tamamlar
6. **Test eder** — Analyze + unit test + entegrasyon kontrolü
7. **Build verir** — Release APK/build oluşturur

---

## Kurulum (Tek Seferlik)

```powershell
# 1. Bu klasörü bir yere indir (örn: Desktop)
# 2. PowerShell'i yönetici olarak aç
# 3. Çalıştır:
cd C:\Users\stare\Desktop\uygulama-yapma-kiti
.\kur.ps1
```

Script otomatik olarak kurar:
- `/uygulama-yap` skill'i → `~/.claude/skills/uygulama-yap/`
- Stitch Skills (4 adet) → enhance-prompt, stitch-design, design-md, stitch-loop
- MCP sunucuları → Dart/Flutter, Git, Context7, Fetch + opsiyonel Stitch, Firebase, GitHub

---

## Kullanım

### Yeni uygulama başlat:
```
mkdir C:\Users\stare\Desktop\nagme
cd C:\Users\stare\Desktop\nagme
claude
> /uygulama-yap Keman akort uygulaması, offline çalışan, profesyonel stüdyo temalı
```

### Örnekler:
```
/uygulama-yap Çekici çağırma uygulaması, Uber tarzı, Firebase backend, Flutter
/uygulama-yap Manga çeviri aracı, Python FastAPI, OCR + çeviri, web arayüz
/uygulama-yap Kişisel AI asistan, sesli komut, Gemini API, TypeScript
/uygulama-yap Portfolio web sitesi, minimal tasarım, React, dark tema
```

### Çalışma akışı:
```
Sen: /uygulama-yap [fikir]
  ↓
Claude Code: Sorular sorar (platform, özellikler, tasarım)
  ↓
Sen: Cevapları verirsin
  ↓
Claude Code: CLAUDE.md + architecture + todo üretir → "Onaylıyor musun?"
  ↓
Sen: "Evet, devam et"
  ↓
Claude Code: Stitch'te tasarım yapar → proje iskeletini kurar → kodu yazar
  ↓
(Arada sana sorar: "Bu ekran böyle mi olsun?")
  ↓
Claude Code: Test eder → build verir → "Tamamlandı, APK burada"
```

---

## Dosya Yapısı

```
uygulama-yapma-kiti/
├── kur.ps1                              ← Kurulum script'i (tek seferlik çalıştır)
├── README.md                            ← Bu dosya
└── skill/
    ├── SKILL.md                         ← Ana orchestrator skill
    └── resources/
        └── kit/                         ← Claude Code Kit şablonları
            ├── CLAUDE-SABLONU.md        ← Her projede doldurulacak CLAUDE.md
            ├── 00-hizli-referans.md     ← Karar ağacı
            ├── 01-gorev-sablonu.md      ← Görev şablonu
            ├── 02-once-plan-sonra-kod.md
            ├── 03-hata-dongusu-kirici.md
            ├── 04-entegrasyon-kontrolu.md
            ├── 05-test-senaryolari.md
            └── README.md
```

---

## Gereksinimler

| Araç | Gerekli mi | Kurulum |
|------|-----------|---------|
| Node.js 18+ | Evet | nodejs.org |
| Claude Code | Evet | `npm install -g @anthropic-ai/claude-code` |
| Flutter 3.35+ | Mobil projeler için | flutter.dev |
| gcloud CLI | Stitch MCP için | cloud.google.com/sdk |
| Git | Opsiyonel | git-scm.com |

---

## MCP Durumu Kontrol

```
claude
> /mcp
```

Beklenen:
```
• dart-flutter: connected
• git: connected
• context7: connected
• fetch: connected
• stitch: connected (opsiyonel)
• firebase: connected (opsiyonel)
• github: connected (opsiyonel)
```

---

## SSS

**S: Her projede tekrar kurulum gerekli mi?**
H: Hayır. `kur.ps1`'i bir kez çalıştır, skill ve MCP'ler tüm projelerde çalışır.

**S: Stitch olmadan çalışır mı?**
E: Evet. Stitch MCP yoksa, skill sana Stitch prompt'larını verir, sen stitch.withgoogle.com'a yapıştırır, HTML export'unu Claude Code'a yüklersin.

**S: Flutter dışı projeler için çalışır mı?**
E: Evet. React, Next.js, Python/FastAPI, vanilla HTML — skill stack'i sana sorar ve ona göre iskelet kurar.

**S: Mevcut projeye uygulayabilir miyim?**
E: Evet, ama dikkatli ol. CLAUDE.md oluşturur, mevcut kodu analiz eder, todo çıkarır.

---

## Sürüm

- v1.0 — 2026-03-25 — İlk sürüm (Nağme + MeyDey deneyiminden üretildi)
