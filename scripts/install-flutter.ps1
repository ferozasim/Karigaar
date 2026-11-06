# Automated Flutter SDK Installer for Windows (No Admin Rights Required)
# Installs to user directory and configures User PATH environment variable

param (
    [string]$TargetDir = "$env:USERPROFILE\development\flutter",
    [string]$Branch = "stable"
)

$ErrorActionPreference = "Stop"

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "         AUTOMATED FLUTTER SDK INSTALLER               " -ForegroundColor Yellow
Write-Host "=======================================================`n" -ForegroundColor Cyan

# 1. Check if git is available
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] Git is not installed or not in PATH. Please install Git first." -ForegroundColor Red
    exit 1
}

$flutterBin = Join-Path $TargetDir "bin"
$parentDir = Split-Path -Parent $TargetDir

# 2. Check if Flutter is already installed at target location
if (Test-Path (Join-Path $flutterBin "flutter.bat")) {
    Write-Host "[INFO] Flutter is already present at $TargetDir" -ForegroundColor Green
} else {
    Write-Host "[INFO] Installing Flutter ($Branch channel) to $TargetDir ..." -ForegroundColor Cyan
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    if (Test-Path $TargetDir) {
        Write-Host "[WARN] Found incomplete Flutter directory. Cleaning up before clone..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force $TargetDir -ErrorAction SilentlyContinue
    }

    Write-Host "[INFO] Cloning Flutter repository from GitHub (shallow clone for speed)..." -ForegroundColor Cyan
    git clone --depth 1 -b $Branch https://github.com/flutter/flutter.git $TargetDir
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to clone Flutter repository." -ForegroundColor Red
        exit 1
    }
}

# 3. Add to User Environment PATH permanently
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$flutterBin*") {
    Write-Host "[INFO] Adding $flutterBin to User PATH permanently..." -ForegroundColor Cyan
    $newPath = if ($userPath) { "$userPath;$flutterBin" } else { $flutterBin }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "[PASS] User PATH updated permanently." -ForegroundColor Green
} else {
    Write-Host "[INFO] $flutterBin is already in User PATH." -ForegroundColor Yellow
}

# 4. Update current session PATH
$env:Path = "$flutterBin;$env:Path"

# 5. Disable analytics and initialize
Write-Host "[INFO] Initializing Flutter and checking dependencies..." -ForegroundColor Cyan
& (Join-Path $flutterBin "flutter.bat") config --no-analytics
& (Join-Path $flutterBin "flutter.bat") doctor -v

Write-Host "`n[SUCCESS] Flutter SDK setup complete!" -ForegroundColor Green
Write-Host "Restart your terminal/IDE or refresh environment to use 'flutter' everywhere.`n" -ForegroundColor Yellow
