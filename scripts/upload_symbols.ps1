# Script to upload symbols to BugSplat for Windows

# Get script directory and root directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent $scriptDir

# Check if .env file exists
$envFile = Join-Path $rootDir ".env"
if (Test-Path $envFile) {
    Write-Host "Loading environment from .env file..."
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '(.+)=(.+)') {
            $key = $matches[1]
            $value = $matches[2]
            Set-Item -Path "Env:$key" -Value $value
        }
    }
} else {
    Write-Host "Warning: .env file not found. Make sure you have set BUGSPLAT_CLIENT_ID and BUGSPLAT_CLIENT_SECRET environment variables."
}

# Check if credentials are set
if (-not $env:BUGSPLAT_CLIENT_ID) {
    Write-Error "Error: BUGSPLAT_CLIENT_ID not found. Please set BUGSPLAT_CLIENT_ID environment variable or create a .env file."
    exit 1
}

if (-not $env:BUGSPLAT_CLIENT_SECRET) {
    Write-Error "Error: BUGSPLAT_CLIENT_SECRET not found. Please set BUGSPLAT_CLIENT_SECRET environment variable or create a .env file."
    exit 1
}

# Determine build directory
$buildDir = Join-Path $rootDir "build"
if (-not (Test-Path $buildDir)) {
    Write-Error "Error: Build directory not found. Please build the project first."
    exit 1
}

# Extract configuration from main.h
$mainH = Join-Path $rootDir "main.h"
if (-not (Test-Path $mainH)) {
    Write-Error "Error: main.h not found."
    exit 1
}

# Extract values from main.h
$mainContent = Get-Content $mainH
$database = $mainContent | Select-String 'BUGSPLAT_DATABASE' | Select-String -Pattern '"([^"]+)"' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value }
$appName = $mainContent | Select-String 'BUGSPLAT_APP_NAME' | Select-String -Pattern '"([^"]+)"' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value }
$appVersion = $mainContent | Select-String 'BUGSPLAT_APP_VERSION' | Select-String -Pattern '"([^"]+)"' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value }

if (-not $database) {
    Write-Error "Error: Could not extract BUGSPLAT_DATABASE from main.h."
    exit 1
}
if (-not $appName) {
    Write-Error "Error: Could not extract BUGSPLAT_APP_NAME from main.h."
    exit 1
}
if (-not $appVersion) {
    Write-Error "Error: Could not extract BUGSPLAT_APP_VERSION from main.h."
    exit 1
}

Write-Host "Database: $database"
Write-Host "App Name: $appName"
Write-Host "Version: $appVersion"

# Execute the PowerShell script for Windows symbol upload
Write-Host "Running Windows symbol upload script..."
$symbolUploadScript = Join-Path $scriptDir "symbol_upload_windows.ps1"
& $symbolUploadScript -database $database -appName $appName -version $appVersion -symbolsDir $buildDir -clientId $env:BUGSPLAT_CLIENT_ID -clientSecret $env:BUGSPLAT_CLIENT_SECRET

if ($LASTEXITCODE -ne 0) {
    Write-Error "Symbol upload failed. Please check your credentials and network connection."
    exit $LASTEXITCODE
} else {
    Write-Host "Symbol upload completed successfully."
} 