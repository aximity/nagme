# ============================================
# UYGULAMA YAPMA KİTİ — Kurulum Script'i
# Windows PowerShell ile çalıştır
# ============================================
# Bu script'i BİR KEZ çalıştır. Her şeyi kurar:
# - Claude Code skill'i
# - Stitch Skills
# - MCP sunucuları
# - Gerekli npm paketleri
# ============================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  UYGULAMA YAPMA KİTİ — Kurulum" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# --- ÖN KONTROLLER ---
Write-Host "[1/7] Ön kontroller..." -ForegroundColor Yellow

# Node.js kontrol
$nodeVersion = node --version 2>$null
if (-not $nodeVersion) {
    Write-Host "  HATA: Node.js bulunamadi! https://nodejs.org adresinden kur." -ForegroundColor Red
    exit 1
}
Write-Host "  Node.js: $nodeVersion" -ForegroundColor Green

# Claude Code kontrol
$claudeVersion = claude --version 2>$null
if (-not $claudeVersion) {
    Write-Host "  HATA: Claude Code bulunamadi! 'npm install -g @anthropic-ai/claude-code' ile kur." -ForegroundColor Red
    exit 1
}
Write-Host "  Claude Code: $claudeVersion" -ForegroundColor Green

# Flutter kontrol (opsiyonel)
$flutterVersion = flutter --version 2>$null
if ($flutterVersion) {
    Write-Host "  Flutter: Mevcut" -ForegroundColor Green
} else {
    Write-Host "  Flutter: Bulunamadi (Flutter projeleri icin gerekli)" -ForegroundColor Yellow
}

# --- SKILL KURULUMU ---
Write-Host ""
Write-Host "[2/7] Claude Code skill kuruluyor..." -ForegroundColor Yellow

$skillSource = Split-Path -Parent $PSCommandPath
$skillDir = "$env:USERPROFILE\.claude\skills\uygulama-yap"

if (Test-Path $skillDir) {
    Remove-Item -Recurse -Force $skillDir
}

Copy-Item -Recurse "$skillSource\skill" $skillDir
Write-Host "  Skill kuruldu: $skillDir" -ForegroundColor Green

# --- STITCH SKILLS ---
Write-Host ""
Write-Host "[3/7] Stitch Skills kuruluyor..." -ForegroundColor Yellow

$stitchSkills = @("enhance-prompt", "stitch-design", "design-md", "stitch-loop")
foreach ($skill in $stitchSkills) {
    Write-Host "  Kuruluyor: $skill" -ForegroundColor Gray
    npx skills add google-labs-code/stitch-skills --skill $skill --global 2>$null
}
Write-Host "  Stitch Skills tamamlandi" -ForegroundColor Green

# --- MCP SUNUCULARI ---
Write-Host ""
Write-Host "[4/7] MCP sunuculari kuruluyor..." -ForegroundColor Yellow

# Dart/Flutter MCP
$dartPath = (Get-Command dart -ErrorAction SilentlyContinue).Source
if ($dartPath) {
    claude mcp add --scope user dart-flutter -- cmd /c dart mcp-server 2>$null
    Write-Host "  Dart/Flutter MCP: Kuruldu" -ForegroundColor Green
} else {
    Write-Host "  Dart/Flutter MCP: Atlandı (dart bulunamadı)" -ForegroundColor Yellow
}

# Git MCP
claude mcp add --scope user git -- cmd /c npx -y @modelcontextprotocol/server-git 2>$null
Write-Host "  Git MCP: Kuruldu" -ForegroundColor Green

# Context7 MCP
claude mcp add --scope user context7 -- cmd /c npx -y @upstash/context7-mcp@latest 2>$null
Write-Host "  Context7 MCP: Kuruldu" -ForegroundColor Green

# Fetch MCP
claude mcp add --scope user fetch -- cmd /c npx -y @anthropic/mcp-fetch 2>$null
Write-Host "  Fetch MCP: Kuruldu" -ForegroundColor Green

# --- STITCH MCP (kullanıcıya sor) ---
Write-Host ""
Write-Host "[5/7] Stitch MCP..." -ForegroundColor Yellow

$stitchSetup = Read-Host "  Stitch MCP kurmak ister misin? (Google Cloud hesabi gerekli) [E/H]"
if ($stitchSetup -eq "E" -or $stitchSetup -eq "e") {
    Write-Host "  Google Cloud auth baslatiliyor..." -ForegroundColor Gray
    gcloud auth login
    gcloud auth application-default login
    
    $projectId = Read-Host "  Google Cloud Project ID'ni gir"
    gcloud config set project $projectId
    gcloud beta services mcp enable stitch.googleapis.com --project=$projectId
    
    npx @_davideast/stitch-mcp init
    claude mcp add --scope user stitch -- cmd /c npx @_davideast/stitch-mcp proxy 2>$null
    Write-Host "  Stitch MCP: Kuruldu" -ForegroundColor Green
} else {
    Write-Host "  Stitch MCP: Atlandı (sonra 'npx @_davideast/stitch-mcp init' ile kurabilirsin)" -ForegroundColor Yellow
}

# --- FIREBASE MCP (opsiyonel) ---
Write-Host ""
Write-Host "[6/7] Opsiyonel MCP'ler..." -ForegroundColor Yellow

$firebaseSetup = Read-Host "  Firebase MCP kurmak ister misin? [E/H]"
if ($firebaseSetup -eq "E" -or $firebaseSetup -eq "e") {
    claude mcp add --scope user firebase -- cmd /c npx -y firebase-tools@latest mcp 2>$null
    Write-Host "  Firebase MCP: Kuruldu" -ForegroundColor Green
} else {
    Write-Host "  Firebase MCP: Atlandı" -ForegroundColor Yellow
}

$githubSetup = Read-Host "  GitHub MCP kurmak ister misin? (GITHUB_TOKEN gerekli) [E/H]"
if ($githubSetup -eq "E" -or $githubSetup -eq "e") {
    $token = Read-Host "  GitHub Personal Access Token'ini gir"
    [System.Environment]::SetEnvironmentVariable("GITHUB_TOKEN", $token, "User")
    claude mcp add --scope user github -- cmd /c npx -y @modelcontextprotocol/server-github 2>$null
    Write-Host "  GitHub MCP: Kuruldu (terminali kapat-ac)" -ForegroundColor Green
} else {
    Write-Host "  GitHub MCP: Atlandı" -ForegroundColor Yellow
}

# --- DOĞRULAMA ---
Write-Host ""
Write-Host "[7/7] Doğrulama..." -ForegroundColor Yellow
Write-Host ""
claude mcp list 2>$null
Write-Host ""

# --- TAMAMLANDI ---
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  KURULUM TAMAMLANDI!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Kullanim:" -ForegroundColor White
Write-Host '  1. Yeni klasor olustur: mkdir C:\Users\stare\Desktop\yeni-proje' -ForegroundColor Gray
Write-Host '  2. Klasore gir: cd C:\Users\stare\Desktop\yeni-proje' -ForegroundColor Gray
Write-Host '  3. Claude Code ac: claude' -ForegroundColor Gray
Write-Host '  4. Soyle: "/uygulama-yap Keman akort uygulamasi, offline, Flutter"' -ForegroundColor Gray
Write-Host '     veya: "/uygulama-yap E-ticaret uygulamasi, Firebase, React"' -ForegroundColor Gray
Write-Host ""
Write-Host "Kit klasoru: $skillDir" -ForegroundColor Gray
Write-Host ""
