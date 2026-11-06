# Karigaar Master Workspace Setup & SDK Installer
# Orchestrates complete installation of Flutter SDK, Android SDK, and Firebase CLI

param (
    [switch]$SkipJava,
    [switch]$SkipFlutter,
    [switch]$SkipAndroid,
    [switch]$SkipFirebase
)

$ErrorActionPreference = "Continue"

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "       KARIGAAR MASTER WORKSPACE & SDK SETUP           " -ForegroundColor Yellow
Write-Host "=======================================================`n" -ForegroundColor Cyan

$scriptRoot = $PSScriptRoot

# 1. Firebase Tools
if (-not $SkipFirebase) {
    if (-not (Get-Command firebase -ErrorAction SilentlyContinue)) {
        Write-Host "[INFO] Installing Firebase CLI globally via npm..." -ForegroundColor Cyan
        npm install -g firebase-tools
    } else {
        Write-Host "[PASS] Firebase CLI is already installed." -ForegroundColor Green
    }
}

# 2. Java OpenJDK Setup
if (-not $SkipJava) {
    $javaScript = Join-Path $scriptRoot "install-java.ps1"
    if (Test-Path $javaScript) {
        Write-Host "`n[STEP 1/3] Invoking OpenJDK 17 Installer..." -ForegroundColor Cyan
        & powershell -ExecutionPolicy Bypass -File $javaScript
    }
}

# 3. Flutter SDK Setup
if (-not $SkipFlutter) {
    $flutterScript = Join-Path $scriptRoot "install-flutter.ps1"
    if (Test-Path $flutterScript) {
        Write-Host "`n[STEP 2/3] Invoking Flutter SDK Installer..." -ForegroundColor Cyan
        & powershell -ExecutionPolicy Bypass -File $flutterScript
    }
}

# 4. Android SDK Setup
if (-not $SkipAndroid) {
    $androidScript = Join-Path $scriptRoot "install-android-sdk.ps1"
    if (Test-Path $androidScript) {
        Write-Host "`n[STEP 3/3] Invoking Android SDK Installer..." -ForegroundColor Cyan
        & powershell -ExecutionPolicy Bypass -File $androidScript
    }
}

# 4. Final Environment Verification
$verifyScript = Join-Path $scriptRoot "verify-env.ps1"
if (Test-Path $verifyScript) {
    Write-Host "`n[FINAL STEP] Executing Environment Health Check..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File $verifyScript
}

Write-Host "`nSetup script finished. If you opened a new terminal session, the new PATH variables will take effect." -ForegroundColor Green
