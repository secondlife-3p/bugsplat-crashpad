#!/bin/bash
set -e

# Check if depot_tools is in PATH
if ! command -v fetch &> /dev/null; then
    echo "ERROR: depot_tools not found in PATH"
    echo "Please install depot_tools and add it to your PATH:"
    echo "https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html"
    exit 1
fi

# First build Crashpad for ARM64
echo "Building Crashpad for ARM64..."
./scripts/build_crashpad_linux_arm64.sh

# Create build directory if it doesn't exist
echo "Building MyCMakeCrasher for ARM64..."
mkdir -p build-arm64
cd build-arm64

# Configure and build with Debug mode for better symbol generation
# Set up cross-compilation toolchain for ARM64
echo "Configuring with Debug symbols for better crash reporting (ARM64)..."
cmake .. -DCMAKE_BUILD_TYPE=Debug \
         -DCMAKE_SYSTEM_NAME=Linux \
         -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
         -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc \
         -DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++
make

echo "ARM64 build complete. Run the application on ARM64 system with: ./build-arm64/Debug/MyCMakeCrasher"

# Return to root directory
cd .. 