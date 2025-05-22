@echo off

REM Create third_party directory if it doesn't exist
if not exist third_party mkdir third_party
cd third_party

REM Check if crashpad directory already exists
if not exist crashpad (
  echo Fetching Crashpad using depot_tools...
  call fetch crashpad
  cd crashpad
) else (
  echo Crashpad already exists, updating...
  cd crashpad
  call git checkout main
  call git pull
  call gclient sync
)

REM Generate build files with GN
echo Generating build files with GN...
call gn gen out/win --args="is_debug=false use_custom_libcxx=false"

REM Build
echo Building with Ninja...
call ninja -C out/win

echo Crashpad build complete. 