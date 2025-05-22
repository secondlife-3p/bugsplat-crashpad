#!/bin/bash
set -e

# Create build directory if it doesn't exist
mkdir -p build
cd build

# Configure and build
cmake ..
make

echo "Build complete. Run the application with: ./MyCMakeCrasher" 