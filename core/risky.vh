// Core configuration
`define RISKY_CONF_EXT_M

// Internal ALU instruction set
`define RISKY_ALU_ADD   5'd0
`define RISKY_ALU_SUB   5'd1
`define RISKY_ALU_XOR   5'd3
`define RISKY_ALU_OR    5'd4
`define RISKY_ALU_AND   5'd5
`define RISKY_ALU_SLL   5'd6
`define RISKY_ALU_SRL   5'd7
`define RISKY_ALU_SRA   5'd8
`define RISKY_ALU_SLT   5'd9
`define RISKY_ALU_SLTU  5'd10

// Decode data switches
`define RISKY_DECODE

// Instruction bit selectors/masks
`define RISKY_INST_OP       6:0
`define RISKY_INST_RD       11:7
`define RISKY_INST_F3       14:12
`define RISKY_INST_RS1      19:15
`define RISKY_INST_RS2      24:20
`define RISKY_INST_F7       31:25

// Instruction types
`define RISKY_INST_TYPE_R 7'b0110011
`define RISKY_INST_TYPE_I 7'b00?0011
`define RISKY_INST_TYPE_S 7'b0100011
`define RISKY_INST_TYPE_B 7'b1100011
`define RISKY_INST_TYPE_U 7'b0?10111
`define RISKY_INST_TYPE_J 7'b1101111

// Opcodes
`define RISKY_INST_OP_REG   7'b0110011 // Integer register
`define RISKY_INST_OP_IMM   7'b0010011 // Integer immediate
`define RISKY_INST_OP_LOAD  7'b0000011 // Mem load
`define RISKY_INST_OP_STORE 7'b0100011 // Mem store
`define RISKY_INST_OP_JAL   7'b1101111
`define RISKY_INST_OP_JALR  7'b1100111
`define RISKY_INST_OP_LUI   7'b0110111
`define RISKY_INST_OP_AUIPC 7'b0010111

// Function 3 Branch
`define RISKY_INST_F3_BEQ     3'b000
`define RISKY_INST_F3_BNE     3'b001
`define RISKY_INST_F3_BLT     3'b100
`define RISKY_INST_F3_BGE     3'b101
`define RISKY_INST_F3_BLTU    3'b110
`define RISKY_INST_F3_BGEU    3'b111

// Function 3 Mem
`define RISKY_INST_F3_BYTE    3'b000
`define RISKY_INST_F3_HALF    3'b001
`define RISKY_INST_F3_WORD    3'b010
`define RISKY_INST_F3_LBU     3'b100
`define RISKY_INST_F3_LHU     3'b101

// Function 3 ALU
`define RISKY_INST_F3_ACC     3'b000
`define RISKY_INST_F3_SLL     3'b001
`define RISKY_INST_F3_SLT     3'b010
`define RISKY_INST_F3_SLTU    3'b011
`define RISKY_INST_F3_XOR     3'b100
`define RISKY_INST_F3_SR      3'b101
`define RISKY_INST_F3_OR      3'b110
`define RISKY_INST_F3_AND     3'b111

// Function 3 ALU M
`define RISKY_INST_F3_MUL     3'b000
`define RISKY_INST_F3_MULH    3'b001
`define RISKY_INST_F3_MULHSU  3'b010
`define RISKY_INST_F3_MULHU   3'b011
`define RISKY_INST_F3_DIV     3'b100
`define RISKY_INST_F3_DIVU    3'b101
`define RISKY_INST_F3_REM     3'b110
`define RISKY_INST_F3_REMU    3'b111

// Function 7
`define RISKY_INST_F7_ADD 7'b0000000
`define RISKY_INST_F7_SUB 7'b0100000
`define RISKY_INST_F7_SRL 7'b0000000
`define RISKY_INST_F7_SRA 7'b0100000
`define RISKY_INST_F7_M   7'b0000001
