# Add the test executable
add_executable(test_binary test_binary.c)

# Link the Unity framework and your library to the test executable
target_link_libraries(test_binary PRIVATE unity binary)

# Add include directories for Unity and the library
target_include_directories(test_binary PRIVATE ${CMAKE_SOURCE_DIR}/Unity/src ${CMAKE_SOURCE_DIR}/include)

# Add the test to CTest
add_test(NAME test_binary COMMAND test_binary)

