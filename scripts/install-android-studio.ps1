# Automated Android Studio Installer for Windows (No Admin Rights Required)
# Downloads official Google portable Android Studio IDE, extracts to user directory,
# configures environment variables, updates Flutter config, and creates desktop shortcuts.

param (
    [string]$TargetDir = "$env:USERPROFILE\development\android-studio",
    [string]$DownloadUrl = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.2.2.9/android-studio-rabbit2-patch1-windows.zip"
)

$ErrorActionPreference = "Stop"

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "       AUTOMATED ANDROID STUDIO SETUP (USER LEVEL)     " -ForegroundColor Yellow
Write-Host "=======================================================`n" -ForegroundColor Cyan

$studioExe = Join-Path $TargetDir "bin\studio64.exe"

if (Test-Path $studioExe) {
    Write-Host "[INFO] Android Studio is already present at $TargetDir" -ForegroundColor Green
} else {
    $parentDir = Split-Path -Parent $TargetDir
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    $tempZip = Join-Path $env:TEMP "android-studio.zip"
    $tempExtract = Join-Path $env:TEMP "android-studio-extract"

    Write-Host "[INFO] Downloading Android Studio IDE (~1.4 GB) from Google..." -ForegroundColor Cyan
    Write-Host "       Source: $DownloadUrl" -ForegroundColor Gray

    # Using curl.exe with resume support for fast and reliable transfer
    & curl.exe -L --progress-bar -C - -o $tempZip $DownloadUrl
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to download Android Studio from $DownloadUrl (curl exit code: $LASTEXITCODE)"
    }

    Write-Host "`n[INFO] Extracting Android Studio archive..." -ForegroundColor Cyan
    if (Test-Path $tempExtract) { Remove-Item -Recurse -Force $tempExtract }
    New-Item -ItemType Directory -Path $tempExtract -Force | Out-Null

    # Use Windows tar.exe for high-speed extraction
    & tar.exe -xf $tempZip -C $tempExtract
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARN] tar extraction returned non-zero code, falling back to Expand-Archive..." -ForegroundColor Yellow
        Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force
    }

    $extractedStudio = Join-Path $tempExtract "android-studio"
    if (Test-Path $extractedStudio) {
        if (Test-Path $TargetDir) { Remove-Item -Recurse -Force $TargetDir }
        Move-Item -Path $extractedStudio -Destination $TargetDir -Force
    } elseif (Test-Path (Join-Path $tempExtract "bin\studio64.exe")) {
        if (Test-Path $TargetDir) { Remove-Item -Recurse -Force $TargetDir }
        Move-Item -Path $tempExtract -Destination $TargetDir -Force
    } else {
        throw "Could not find Android Studio folder in extracted archive"
    }

    # Clean up temporary archive and extract folder
    Remove-Item -Force $tempZip -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force $tempExtract -ErrorAction SilentlyContinue

    Write-Host "[PASS] Android Studio installed to $TargetDir" -ForegroundColor Green
}

# 2. Configure Environment Variables
Write-Host "[INFO] Configuring User Environment Variables..." -ForegroundColor Cyan
[Environment]::SetEnvironmentVariable("ANDROID_STUDIO_HOME", $TargetDir, "User")
[Environment]::SetEnvironmentVariable("ANDROID_STUDIO_PATH", $TargetDir, "User")

$binDir = Join-Path $TargetDir "bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$binDir*") {
    $newPath = if ($userPath) { "$userPath;$binDir" } else { $binDir }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
}

$env:ANDROID_STUDIO_HOME = $TargetDir
$env:ANDROID_STUDIO_PATH = $TargetDir
$env:Path = "$binDir;$env:Path"

# 3. Configure Flutter Android Studio Integration
$flutterBat = "$env:USERPROFILE\development\flutter\bin\flutter.bat"
if (Test-Path $flutterBat) {
    Write-Host "[INFO] Registering Android Studio directory with Flutter..." -ForegroundColor Cyan
    & $flutterBat config --android-studio-dir $TargetDir
}

# 4. Create Desktop & Start Menu Shortcuts
Write-Host "[INFO] Creating Desktop & Start Menu shortcuts..." -ForegroundColor Cyan
try {
    $wscript = New-Object -ComObject WScript.Shell

    # Start Menu Shortcut
    $startMenuDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
    if (Test-Path $startMenuDir) {
        $startMenuLnk = Join-Path $startMenuDir "Android Studio.lnk"
        $shortcut = $wscript.CreateShortcut($startMenuLnk)
        $shortcut.TargetPath = $studioExe
        $shortcut.WorkingDirectory = $binDir
        $shortcut.Description = "Android Studio IDE"
        $shortcut.Save()
        Write-Host "       Start Menu shortcut: $startMenuLnk" -ForegroundColor Gray
    }

    # Desktop Shortcut
    $desktopDir = [Environment]::GetFolderPath("Desktop")
    if (Test-Path $desktopDir) {
        $desktopLnk = Join-Path $desktopDir "Android Studio.lnk"
        $shortcut = $wscript.CreateShortcut($desktopLnk)
        $shortcut.TargetPath = $studioExe
        $shortcut.WorkingDirectory = $binDir
        $shortcut.Description = "Android Studio IDE"
        $shortcut.Save()
        Write-Host "       Desktop shortcut: $desktopLnk" -ForegroundColor Gray
    }
} catch {
    Write-Host "[WARN] Could not create shortcut: $_" -ForegroundColor Yellow
}

Write-Host "`n[SUCCESS] Android Studio setup completed successfully!" -ForegroundColor Green
