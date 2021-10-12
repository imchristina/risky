// Instruction bit selectors/masks
`define RISKY_INST_OP       6:0
`define RISKY_INST_RD       11:7
`define RISKY_INST_F3       14:12
`define RISKY_INST_RS1      19:15
`define RISKY_INST_RS2      24:20
`define RISKY_INST_F7       31:25
`define RISKY_INST_IMM_I    31:20
`define RISKY_INST_IMM_U    31:12
`define RISKY_INST_IMM_S_H  `RISKY_INST_MASK_F7
`define RISKY_INST_IMM_S_L  `RISKY_INST_MASK_RD

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
