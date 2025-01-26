rm a.out out.vcd

if [[ $1 == "--testbench" ]]; then
    iverilog risky.v risky_testbench.v
elif [[ $1 == "--rom" ]]; then
    iverilog risky.v risky_rom.v
fi

vvp a.out

if [[ $2 == "--gtkwave" ]]; then
    gtkwave out.vcd
fi
