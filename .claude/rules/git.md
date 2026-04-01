# Git / Versiyon Kontrol Kuralları — Detaylı

## Commit Kuralları
- Her mantıksal değişiklik = 1 atomik commit
- Dev bir commit'e birden fazla iş sığdırma
- Commit ÖNCE çalışır durumda olmalı — kırık commit YASAK

## Commit Mesajı Formatı (Conventional Commits)
```
feat: yeni özellik eklendi
fix: bug düzeltildi
refactor: kod yeniden yapılandırıldı (davranış değişmedi)
docs: dokümantasyon güncellendi
test: test eklendi/düzeltildi
chore: build, config, dependency değişikliği
style: format, boşluk, noktalama (kod davranışı değişmedi)
perf: performans iyileştirmesi
```

Örnek:
```
feat: üniversite bazlı filtreleme eklendi
fix: Türkçe karakter encoding sorunu düzeltildi
refactor: auth service'i provider yapısına taşındı
```

## Branch Stratejisi
```
main (stable, production-ready)
  └── develop (aktif geliştirme)
       ├── feature/university-hub
       ├── feature/multi-language
       ├── fix/turkish-encoding
       └── hotfix/crash-on-login
```

- `main` her zaman çalışır durumda
- Feature branch'ten develop'a PR → code review → merge
- Hotfix direkt main'den branch aç → düzelt → main + develop'a merge

## Commit ÖNCE Checklist
```bash
# Flutter
flutter analyze
flutter test
dart format lib/

# Node.js
npm run lint
npm test

# Python
python -m pytest
ruff check .
```

## .gitignore ZORUNLU İçerik
```
# Genel
.env
.env.local
.env.production
*.db
*.sqlite
*.db-shm
*.db-wal

# Flutter
build/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies

# Node.js
node_modules/
dist/
package-lock.json  # (Ahmet tercihi)

# Python
__pycache__/
*.pyc
.venv/
venv/

# IDE
.vscode/settings.json  # kişisel ayarlar
.idea/

# OS
.DS_Store
Thumbs.db
```

## Tehlikeli Komutlar — DİKKAT
- `git push --force` → ASLA main'e force push yapma
- `git reset --hard` → commit kaybı riski — önce stash et
- `git clean -fd` → tracked olmayan dosyaları siler — emin olmadan çalıştırma
- Büyük dosya (>10MB) commit'lemeden ÖNCE sor

## Stash Kullanımı
```bash
# Geçici değişiklikleri sakla
git stash push -m "wip: university filter"

# Geri al
git stash pop
```
