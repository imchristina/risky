#include "risky.c"

int main(){
    print("Waiting for input: ");
    char in_str[32];
    in_str[31] = 0; // Ensure null termination
    char in_str_ptr = 0;
    while (in_str_ptr < 31) {
        in_str[in_str_ptr] = get_char();
        if (in_str[in_str_ptr] == '\n') {
            in_str[in_str_ptr + 1] = 0;
            break;
        } else {
            in_str_ptr++;
        }
    }

    print("Got input: ");

    print(in_str);

    return 0;
}
