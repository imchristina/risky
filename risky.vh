// TODO convert everything to [MSB:LSB] instead of mask+shift

// Instruction bitmasks
`define RISKY_INST_MASK_OP        32'b00000000000000000000000001111111
`define RISKY_INST_MASK_RD        32'b00000000000000000000111110000000
`define RISKY_INST_MASK_F3        32'b00000000000000000111000000000000
`define RISKY_INST_MASK_RS1       32'b00000000000011111000000000000000
`define RISKY_INST_MASK_RS2       32'b00000001111100000000000000000000
`define RISKY_INST_MASK_F7        32'b11111110000000000000000000000000
`define RISKY_INST_MASK_IMM_I     32'b11111111111100000000000000000000
`define RISKY_INST_MASK_IMM_U     32'b11111111111111111111000000000000
`define RISKY_INST_MASK_IMM_S_H   `RISKY_INST_MASK_F7
`define RISKY_INST_MASK_IMM_S_L   `RISKY_INST_MASK_RD

// Instruction lengths
`define RISKY_INST_LEN_OP       5'd7
`define RISKY_INST_LEN_R        5'd5
`define RISKY_INST_LEN_F3       5'd3
`define RISKY_INST_LEN_F7       5'd7
`define RISKY_INST_LEN_IMM_I    5'd12
`define RISKY_INST_LEN_IMM_U    5'd20
`define RISKY_INST_LEN_IMM_S_H  `RISKY_INST_LEN_F7
`define RISKY_INST_LEN_IMM_S_L  `RISKY_INST_LEN_R

// Instruction shifts
`define RISKY_INST_SHIFT_RD       `RISKY_INST_LEN_R
`define RISKY_INST_SHIFT_F3       `RISKY_INST_SHIFT_RD + `RISKY_INST_LEN_F3
`define RISKY_INST_SHIFT_RS1      `RISKY_INST_SHIFT_F3 + `RISKY_INST_LEN_R
`define RISKY_INST_SHIFT_RS2      `RISKY_INST_SHIFT_RS1 + `RISKY_INST_LEN_R
`define RISKY_INST_SHIFT_F7       `RISKY_INST_SHIFT_RS2 + `RISKY_INST_LEN_F7
`define RISKY_INST_SHIFT_IMM_I    `RISKY_INST_SHIFT_RS1 + `RISKY_INST_LEN_IMM_I
`define RISKY_INST_SHIFT_IMM_U    `RISKY_INST_SHIFT_RD + `RISKY_INST_LEN_IMM_U
`define RISKY_INST_SHIFT_IMM_S_H  `RISKY_INST_SHIFT_F7
`define RISKY_INST_SHIFT_IMM_S_L  `RISKY_INST_SHIFT_RD

// Opcodes/instruction types
`define RISKY_INST_TYPE_R 7'b0110011
`define RISKY_INST_TYPE_I 7'b0010011
`define RISKY_INST_TYPE_B 7'b1100011
`define RISKY_INST_TYPE_U 7'b0x10111
`define RISKY_INST_TYPE_J 7'b1101111

// Function 3
`define RISKY_INST_F3_ACC     3'b000
`define RISKY_INST_F3_SLL     3'b001
`define RISKY_INST_F3_SLT     3'b010
`define RISKY_INST_F3_SLTU    3'b011
`define RISKY_INST_F3_XOR     3'b100
`define RISKY_INST_F3_SR      3'b101
`define RISKY_INST_F3_OR      3'b110
`define RISKY_INST_F3_AND     3'b111

// Function 7, 30th bit as all others are unused with the base ISA
`define RISKY_INST_F7_ADD 1'b0
`define RISKY_INST_F7_SUB 1'b1
`define RISKY_INST_F7_SRL 1'b0
`define RISKY_INST_F7_SRA 1'b1