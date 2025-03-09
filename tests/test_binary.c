#include "unity.h"
#include "binary.h"
#include <stdlib.h>

// Setup and teardown functions
void setUp(void) {
    // Set up before each test
}

void tearDown(void) {
    // Clean up after each test
}

// Test cases
void test_valid_value(void) {
    char* bin = hex_to_bin("1A3F");
    printf("Input: 1A3F -> Output: %s\n", bin);
    TEST_ASSERT_NOT_NULL(bin);
    TEST_ASSERT_EQUAL_STRING("0001101000111111", bin);
    free(bin);
}

void test_valid_value_lower_case(void) {
    char* bin = hex_to_bin("1a3f");
    printf("Input: 1a3f -> Output: %s\n", bin);
    TEST_ASSERT_NOT_NULL(bin);
    TEST_ASSERT_EQUAL_STRING("0001101000111111", bin);
    free(bin);
}

void test_empty_string(void) {
    char* bin = hex_to_bin("");
    printf("Input: <empty-string> -> Output: %s\n", bin);
    TEST_ASSERT_EQUAL_STRING(INVALID_VALUE,bin);
    free(bin);
}

void test_invalid_value(void) {
    char* bin = hex_to_bin("1g3$");
    printf("Input: 1g3$ -> Output: %s\n", bin);
    TEST_ASSERT_EQUAL_STRING(INVALID_VALUE,bin);
    free(bin);
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_valid_value);
    RUN_TEST(test_valid_value_lower_case);
    RUN_TEST(test_empty_string);
    RUN_TEST(test_invalid_value);
    return UNITY_END();
}

