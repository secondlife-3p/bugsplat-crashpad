@echo off
REM Create build directory if it doesn't exist
if not exist build mkdir build
cd build

REM Configure and build
cmake .. -G "MinGW Makefiles"
mingw32-make

echo Build complete. Run the application with: MyCMakeCrasher.exe 