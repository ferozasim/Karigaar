# Automated Android SDK & Command-line Tools Installer for Windows
# Installs commandline-tools, platform-tools, build-tools without Android Studio dependency

param (
    [string]$SdkRoot = "$env:LOCALAPPDATA\Android\Sdk",
    [string]$CmdlineToolsVersion = "11076708_latest" # Latest stable official Google build
)

$ErrorActionPreference = "Stop"

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "       AUTOMATED ANDROID SDK SETUP (USER LEVEL)        " -ForegroundColor Yellow
Write-Host "=======================================================`n" -ForegroundColor Cyan

# Ensure JAVA_HOME is resolved from environment or registry
if (-not $env:JAVA_HOME) {
    $env:JAVA_HOME = [Environment]::GetEnvironmentVariable("JAVA_HOME", "User")
}
if (-not $env:JAVA_HOME -and (Test-Path "$env:USERPROFILE\development\jdk-17")) {
    $env:JAVA_HOME = "$env:USERPROFILE\development\jdk-17"
}
if ($env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME "bin"))) {
    $javaBin = Join-Path $env:JAVA_HOME "bin"
    if ($env:Path -split ';' -notcontains $javaBin) {
        $env:Path = "$javaBin;$env:Path"
    }
}

# 0. Ensure JAVA_HOME is configured for current session
if (-not $env:JAVA_HOME) {
    if (Test-Path "$env:USERPROFILE\development\jdk-17") {
        $env:JAVA_HOME = "$env:USERPROFILE\development\jdk-17"
    } else {
        $env:JAVA_HOME = [Environment]::GetEnvironmentVariable("JAVA_HOME", "User")
    }
}
if ($env:JAVA_HOME -and (Test-Path "$env:JAVA_HOME\bin")) {
    $env:Path = "$env:JAVA_HOME\bin;$env:Path"
}
$cmdlineDir = Join-Path $SdkRoot "cmdline-tools"
$latestDir = Join-Path $cmdlineDir "latest"
$binDir = Join-Path $latestDir "bin"
$platformTools = Join-Path $SdkRoot "platform-tools"

if (-not (Test-Path $SdkRoot)) {
    New-Item -ItemType Directory -Path $SdkRoot -Force | Out-Null
}

# 2. Check if cmdline-tools is already installed
if (-not (Test-Path (Join-Path $binDir "sdkmanager.bat"))) {
    Write-Host "[INFO] Downloading Android Command-line Tools from Google..." -ForegroundColor Cyan
    $zipUrl = "https://dl.google.com/android/repository/commandlinetools-win-${CmdlineToolsVersion}.zip"
    $tempZip = Join-Path $env:TEMP "android-cmdline-tools.zip"
    $tempExtract = Join-Path $env:TEMP "cmdline-tools-extract"

    $ProgressPreference = "SilentlyContinue"
    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
    Write-Host "[INFO] Extracting command-line tools..." -ForegroundColor Cyan

    if (Test-Path $tempExtract) { Remove-Item -Recurse -Force $tempExtract }
    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

    if (-not (Test-Path $cmdlineDir)) {
        New-Item -ItemType Directory -Path $cmdlineDir -Force | Out-Null
    }

    if (Test-Path $latestDir) { Remove-Item -Recurse -Force $latestDir }
    New-Item -ItemType Directory -Path $latestDir -Force | Out-Null

    Copy-Item -Path (Join-Path $tempExtract "cmdline-tools\*") -Destination $latestDir -Recurse -Force

    Remove-Item -Force $tempZip -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force $tempExtract -ErrorAction SilentlyContinue
    Write-Host "[PASS] Command-line tools installed to $latestDir" -ForegroundColor Green
} else {
    Write-Host "[INFO] Android Command-line Tools already present at $latestDir" -ForegroundColor Green
}

# 3. Configure User Environment Variables
Write-Host "[INFO] Setting ANDROID_HOME and PATH in User environment..." -ForegroundColor Cyan
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $SdkRoot, "User")
[Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $SdkRoot, "User")

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathsToAdd = @($binDir, $platformTools)

foreach ($p in $pathsToAdd) {
    if ($userPath -notlike "*$p*") {
        $userPath = "$userPath;$p"
    }
}
[Environment]::SetEnvironmentVariable("Path", $userPath, "User")

# Set current session environment
$env:ANDROID_HOME = $SdkRoot
$env:ANDROID_SDK_ROOT = $SdkRoot
$env:Path = "$binDir;$platformTools;$env:Path"

# 4. Accept licenses and install platform-tools and API 34
$sdkManagerBat = Join-Path $binDir "sdkmanager.bat"
if (Test-Path $sdkManagerBat) {
    Write-Host "[INFO] Accepting licenses and installing platform-tools, build-tools;34.0.0, platforms;android-34..." -ForegroundColor Cyan
    $acceptLicenses = ("y`r`n" * 30)
    $acceptLicenses | & cmd /c "`"$sdkManagerBat`" --licenses"
    & cmd /c "`"$sdkManagerBat`" `"platform-tools`" `"platforms;android-34`" `"build-tools;34.0.0`""
}

# 5. Configure Flutter with Android SDK and JDK paths
$flutterBat = "$env:USERPROFILE\development\flutter\bin\flutter.bat"
if (Test-Path $flutterBat) {
    Write-Host "[INFO] Pointing Flutter to Android SDK & JDK..." -ForegroundColor Cyan
    & $flutterBat config --android-sdk "$SdkRoot"
    if ($env:JAVA_HOME) {
        & $flutterBat config --jdk-dir "$env:JAVA_HOME"
    }
}

Write-Host "`n[SUCCESS] Android SDK installation and configuration complete!" -ForegroundColor Green
