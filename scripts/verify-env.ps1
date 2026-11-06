# Karigaar Workspace Environment Verification Script
# Checks system readiness for Flutter Mobile App, Admin Web, and Firebase

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "     KARIGAAR WORKSPACE ENVIRONMENT VERIFICATION       " -ForegroundColor Yellow
Write-Host "=======================================================`n" -ForegroundColor Cyan

# Refresh environment variables from registry so newly installed tools are immediately detected
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$combinedPath = "$userPath;$machinePath"
foreach ($p in ($combinedPath -split ';')) {
    if ($p -and ($env:Path -split ';' -notcontains $p)) {
        $env:Path = "$p;$env:Path"
    }
}
if (-not $env:JAVA_HOME) {
    $env:JAVA_HOME = [Environment]::GetEnvironmentVariable("JAVA_HOME", "User")
}
if ($env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME "bin"))) {
    $javaBin = Join-Path $env:JAVA_HOME "bin"
    if ($env:Path -split ';' -notcontains $javaBin) {
        $env:Path = "$javaBin;$env:Path"
    }
}
if (-not $env:ANDROID_HOME) {
    $env:ANDROID_HOME = [Environment]::GetEnvironmentVariable("ANDROID_HOME", "User")
}

$statusReport = @()

function Test-Executable {
    param(
        [string]$Name,
        [string]$Command,
        [string]$VersionArg = "--version",
        [bool]$Required = $true
    )

    $cmd = Get-Command $Command -ErrorAction SilentlyContinue
    if ($cmd) {
        try {
            $ver = (Invoke-Expression "$Command $VersionArg" 2>&1 | Select-Object -First 1).ToString().Trim()
            Write-Host "[PASS] $Name is installed: $ver" -ForegroundColor Green
            return [PSCustomObject]@{ Tool = $Name; Status = "INSTALLED"; Version = $ver; Required = $Required }
        } catch {
            Write-Host "[PASS] $Name is found at $($cmd.Source)" -ForegroundColor Green
            return [PSCustomObject]@{ Tool = $Name; Status = "INSTALLED"; Version = "Found"; Required = $Required }
        }
    } else {
        if ($Required) {
            Write-Host "[FAIL] $Name is NOT found on PATH" -ForegroundColor Red
            return [PSCustomObject]@{ Tool = $Name; Status = "MISSING"; Version = "None"; Required = $Required }
        } else {
            Write-Host "[WARN] $Name is optional and not found on PATH" -ForegroundColor Yellow
            return [PSCustomObject]@{ Tool = $Name; Status = "OPTIONAL_MISSING"; Version = "None"; Required = $Required }
        }
    }
}

# 1. Base Development Tools
$statusReport += Test-Executable -Name "Git" -Command "git"
$statusReport += Test-Executable -Name "Node.js" -Command "node" -VersionArg "-v"
$statusReport += Test-Executable -Name "npm" -Command "npm" -VersionArg "-v"
$statusReport += Test-Executable -Name "Docker" -Command "docker" -VersionArg "--version" -Required $false

# 2. Flutter & Dart Ecosystem
$statusReport += Test-Executable -Name "Flutter SDK" -Command "flutter" -VersionArg "--version"
$statusReport += Test-Executable -Name "Dart SDK" -Command "dart" -VersionArg "--version"

# 3. Android & Java
$statusReport += Test-Executable -Name "Java JDK" -Command "java" -VersionArg "-version"
$androidHome = $env:ANDROID_HOME
if (-not $androidHome) { $androidHome = $env:ANDROID_SDK_ROOT }
if (-not $androidHome -and (Test-Path "$env:LOCALAPPDATA\Android\Sdk")) {
    $androidHome = "$env:LOCALAPPDATA\Android\Sdk"
}

if ($androidHome -and (Test-Path $androidHome)) {
    Write-Host "[PASS] Android SDK found at: $androidHome" -ForegroundColor Green
    $statusReport += [PSCustomObject]@{ Tool = "Android SDK"; Status = "INSTALLED"; Version = $androidHome; Required = $true }
} else {
    Write-Host "[FAIL] Android SDK is NOT installed or ANDROID_HOME is not set" -ForegroundColor Red
    $statusReport += [PSCustomObject]@{ Tool = "Android SDK"; Status = "MISSING"; Version = "None"; Required = $true }
}

# Android Studio IDE
$studioLocations = @(
    $env:ANDROID_STUDIO_PATH,
    "$env:USERPROFILE\development\android-studio",
    "C:\Program Files\Android\Android Studio"
)
$foundStudio = $null
foreach ($loc in $studioLocations) {
    if ($loc -and (Test-Path (Join-Path $loc "bin\studio64.exe"))) {
        $foundStudio = $loc
        break
    }
}
if ($foundStudio) {
    Write-Host "[PASS] Android Studio found at: $foundStudio" -ForegroundColor Green
    $statusReport += [PSCustomObject]@{ Tool = "Android Studio"; Status = "INSTALLED"; Version = $foundStudio; Required = $false }
} else {
    Write-Host "[WARN] Android Studio is not detected at standard locations" -ForegroundColor Yellow
    $statusReport += [PSCustomObject]@{ Tool = "Android Studio"; Status = "OPTIONAL_MISSING"; Version = "None"; Required = $false }
}

# 4. Firebase CLI
$statusReport += Test-Executable -Name "Firebase CLI" -Command "firebase" -VersionArg "--version" -Required $false

Write-Host "`n-------------------------------------------------------" -ForegroundColor Cyan
Write-Host "                SUMMARY OF ENVIRONMENT                 " -ForegroundColor Cyan
Write-Host "-------------------------------------------------------" -ForegroundColor Cyan

$missingRequired = $statusReport | Where-Object { $_.Required -eq $true -and $_.Status -eq "MISSING" }

if ($missingRequired.Count -eq 0) {
    Write-Host "`nAll core development dependencies are satisfied! You are ready to build." -ForegroundColor Green
} else {
    Write-Host "`nMissing required components detected: $($missingRequired.Tool -join ', ')" -ForegroundColor Yellow
    Write-Host "`nTo automatically install and configure missing SDKs without admin rights, run:" -ForegroundColor White
    Write-Host "   powershell -ExecutionPolicy Bypass -File .\scripts\setup-environment.ps1`n" -ForegroundColor Cyan
}
