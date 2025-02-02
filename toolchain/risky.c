#define DATA_ADDR_OUT ((volatile int*)0x20000008)
#define ACK_ADDR_OUT ((volatile int*)0x2000000C)
#define DATA_ADDR_IN ((volatile int*)0x20000010)
#define ACK_ADDR_IN ((volatile int*)0x20000014)

void putchar(const char in) {
    *DATA_ADDR_OUT = in;
    *ACK_ADDR_OUT = 1;

    while (*ACK_ADDR_OUT == 1) {}
}

void print(const char *str) {
    while (*str) {
        putchar(*str);
        str++;
    }
}

char* num_to_hex(const int *value) {
    static char str[9];

    for (int i = 0; i < 8; i++) {
        char nibble = *value >> (28 - (i * 4));
        nibble = nibble & 0b00001111;
        if (nibble < 10) {
            str[i] = nibble + '0';
        } else {
            str[i] = (nibble - 10) + 'A';
        }
    }

    str[8] = 0; // Null termination

    return str;
}

void printf(const char *str, int value) {
    int found_format = 0;
    while (*str) {
        if (*str != '%' && !found_format) {
            putchar(*str);
        } else if (!found_format) {
            found_format = 1;
        } else {
            switch (*str) {
                case 'X':
                case 'x':
                    print(num_to_hex(&value));
                    break;
                case '%':
                    putchar(*str);
                    break;
            }
            found_format = 0;
        }
        str++;
    }
}

char getchar() {
    *ACK_ADDR_IN = 1;
    while (*ACK_ADDR_IN == 1) {}
    return *DATA_ADDR_IN;
}

void getline(char *buffer, int max_len) {
    char ptr = 0;
    while (ptr < max_len-2) {
        buffer[ptr] = getchar();
        if (buffer[ptr] == '\n') {
            buffer[ptr + 1] = 0;
            break;
        } else {
            ptr++;
        }
    }

    if (ptr <= max_len-2) {
        buffer[max_len-1] = 0; // Ensure null termination
    }
}
