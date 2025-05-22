# MyCMakeCrasher Project

A cross-platform application demonstrating Crashpad integration with CMake.

## About ℹ️

This project demonstrates how to:
- Set up a CMake project for cross-platform development
- Integrate Google's Crashpad library for crash reporting
- Create a simple crashing application that generates crash reports

## Prerequisites ☑️

- CMake (version 3.10 or higher)
- A C++ compiler (gcc, clang, MSVC, etc.)
- [depot_tools](https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up) - Google's tools for working with Chromium source code
- Ninja - part of depot_tools
- GN (Generate Ninja) - part of depot_tools
- A BugSplat account and database (sign up at [bugsplat.com](https://www.bugsplat.com))

## Configuration ⚙️

### BugSplat Setup

1. Sign up for a BugSplat account at [bugsplat.com](https://www.bugsplat.com) if you haven't already
2. Create a new database in your BugSplat dashboard
3. Open `main.h` and define your database name:
   ```cpp
   #define BUGSPLAT_DATABASE "your-database-name"  // Replace with your database name from BugSplat
   ```
   The database name can be found in your BugSplat dashboard URL: `https://app.bugsplat.com/v2/database/{database-name}`

### Installing depot_tools

1. Clone the depot_tools repository:

```bash
# For Linux/macOS
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
```

2. Add depot_tools to your PATH:

```bash
# For Linux/macOS - add to your .bashrc or .zshrc
export PATH="$PATH:/path/to/depot_tools"
```

```powershell
# For Windows - add to system environment variables or use:
$env:Path += ";C:\path\to\depot_tools"
```

3. For Windows, you also need to run:

```powershell
# From the depot_tools directory
gclient
```

## Building the Project 🏗️

The build scripts will automatically fetch and build Crashpad using depot_tools, then build the main application using CMake.

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

```powershell
# Execute the build script
.\scripts\build_windows_msvc.ps1

# Run the application
.\build\Debug\MyCMakeCrasher.exe
```

## Testing Crash Reporting 🧪

The application will crash immediately upon launch to demonstrate the crash reporting functionality. The crash reports will be stored in the `crashes` directory where you run the application.

## Project Structure 🗺️

- `main.cpp`: Main source file with Crashpad integration
- `main.h`: Header file with configuration defines
- `crash.cpp` and `crash.h`: Dynamic library that causes a crash
- `CMakeLists.txt`: CMake configuration file
- `scripts/`: Build scripts for different platforms
  - `build_macos.sh`: macOS build script
  - `build_linux.sh`: Linux build script
  - `build_windows_msvc.ps1`: Windows build script for MSVC
  - `build_crashpad_macos.sh`: Script to fetch and build Crashpad on macOS
  - `build_crashpad_linux.sh`: Script to fetch and build Crashpad on Linux
  - `build_crashpad_windows_msvc.ps1`: Script to fetch and build Crashpad on Windows
  - `upload_symbols.sh`: Symbol upload script for macOS/Linux
  - `upload_symbols.ps1`: Symbol upload script for Windows
- `third_party/`: Directory where Crashpad will be fetched and built 

## Symbol Uploads 📤

This project supports uploading debug symbols to BugSplat for improved crash reporting. The symbol upload process uses the official BugSplat symbol-upload utility, which is automatically downloaded as needed.

> **Note:** Before uploading symbols, ensure you have:
> 1. Configured your BugSplat database name in `main.h` as described in the [BugSplat Setup](#bugsplat-setup) section
> 2. Set up your BugSplat API credentials (`BUGSPLAT_CLIENT_ID` and `BUGSPLAT_CLIENT_SECRET`) in the `.env` file. You can find these in your BugSplat account settings under "API Keys"

### Using the Symbol Upload Scripts

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
   ```powershell
   # For Windows
   .\scripts\upload_symbols.ps1
   ```

### How It Works

- The scripts will automatically download the appropriate symbol-upload utility for your platform from BugSplat
- Windows: Uses symbol-upload-windows.exe for uploading `**/*.pdb` files
- macOS: Uses symbol-upload-macos for uploading `**/*.dSYM` files
- Linux: Uses symbol-upload-linux for uploading `**/*.debug` files

### Notes on Symbol Uploads

- The symbol upload feature uses the values defined in `main.h` for database, application name, and version
- Symbol files are platform-specific (.pdb for Windows, .dSYM for macOS, and .debug for Linux)
- Upload will be skipped if credentials are not provided
- Credentials are never stored in your source code