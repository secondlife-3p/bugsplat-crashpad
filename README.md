# MyCMakeCrasher Project

A cross-platform application demonstrating Crashpad integration with CMake.

## About

This project demonstrates how to:
- Set up a CMake project for cross-platform development
- Integrate Google's Crashpad library for crash reporting
- Create a simple crashing application that generates crash reports

## Prerequisites

- CMake (version 3.10 or higher)
- A C++ compiler (gcc, clang, MSVC, etc.)
- [depot_tools](https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up) - Google's tools for working with Chromium source code
- Ninja - part of depot_tools
- GN (Generate Ninja) - part of depot_tools

### Installing depot_tools

1. Clone the depot_tools repository:

```bash
# For Linux/macOS
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
```

```cmd
:: For Windows
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
```

2. Add depot_tools to your PATH:

```bash
# For Linux/macOS - add to your .bashrc or .zshrc
export PATH="$PATH:/path/to/depot_tools"
```

```cmd
:: For Windows - add to system environment variables or use:
set PATH=%PATH%;C:\path\to\depot_tools
```

3. For Windows, you also need to run:

```cmd
:: From the depot_tools directory
gclient
```

## Building the Project

The build scripts will automatically fetch and build Crashpad using depot_tools, then build the main application using CMake.

Note: The build scripts will upload symbols to BugSplat by default. Make sure you've set up your BugSplat credentials in a `.env` file as described in the Symbol Uploads section below.

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

```cmd
# Execute the build script
scripts\build_windows_msvc.bat

# Run the application
build\Release\MyCMakeCrasher.exe
```

### Skipping Symbol Uploads

If you want to skip symbol uploads during the build process, you can add the `--skip-symbols` parameter to any of the build scripts:

```bash
# For macOS
./scripts/build_macos.sh --skip-symbols

# For Linux
./scripts/build_linux.sh --skip-symbols
```

```cmd
:: For Windows
scripts\build_windows_msvc.bat --skip-symbols
```

## Testing Crash Reporting

The application is set up to crash when you press Enter. The crash reports will be stored in the `crashes` directory where you run the application.

## Project Structure

- `main.cpp`: Main source file with Crashpad integration
- `main.h`: Header file with configuration defines
- `crash.cpp` and `crash.h`: Dynamic library that causes a crash
- `CMakeLists.txt`: CMake configuration file
- `scripts/`: Build scripts for different platforms
  - `build_macos.sh`: macOS build script
  - `build_linux.sh`: Linux build script
  - `build_windows_msvc.bat`: Windows build script for MSVC
  - `build_crashpad_macos.sh`: Script to fetch and build Crashpad on macOS
  - `build_crashpad_linux.sh`: Script to fetch and build Crashpad on Linux
  - `build_crashpad_windows_msvc.bat`: Script to fetch and build Crashpad on Windows
- `third_party/`: Directory where Crashpad will be fetched and built 

## Symbol Uploads

This project supports uploading debug symbols to BugSplat for improved crash reporting. The symbol upload process uses the official BugSplat symbol-upload utility, which is automatically downloaded as needed.

### Option 1: Using the Wrapper Scripts (Recommended)

The simplest way to upload symbols is to use the wrapper scripts:

1. Copy `env.example` to `.env` and add your BugSplat credentials:
   ```
   BUGSPLAT_CLIENT_ID=your-client-id-here
   BUGSPLAT_CLIENT_SECRET=your-client-secret-here
   ```

2. Run the appropriate script for your platform:
   ```bash
   # For Linux/macOS
   ./scripts/upload_symbols.sh
   ```
   ```cmd
   :: For Windows
   scripts\upload_symbols.bat
   ```

### Option 2: Using CMake Custom Target

You can also use the CMake custom target:

1. Source the environment variables before running CMake:
   ```bash
   # For Linux/macOS
   source .env && cmake -B build
   ```
   ```cmd
   :: For Windows
   for /f "tokens=*" %i in (.env) do set %i
   cmake -B build
   ```

2. Upload symbols with the custom target:
   ```bash
   cmake --build build --target upload_symbols
   ```

### How It Works

- The scripts will automatically download the appropriate symbol-upload utility for your platform from BugSplat
- Windows: Uses symbol-upload-windows.exe for uploading .pdb files
- macOS: Uses symbol-upload-macos for uploading .dSYM files
- Linux: Uses symbol-upload-linux for uploading debug symbols

### Notes on Symbol Uploads

- The symbol upload feature uses the values defined in `main.h` for database, application name, and version
- Symbol files are platform-specific (.pdb for Windows, .dSYM for macOS, and the executable for Linux)
- Upload will be skipped if credentials are not provided
- Credentials are never stored in your source code 