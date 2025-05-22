@echo off

REM Check if symbol upload should be skipped
set UPLOAD_SYMBOLS=1
if "%1"=="--skip-symbols" (
    set UPLOAD_SYMBOLS=0
    echo Symbol uploads will be skipped
)

REM Check if depot_tools is in PATH
where fetch >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: depot_tools not found in PATH
    echo Please install depot_tools and add it to your PATH:
    echo https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html
    exit /b 1
)

REM First build Crashpad
echo Building Crashpad...
call scripts\build_crashpad_windows_msvc.bat

REM Create build directory if it doesn't exist
echo Building MyCMakeCrasher...
if not exist build mkdir build
cd build

REM Configure with Debug mode for better symbol generation
echo Configuring with Debug symbols for better crash reporting...
cmake .. -DCMAKE_BUILD_TYPE=Debug

REM Build Debug configuration
cmake --build . --config Debug

echo Build complete. Run the application with: Debug\MyCMakeCrasher.exe

REM Upload symbols by default unless skipped
if %UPLOAD_SYMBOLS%==1 (
    echo Uploading symbols...
    cd ..
    call scripts\upload_symbols.bat
) else (
    echo Symbol uploads skipped.
    cd ..
) 