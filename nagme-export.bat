@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

set "PROJECT=C:\Users\stare\Desktop\nagme"
set "OUTPUT=%USERPROFILE%\Desktop\nagme-export.txt"

echo ============================================
echo  Nagme Codebase Export
echo ============================================
echo.

if not exist "%PROJECT%" (
    echo HATA: %PROJECT% bulunamadi!
    pause
    exit /b 1
)

echo Proje: %PROJECT%
echo Cikti: %OUTPUT%
echo.

(
    echo ============================================
    echo  NAGME CODEBASE EXPORT
    echo  Tarih: %date% %time%
    echo ============================================
    echo.
    echo.
    echo ================== KLASOR YAPISI ==================
) > "%OUTPUT%"

powershell -ExecutionPolicy Bypass -Command ^
    "Get-ChildItem -Path '%PROJECT%' -Recurse -Directory | Where-Object { $_.FullName -notmatch '(\\build\\|\\\.dart_tool\\|\\\.gradle\\|\\\.idea\\|\\node_modules\\|\\\.claude\\|\\\.git\\|\\android\\\.gradle)' } | ForEach-Object { $_.FullName.Replace('%PROJECT%\','') }" >> "%OUTPUT%"

echo. >> "%OUTPUT%"
echo ================== DOSYA LISTESI ================== >> "%OUTPUT%"

powershell -ExecutionPolicy Bypass -Command ^
    "Get-ChildItem -Path '%PROJECT%' -Recurse -File | Where-Object { $_.FullName -notmatch '(\\build\\|\\\.dart_tool\\|\\\.gradle\\|\\\.idea\\|\\node_modules\\|\\\.git\\|\\android\\\.gradle)' -and $_.Extension -notmatch '(\.lock|\.db|\.sqlite|\.db-shm|\.db-wal|\.png|\.jpg|\.jpeg|\.gif|\.ico|\.ttf|\.otf|\.woff|\.woff2|\.apk|\.aab)' } | ForEach-Object { $rel = $_.FullName.Replace('%PROJECT%\',''); \"$rel ($([math]::Round($_.Length/1KB,1)) KB)\" }" >> "%OUTPUT%"

echo. >> "%OUTPUT%"
echo ================== PUBSPEC.YAML ================== >> "%OUTPUT%"

if exist "%PROJECT%\pubspec.yaml" (
    type "%PROJECT%\pubspec.yaml" >> "%OUTPUT%"
) else (
    echo pubspec.yaml bulunamadi >> "%OUTPUT%"
)

echo. >> "%OUTPUT%"
echo ================== KAYNAK KODLARI ================== >> "%OUTPUT%"

powershell -ExecutionPolicy Bypass -Command ^
    "$files = Get-ChildItem -Path '%PROJECT%\lib' -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -match '(\.dart)' }; foreach ($f in $files) { $rel = $f.FullName.Replace('%PROJECT%\',''); Add-Content -Path '%OUTPUT%' -Value \"`n`n========== $rel ==========\"; Get-Content $f.FullName -Encoding UTF8 | Add-Content -Path '%OUTPUT%' }"

powershell -ExecutionPolicy Bypass -Command ^
    "$files = Get-ChildItem -Path '%PROJECT%\test' -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -match '(\.dart)' }; foreach ($f in $files) { $rel = $f.FullName.Replace('%PROJECT%\',''); Add-Content -Path '%OUTPUT%' -Value \"`n`n========== $rel ==========\"; Get-Content $f.FullName -Encoding UTF8 | Add-Content -Path '%OUTPUT%' }"

powershell -ExecutionPolicy Bypass -Command ^
    "$extras = @('CLAUDE.md','tasks\lessons.md','analysis_options.yaml'); foreach ($e in $extras) { $p = Join-Path '%PROJECT%' $e; if (Test-Path $p) { Add-Content -Path '%OUTPUT%' -Value \"`n`n========== $e ==========\"; Get-Content $p -Encoding UTF8 | Add-Content -Path '%OUTPUT%' } }"

echo. >> "%OUTPUT%"
echo ================== SVG IKON LISTESI ================== >> "%OUTPUT%"

powershell -ExecutionPolicy Bypass -Command ^
    "Get-ChildItem -Path '%PROJECT%\assets' -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -match '(\.svg)' } | ForEach-Object { $_.FullName.Replace('%PROJECT%\','') }" >> "%OUTPUT%"

echo.
echo ============================================
echo  TAMAMLANDI!
echo  Dosya: %OUTPUT%
echo ============================================
echo.
pause
