#!/bin/bash
set -e

# Create third_party directory if it doesn't exist
mkdir -p third_party
cd third_party

# Check if crashpad directory already exists
if [ ! -d "crashpad" ]; then
  echo "Fetching Crashpad using depot_tools..."
  fetch crashpad
  cd crashpad
else
  echo "Crashpad already exists, updating..."
  cd crashpad
  git checkout main
  git pull
  gclient sync
fi

# Generate build files with GN for Debug configuration (ARM64)
echo "Generating Debug build files with GN for ARM64..."
gn gen out/linux-arm64-debug --args='is_debug=true target_cpu="arm64"'

# Generate build files with GN for Release configuration (ARM64)
echo "Generating Release build files with GN for ARM64..."
gn gen out/linux-arm64-release --args='is_debug=false target_cpu="arm64"'

# Build Debug
echo "Building Debug with Ninja for ARM64..."
ninja -C out/linux-arm64-debug

# Build Release
echo "Building Release with Ninja for ARM64..."
ninja -C out/linux-arm64-release

echo "Crashpad ARM64 Debug and Release builds complete." 