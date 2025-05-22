#!/bin/bash
set -e

# Check if depot_tools is in PATH
if ! command -v fetch &> /dev/null; then
    echo "ERROR: depot_tools not found in PATH"
    echo "Please install depot_tools and add it to your PATH:"
    echo "https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html"
    exit 1
fi

# Check if dsymutil is available
if ! command -v dsymutil &> /dev/null; then
    echo "ERROR: dsymutil not found"
    echo "Please ensure you have Xcode command line tools installed:"
    echo "xcode-select --install"
    exit 1
fi

# First build Crashpad
echo "Building Crashpad..."
./scripts/build_crashpad_macos.sh

# Create build directory if it doesn't exist
echo "Building MyCMakeCrasher..."
mkdir -p build
cd build

# Configure and build with Debug mode for better symbol generation
echo "Configuring with Debug symbols for better crash reporting..."
cmake .. -DCMAKE_BUILD_TYPE=Debug
make

echo "Build complete. Run the application with: ./MyCMakeCrasher"

# Verify dSYM bundles were created
if [ ! -d "MyCMakeCrasher.dSYM" ] || [ ! -d "libcrash.dylib.dSYM" ]; then
    echo "Warning: dSYM bundles not found. Attempting to generate them..."
    dsymutil ./MyCMakeCrasher
    dsymutil ./libcrash.dylib
fi

# Return to root directory
cd .. 