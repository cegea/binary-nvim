cmake_minimum_required(VERSION 3.5)

project(binary C)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(SOURCE_FILES binary.c)

add_library(binary SHARED ${SOURCE_FILES})

set_target_properties(binary PROPERTIES OUTPUT_NAME "binary")

