// Core configuration
`define RISKY_CONF_EXT_M

//
// Decode-emitted internal control words
//

// Execute stage control word
`define RISKY_EXECUTE_CTRL_LEN  1
`define RISKY_EXECUTE_CTRL_NOP  1'd0
`define RISKY_EXECUTE_CTRL_OP   1'd1

// Mem stage control word
`define RISKY_MEM_CTRL_LEN      2
`define RISKY_MEM_CTRL_NOP      2'd0
`define RISKY_MEM_CTRL_READ     2'd1
`define RISKY_MEM_CTRL_WRITE    2'd2

// Writeback stage control word
`define RISKY_WRITEBACK_CTRL_LEN    2
`define RISKY_WRITEBACK_CTRL_NOP    2'd0
`define RISKY_WRITEBACK_CTRL_REG    2'd1
`define RISKY_WRITEBACK_CTRL_PC     2'd2

//
// RISC-V decode constants
//

// Instruction bit selectors/masks
`define RISKY_INST_OP       6:0
`define RISKY_INST_RD       11:7
`define RISKY_INST_F3       14:12
`define RISKY_INST_RS1      19:15
`define RISKY_INST_RS2      24:20
`define RISKY_INST_F7       31:25
`define RISKY_INST_IMM_I    31:20
`define RISKY_INST_IMM_S_H  31:25
`define RISKY_INST_IMM_S_L  11:7
`define RISKY_INST_IMM_B_LL 11:8
`define RISKY_INST_IMM_B_LH 30:25
`define RISKY_INST_IMM_B_HL 7
`define RISKY_INST_IMM_B_HH 31
`define RISKY_INST_IMM_U    31:12
`define RISKY_INST_IMM_J_L  30:21
`define RISKY_INST_IMM_J_M  20
`define RISKY_INST_IMM_J_H  19:12

// Instruction types
`define RISKY_INST_TYPE_R 7'b0110011
`define RISKY_INST_TYPE_I 7'b00?0011
`define RISKY_INST_TYPE_S 7'b0100011
`define RISKY_INST_TYPE_B 7'b1100011
`define RISKY_INST_TYPE_U 7'b0?10111
`define RISKY_INST_TYPE_J 7'b1101111

// Opcodes
`define RISKY_INST_OP_LUI   7'b0110111
`define RISKY_INST_OP_AUIPC 7'b0010111
`define RISKY_INST_OP_JAL   7'b1101111
`define RISKY_INST_OP_JALR  7'b1100111
`define RISKY_INST_OP_ML    7'b0000011 // Mem load
`define RISKY_INST_OP_MS    7'b0100011 // Mem store
`define RISKY_INST_OP_AI    7'b0010011 // ALU Immediate

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
