#include "risky.c"

int main(){
    print("Waiting for input: ");
    char in_str[32];
    get_line(in_str, 32);

    print("Got input: ");
    print(in_str);

    return 0;
}
