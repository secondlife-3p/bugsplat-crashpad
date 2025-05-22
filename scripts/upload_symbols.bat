@echo off
:: Script to upload symbols to BugSplat for Windows

:: Get script directory and root directory
set "SCRIPT_DIR=%~dp0"
set "ROOT_DIR=%SCRIPT_DIR%.."

:: Check if .env file exists
if exist "%ROOT_DIR%\.env" (
    echo Loading environment from .env file...
    for /f "tokens=*" %%i in (%ROOT_DIR%\.env) do set %%i
) else (
    echo Warning: .env file not found. Make sure you have set BUGSPLAT_CLIENT_ID and BUGSPLAT_CLIENT_SECRET environment variables.
)

:: Check if credentials are set
if "%BUGSPLAT_CLIENT_ID%"=="" (
    echo Error: BUGSPLAT_CLIENT_ID not found.
    echo Please set BUGSPLAT_CLIENT_ID environment variable or create a .env file.
    exit /b 1
)

if "%BUGSPLAT_CLIENT_SECRET%"=="" (
    echo Error: BUGSPLAT_CLIENT_SECRET not found.
    echo Please set BUGSPLAT_CLIENT_SECRET environment variable or create a .env file.
    exit /b 1
)

:: Determine build directory
set "BUILD_DIR=%ROOT_DIR%\build"
if not exist "%BUILD_DIR%" (
    echo Error: Build directory not found. Please build the project first.
    exit /b 1
)

:: Extract configuration from main.h
set "MAIN_H=%ROOT_DIR%\main.h"
if not exist "%MAIN_H%" (
    echo Error: main.h not found.
    exit /b 1
)

:: Extract values from main.h using PowerShell
for /f "tokens=*" %%a in ('powershell -Command "& {Get-Content '%MAIN_H%' | Select-String 'BUGSPLAT_DATABASE' | Select-String -Pattern '\".*\"' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value.Trim('\"') }}"') do set DATABASE=%%a
for /f "tokens=*" %%a in ('powershell -Command "& {Get-Content '%MAIN_H%' | Select-String 'BUGSPLAT_APP_NAME' | Select-String -Pattern '\".*\"' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value.Trim('\"') }}"') do set APP_NAME=%%a
for /f "tokens=*" %%a in ('powershell -Command "& {Get-Content '%MAIN_H%' | Select-String 'BUGSPLAT_APP_VERSION' | Select-String -Pattern '\".*\"' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value.Trim('\"') }}"') do set APP_VERSION=%%a

if "%DATABASE%"=="" (
    echo Error: Could not extract BUGSPLAT_DATABASE from main.h.
    exit /b 1
)
if "%APP_NAME%"=="" (
    echo Error: Could not extract BUGSPLAT_APP_NAME from main.h.
    exit /b 1
)
if "%APP_VERSION%"=="" (
    echo Error: Could not extract BUGSPLAT_APP_VERSION from main.h.
    exit /b 1
)

echo Database: %DATABASE%
echo App Name: %APP_NAME%
echo Version: %APP_VERSION%

:: Execute the PowerShell script for Windows symbol upload
echo Running Windows symbol upload script...
powershell -ExecutionPolicy Bypass -File "%SCRIPT_DIR%\symbol_upload_windows.ps1" -database "%DATABASE%" -appName "%APP_NAME%" -version "%APP_VERSION%" -symbolsDir "%BUILD_DIR%" -clientId "%BUGSPLAT_CLIENT_ID%" -clientSecret "%BUGSPLAT_CLIENT_SECRET%"

:: Check result
if %ERRORLEVEL% neq 0 (
    echo Symbol upload failed. Please check your credentials and network connection.
    exit /b 1
) else (
    echo Symbol upload completed successfully.
) 