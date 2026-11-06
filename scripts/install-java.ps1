# Automated OpenJDK 17 Installer for Windows (No Admin Rights Required)
# Installs portable OpenJDK 17 to user directory and sets JAVA_HOME in User environment

param (
    [string]$TargetDir = "$env:USERPROFILE\development\jdk-17"
)

$ErrorActionPreference = "Stop"

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "       AUTOMATED OPENJDK 17 SETUP (USER LEVEL)         " -ForegroundColor Yellow
Write-Host "=======================================================`n" -ForegroundColor Cyan

$javaExe = Join-Path $TargetDir "bin\java.exe"

if (Test-Path $javaExe) {
    Write-Host "[INFO] OpenJDK 17 is already present at $TargetDir" -ForegroundColor Green
} else {
    Write-Host "[INFO] Downloading Eclipse Temurin OpenJDK 17 portable zip..." -ForegroundColor Cyan
    # Eclipse Temurin 17 LTS for Windows x64
    $downloadUrl = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.12%2B7/OpenJDK17U-jdk_x64_windows_hotspot_17.0.12_7.zip"
    $tempZip = Join-Path $env:TEMP "openjdk17.zip"
    $tempExtract = Join-Path $env:TEMP "openjdk17-extract"

    $ProgressPreference = "SilentlyContinue"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip -UseBasicParsing

    Write-Host "[INFO] Extracting OpenJDK 17..." -ForegroundColor Cyan
    if (Test-Path $tempExtract) { Remove-Item -Recurse -Force $tempExtract }
    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

    $extractedFolder = Get-ChildItem -Path $tempExtract -Directory | Select-Object -First 1

    $parentDir = Split-Path -Parent $TargetDir
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    if (Test-Path $TargetDir) { Remove-Item -Recurse -Force $TargetDir }
    Move-Item -Path $extractedFolder.FullName -Destination $TargetDir -Force

    Remove-Item -Force $tempZip -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force $tempExtract -ErrorAction SilentlyContinue
    Write-Host "[PASS] OpenJDK 17 installed to $TargetDir" -ForegroundColor Green
}

# Set JAVA_HOME and User PATH
Write-Host "[INFO] Setting JAVA_HOME and User PATH..." -ForegroundColor Cyan
[Environment]::SetEnvironmentVariable("JAVA_HOME", $TargetDir, "User")

$javaBin = Join-Path $TargetDir "bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$javaBin*") {
    $newPath = if ($userPath) { "$userPath;$javaBin" } else { $javaBin }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
}

$env:JAVA_HOME = $TargetDir
$env:Path = "$javaBin;$env:Path"

& (Join-Path $javaBin "java.exe") -version

Write-Host "`n[SUCCESS] OpenJDK 17 setup complete!" -ForegroundColor Green
