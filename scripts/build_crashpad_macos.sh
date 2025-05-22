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

# Generate build files with GN
echo "Generating build files with GN..."
gn gen out/macos --args="is_debug=false use_custom_libcxx=false"

# Build
echo "Building with Ninja..."
ninja -C out/macos

echo "Crashpad build complete." 