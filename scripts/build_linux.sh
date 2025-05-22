#!/bin/bash
set -e

# Check if symbol upload should be skipped
UPLOAD_SYMBOLS=1
if [ "$1" == "--skip-symbols" ]; then
    UPLOAD_SYMBOLS=0
    echo "Symbol uploads will be skipped"
fi

# Check if depot_tools is in PATH
if ! command -v fetch &> /dev/null; then
    echo "ERROR: depot_tools not found in PATH"
    echo "Please install depot_tools and add it to your PATH:"
    echo "https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html"
    exit 1
fi

# First build Crashpad
echo "Building Crashpad..."
./scripts/build_crashpad_linux.sh

# Create build directory if it doesn't exist
echo "Building MyCMakeCrasher..."
mkdir -p build
cd build

# Configure and build with Debug mode for better symbol generation
echo "Configuring with Debug symbols for better crash reporting..."
cmake .. -DCMAKE_BUILD_TYPE=Debug
make

echo "Build complete. Run the application with: ./MyCMakeCrasher"

# Upload symbols by default unless skipped
if [ $UPLOAD_SYMBOLS -eq 1 ]; then
    echo "Uploading symbols..."
    cd ..
    ./scripts/upload_symbols.sh
else
    echo "Symbol uploads skipped."
    cd ..
fi 