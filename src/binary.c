#include "binary.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char* hex_char_to_bin(char hex) {
    switch (hex) {
        case '0': return "0000";
        case '1': return "0001";
        case '2': return "0010";
        case '3': return "0011";
        case '4': return "0100";
        case '5': return "0101";
        case '6': return "0110";
        case '7': return "0111";
        case '8': return "1000";
        case '9': return "1001";
        case 'A': case 'a': return "1010";
        case 'B': case 'b': return "1011";
        case 'C': case 'c': return "1100";
        case 'D': case 'd': return "1101";
        case 'E': case 'e': return "1110";
        case 'F': case 'f': return "1111";
        default: return INVALID_VALUE; 
    }
}

char* hex_to_bin(const char* hex) {
    size_t len = strlen(hex);
    char* bin = (char*)malloc(len * 4 + 1);
    bin[0] = '\0';

    if (len == 0) {
        strcat(bin, INVALID_VALUE);
    }

    for (size_t i = 0; i < len; i++) {
        //if (strcmp(hex_char_to_bin(hex[i]), INVALID_VALUE)) {
        //    return str;
        //}
        strcat(bin, hex_char_to_bin(hex[i]));
    }

    return bin;
}
