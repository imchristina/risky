#include "risky.c"

#define WIDTH  10
#define HEIGHT 10
#define MAX_ITER  16

#define FIXED_SHIFT 16

// Convert integer to fixed-point
#define INT_TO_FIXED(x) ((x) << FIXED_SHIFT)

// Multiply two fixed-point numbers
int fixed_mul(int a, int b) {
    return (int)(((long long)a * (long long)b) >> FIXED_SHIFT);
}

// Square a fixed-point number
int fixed_square(int x) {
    return fixed_mul(x, x);
}

void plot_mandelbrot(int width, int height) {
    int x, y;
    int min_x = INT_TO_FIXED(-2);
    int max_x = INT_TO_FIXED(1);
    int min_y = INT_TO_FIXED(-1);
    int max_y = INT_TO_FIXED(1);

    int dx = (max_x - min_x) / width;
    int dy = (max_y - min_y) / height;

    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            int cx = min_x + x * dx;
            int cy = min_y + y * dy;
            int zx = 0, zy = 0;
            int iter = 0;

            while (iter < MAX_ITER && (fixed_square(zx) + fixed_square(zy)) < INT_TO_FIXED(4)) {
                int zx_new = fixed_square(zx) - fixed_square(zy) + cx;
                zy = fixed_mul(INT_TO_FIXED(2), fixed_mul(zx, zy)) + cy;
                zx = zx_new;
                iter++;
            }

            char c = (iter == MAX_ITER) ? '#' : ' ';
            putchar(c);
        }
        putchar('\n');
    }
}

int main() {
    plot_mandelbrot(WIDTH, HEIGHT);
    return 0;
}
