cmake_minimum_required(VERSION 3.10)
project(binary)

# Set C standard
set(CMAKE_C_STANDARD 99)

# Add source files
add_library(binary src/binary.c)

# Include directories
target_include_directories(binary PUBLIC include)

# Add the Unity testing framework
add_subdirectory(Unity)

# Add the tests
enable_testing()
add_subdirectory(tests)

