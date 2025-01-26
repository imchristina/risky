#define DATA_ADDR_OUT ((volatile int*)0x20000008)
#define ACK_ADDR_OUT ((volatile int*)0x2000000C)
#define DATA_ADDR_IN ((volatile int*)0x20000010)
#define ACK_ADDR_IN ((volatile int*)0x20000014)

void put_char(const char *in) {
    *DATA_ADDR_OUT = *in;
    *ACK_ADDR_OUT = 1;

    while (*ACK_ADDR_OUT == 1) {}
}

void print(const char *str) {
    while (*str) {
        put_char(str);
        str++;
    }
}

char* num_to_hex(const int *value) {
    static char str[11];

    str[0] = '0';
    str[1] = 'x';

    for (int i = 0; i < 8; i++) {
        char nibble = *value >> (28 - (i * 4));
        nibble = nibble & 0b00001111;
        if (nibble < 10) {
            str[i+2] = nibble + '0';
        } else {
            str[i+2] = nibble + 'A';
        }
    }

    str[10] = 0; // Null termination

    return str;
}

void printf(const char *str, int value) {
    int found_format = 0;
    while (*str) {
        if (*str != '%' && !found_format) {
            put_char(str);
        } else if (!found_format) {
            found_format = 1;
        } else {
            switch (*str) {
                case 'H':
                    print(num_to_hex(&value));
                    break;
                case '%':
                    put_char(str);
                    break;
            }
            found_format = 0;
        }
        str++;
    }
}

char get_char() {
    *ACK_ADDR_IN = 1;
    while (*ACK_ADDR_IN == 1) {}
    return *DATA_ADDR_IN;
}
