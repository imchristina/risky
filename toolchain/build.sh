source="main.c"

riscv64-elf-gcc -march=rv32im -mabi=ilp32 -nostdlib -ffreestanding -T memory_map.ld -c -o out.o $source

riscv32-elf-as -march=rv32i -mabi=ilp32 -o crt0.o crt0.s

riscv32-elf-ld -melf32lriscv -nostdlib -T memory_map.ld -o out.elf crt0.o out.o

riscv32-elf-objcopy -O binary out.elf out.bin

xxd -p -c1 out.bin out.hex
