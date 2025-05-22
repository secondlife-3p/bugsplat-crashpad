cmake_minimum_required(VERSION 3.10)

# Project name
project(MyCMakeCrasher VERSION 1.0)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Add executable
add_executable(MyCMakeCrasher main.cpp)

# Install target
install(TARGETS MyCMakeCrasher DESTINATION bin) 