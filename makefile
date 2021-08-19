check: check_verilator check_iverilog
check_iverilog:
	iverilog -Wall -o /dev/null -i risky.vh -i risky_*.v risky.v
check_verilator:
	verilator -Wall --lint-only risky.vh risky_*.v risky.v
