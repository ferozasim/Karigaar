# Karigaar Master Workspace Setup & SDK Installer
# Orchestrates complete installation of Flutter SDK, Android SDK, and Firebase CLI

param (
    [switch]$SkipJava,
    [switch]$SkipFlutter,
    [switch]$SkipAndroid,
    [switch]$SkipAndroidStudio,
    [switch]$SkipFirebase
)

$ErrorActionPreference = "Continue"

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "       KARIGAAR MASTER WORKSPACE & SDK SETUP           " -ForegroundColor Yellow
Write-Host "=======================================================`n" -ForegroundColor Cyan

$scriptRoot = $PSScriptRoot

function Update-SessionEnvironment {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $combinedPath = "$userPath;$machinePath"
    foreach ($p in ($combinedPath -split ';')) {
        if ($p -and ($env:Path -split ';' -notcontains $p)) {
            $env:Path = "$p;$env:Path"
        }
    }
    $env:JAVA_HOME = [Environment]::GetEnvironmentVariable("JAVA_HOME", "User")
    if (-not $env:JAVA_HOME -and (Test-Path "$env:USERPROFILE\development\jdk-17")) {
        $env:JAVA_HOME = "$env:USERPROFILE\development\jdk-17"
    }
    $env:ANDROID_HOME = [Environment]::GetEnvironmentVariable("ANDROID_HOME", "User")
    if (-not $env:ANDROID_HOME -and (Test-Path "$env:LOCALAPPDATA\Android\Sdk")) {
        $env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
    }
    $env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
}

# 1. Firebase Tools
if (-not $SkipFirebase) {
    if (-not (Get-Command firebase -ErrorAction SilentlyContinue)) {
        Write-Host "[INFO] Installing Firebase CLI globally via npm..." -ForegroundColor Cyan
        npm install -g firebase-tools
    } else {
        Write-Host "[PASS] Firebase CLI is already installed." -ForegroundColor Green
    }
}
Update-SessionEnvironment

# 2. Java OpenJDK Setup
if (-not $SkipJava) {
    $javaScript = Join-Path $scriptRoot "install-java.ps1"
    if (Test-Path $javaScript) {
        Write-Host "`n[STEP 1/4] Invoking OpenJDK 17 Installer..." -ForegroundColor Cyan
        & powershell -ExecutionPolicy Bypass -File $javaScript
    }
}
Update-SessionEnvironment

# 3. Flutter SDK Setup
if (-not $SkipFlutter) {
    $flutterScript = Join-Path $scriptRoot "install-flutter.ps1"
    if (Test-Path $flutterScript) {
        Write-Host "`n[STEP 2/4] Invoking Flutter SDK Installer..." -ForegroundColor Cyan
        & powershell -ExecutionPolicy Bypass -File $flutterScript
    }
}
Update-SessionEnvironment

# 4. Android SDK Setup
if (-not $SkipAndroid) {
    $androidScript = Join-Path $scriptRoot "install-android-sdk.ps1"
    if (Test-Path $androidScript) {
        Write-Host "`n[STEP 3/4] Invoking Android SDK Installer..." -ForegroundColor Cyan
        & powershell -ExecutionPolicy Bypass -File $androidScript
    }
}
Update-SessionEnvironment

# 5. Android Studio IDE Setup
if (-not $SkipAndroidStudio) {
    $studioScript = Join-Path $scriptRoot "install-android-studio.ps1"
    if (Test-Path $studioScript) {
        Write-Host "`n[STEP 4/4] Invoking Android Studio Installer..." -ForegroundColor Cyan
        & powershell -ExecutionPolicy Bypass -File $studioScript
    }
}
Update-SessionEnvironment

# 6. Final Environment Verification
$verifyScript = Join-Path $scriptRoot "verify-env.ps1"
if (Test-Path $verifyScript) {
    Write-Host "`n[FINAL STEP] Executing Environment Health Check..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File $verifyScript
}

Write-Host "`nSetup script finished. If you opened a new terminal session, the new PATH variables will take effect." -ForegroundColor Green
