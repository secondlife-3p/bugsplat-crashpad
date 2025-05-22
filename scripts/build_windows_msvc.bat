@echo off
REM Create build directory if it doesn't exist
if not exist build mkdir build
cd build

REM Configure
cmake ..

REM Build
cmake --build . --config Release

echo Build complete. Run the application with: Release\MyCMakeCrasher.exe 