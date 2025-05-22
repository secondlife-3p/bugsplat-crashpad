# MyCMakeCrasher Project

A simple cross-platform Hello World application using CMake.

## Prerequisites

- CMake (version 3.10 or higher)
- A C++ compiler (gcc, clang, MSVC, etc.)

## Building the Project

### macOS

```bash
# Execute the build script
./scripts/build_macos.sh

# Run the application
./build/MyCMakeCrasher
```

### Linux

```bash
# Execute the build script
./scripts/build_linux.sh

# Run the application
./build/MyCMakeCrasher
```

### Windows

#### Using Command Prompt with MSVC

```cmd
# Execute the build script
scripts\build_windows_msvc.bat

# Run the application
build\Release\MyCMakeCrasher.exe
```

#### Using MinGW/MSYS

```cmd
# Execute the build script
scripts\build_windows_mingw.bat

# Run the application
build\MyCMakeCrasher.exe
```

## Project Structure

- `main.cpp`: Main source file
- `CMakeLists.txt`: CMake configuration file
- `scripts/`: Build scripts for different platforms
  - `build_macos.sh`: macOS build script
  - `build_linux.sh`: Linux build script
  - `build_windows_msvc.bat`: Windows build script for MSVC
  - `build_windows_mingw.bat`: Windows build script for MinGW 