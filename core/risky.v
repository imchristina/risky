// Risky RV32I Core
// Twin-bus microcoded architecture
// bus1 mainly used for address, bus2 mainly used for data
// Bus modules are input-clocked, output-combinational

// TODO make control signals consistent, all should be in context of the module. (probably)
// Example, raddr would output an address onto the bus, waddr would write one to the module from the bus.

// Core configuration
`define RISKY_CONF_EXT_M

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

module risky (input clk, inout [31:0] mem_data, output [31:0] mem_addr, output mem_oe, output mem_we);
    wire [31:0] bus1;
    wire [31:0] bus2;

    wire mem_r, mem_w;
    risky_mem rmem (clk, bus1, bus2, mem_data, mem_addr, mem_oe, mem_we, mem_r, mem_w);

    wire malign_rinst, malign_raddr, malign_rdatal, malign_rdatah, malign_wdatal, malign_wdatah, malign_waddr, malign_wmeml, malign_wmemh, malign_out_exception;
    risky_malign rmemalign (clk, bus1, bus2, malign_rinst, malign_raddr, malign_rdatal, malign_rdatah, malign_wdatal, malign_wdatah, malign_waddr, malign_wmeml, malign_wmemh, malign_out_exception);

    wire reg_rinst, reg_rdata1, reg_rdata2, reg_wdata;
    risky_reg rreg (clk, bus1, bus2, reg_rinst, reg_rdata1, reg_rdata2, reg_wdata);

    wire pc_inc, pc_out1, pc_out2, pc_in;
    risky_pc rpc (clk, bus1, bus2, pc_inc, pc_out1, pc_out2, pc_in);

    wire alu_rinst, alu_rdata, alu_itype, alu_mtype, alu_btype, alu_out;
    risky_alu ralu (clk, bus1, bus2, alu_rinst, alu_rdata, alu_itype, alu_mtype, alu_btype, alu_out);

    wire imm_rinst, imm_out;
    risky_imm rimm (clk, bus2, imm_rinst, imm_out);

    risky_ctrl rctrl (clk, bus1, bus2,
    pc_inc, pc_out1, pc_out2, pc_in,
    mem_r, mem_w,
    malign_rinst, malign_raddr, malign_rdatal, malign_rdatah, malign_wdatal, malign_wdatah, malign_waddr, malign_wmeml, malign_wmemh, malign_out_exception,
    reg_rinst, reg_rdata1, reg_rdata2, reg_wdata,
    imm_rinst, imm_out,
    alu_rinst, alu_rdata, alu_itype, alu_mtype, alu_btype, alu_out
    );

endmodule

// bus1 pc out/in
module risky_pc (input clk, inout [31:0] bus1, bus2, input pc_inc, pc_out1, pc_out2, pc_in);
    reg [29:0] pc = 0; // We only need 30 bits as instructions are aligned to a 4-byte boundry.

    assign bus1 = pc_out1 ? {pc, 2'b00} : {32{1'bz}};
    assign bus2 = pc_out2 ? {pc, 2'b00} : {32{1'bz}};

    always @(posedge clk) begin
        if (pc_inc)
            pc <= pc + 1'd1;
        if (pc_in)
            pc <= bus1[31:2];
    end
endmodule

// bus1 addr, bus2 data
module risky_mem (input clk, input [31:0] bus1, inout [31:0] bus2, inout [31:0] mem_if_data, output [31:0] mem_if_addr, output mem_if_oe, output mem_if_we, input mem_r, input mem_w);
    // Write data from memory onto bus2 using the address from bus1
    assign bus2 = mem_r ? mem_if_data : {32{1'bz}};

    // Mem physical interface controls
    assign mem_if_oe = mem_r;
    assign mem_if_we = mem_w & clk;
    assign mem_if_data = mem_w ? bus2 : {32{1'bz}};
    assign mem_if_addr = bus1 >> 2;
endmodule

// Memory byte alignment unit, shifts/sign extends data for mem instructions
// I HATE BYTE ADDRESSING I HATE BYTE ADDRESSING
module risky_malign (input clk, inout [31:0] bus1, inout [31:0] bus2, input malign_rinst, malign_raddr, malign_rdatal, malign_rdatah, malign_wdatal, malign_wdatah, malign_waddr, malign_rmeml, malign_rmemh, malign_out_exception);
    reg [6:0] opcode = 0;
    reg [2:0] funct3 = 0;
    reg [31:0] addr = 0;
    reg [31:0] data_l = 0, data_h = 0, mem_l = 0, mem_h = 0, result_l = 0, result_h = 0;
    reg exception = 0;

    assign bus1 = malign_out_exception ? {31'd0,exception} : {32{1'bz}};
    assign bus2 = malign_wdatal ? result_l : {32{1'bz}};
    assign bus2 = malign_wdatah ? result_h : {32{1'bz}};
    assign bus1 = malign_waddr ? (addr + 4) : {32{1'bz}};

    // Clock in data from the bus
    always @(posedge clk) begin
        if (malign_rinst) begin
            opcode <= bus2[`RISKY_INST_OP];
            funct3 <= bus2[`RISKY_INST_F3];
        end
        if (malign_raddr)
            addr <= bus1;
        if (malign_rdatal)
            data_l <= bus2;
        if (malign_rdatah)
            data_h <= bus2;
        if (malign_rmeml)
            mem_l <= bus2;
        if (malign_rmemh)
            mem_h <= bus2;
    end

    always @(*) begin
        exception = 0; // Default to 0
        result_h = 0;

        case ({opcode, funct3, addr[1:0]})
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_BYTE,2'd0}: result_l = {{24{data_l[7]}},data_l[7:0]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_BYTE,2'd1}: result_l = {{24{data_l[15]}},data_l[15:8]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_BYTE,2'd2}: result_l = {{24{data_l[23]}},data_l[23:16]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_BYTE,2'd3}: result_l = {{24{data_l[31]}},data_l[31:24]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_HALF,2'd0}: result_l = {{16{data_l[15]}},data_l[15:0]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_HALF,2'd1}: result_l = {{16{data_l[23]}},data_l[23:8]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_HALF,2'd2}: result_l = {{16{data_l[31]}},data_l[31:16]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_HALF,2'd3}: begin
                result_l = {{16{data_h[7]}},data_h[7:0],data_l[31:24]};
                exception = 1;
            end
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_WORD,2'd0}: result_l = data_l;
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_WORD,2'd1}: begin
                result_l = {data_h[7:0],data_l[31:8]};
                exception = 1;
            end
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_WORD,2'd2}: begin
                result_l = {data_h[15:0],data_l[31:16]};
                exception = 1;
            end
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_WORD,2'd3}: begin
                result_l = {data_h[23:0],data_l[31:24]};
                exception = 1;
            end
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_LBU,2'd0}: result_l = {24'd0,data_l[7:0]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_LBU,2'd1}: result_l = {24'd0,data_l[15:8]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_LBU,2'd2}: result_l = {24'd0,data_l[23:16]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_LBU,2'd3}: result_l = {24'd0,data_l[31:24]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_LHU,2'd0}: result_l = {16'd0,data_l[15:0]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_LHU,2'd1}: result_l = {16'd0,data_l[23:8]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_LHU,2'd2}: result_l = {16'd0,data_l[31:16]};
            {`RISKY_INST_OP_ML,`RISKY_INST_F3_LHU,2'd3}: begin
                result_l = {16'd0,data_h[7:0],data_l[31:24]};
                exception = 1;
            end
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_BYTE,2'd0}: result_l = {mem_l[31:8],data_l[7:0]};
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_BYTE,2'd1}: result_l = {mem_l[31:16],data_l[7:0],mem_l[7:0]};
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_BYTE,2'd2}: result_l = {mem_l[31:24],data_l[7:0],mem_l[15:0]};
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_BYTE,2'd3}: result_l = {data_l[7:0],mem_l[23:0]};
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_HALF,2'd0}: result_l = {mem_l[31:16],data_l[15:0]};
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_HALF,2'd1}: result_l = {mem_l[31:24],data_l[15:0],mem_l[7:0]};
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_HALF,2'd2}: result_l = {data_l[15:0],mem_l[15:0]};
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_HALF,2'd3}: begin
                result_l = {data_l[7:0],mem_l[23:0]};
                result_h = {mem_h[31:8],data_l[15:8]};
                exception = 1;
            end
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_WORD,2'd0}: result_l = data_l;
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_WORD,2'd1}: begin
                result_l = {data_l[31:8],mem_l[7:0]};
                result_h = {mem_h[31:8],data_l[7:0]};
                exception = 1;
            end
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_WORD,2'd2}: begin
                result_l = {data_l[31:16],mem_l[15:0]};
                result_h = {mem_h[31:16],data_l[15:0]};
                exception = 1;
            end
            {`RISKY_INST_OP_MS,`RISKY_INST_F3_WORD,2'd3}: begin
                result_l = {data_l[31:24],mem_l[23:0]};
                result_h = {mem_h[31:24],data_l[23:0]};
                exception = 1;
            end
            default: result_l = 0;
        endcase
    end
endmodule

// bus1 rs1/rd, bus2 inst/rs2
module risky_reg (input clk, inout [31:0] bus1, inout [31:0] bus2, input reg_rinst, input reg_rdata1, input reg_rdata2, input reg_wdata);
    reg [31:0] regfile [31:0];
    reg [4:0] rd = 0, rs1 = 0, rs2 = 0;

    // Read data from the regfile onto bus0 and bus1
    assign bus1 = reg_rdata1 ? regfile[rs1] : {32{1'bz}};
    assign bus2 = reg_rdata2 ? regfile[rs2] : {32{1'bz}};

    always @(posedge clk) begin
        if (reg_rinst) begin
            rd <= bus2[`RISKY_INST_RD];
            rs1 <= bus2[`RISKY_INST_RS1];
            rs2 <= bus2[`RISKY_INST_RS2];
        end else if (reg_wdata)
            regfile[rd] <= bus2;

        regfile[0] <= 0; // Ensure always 0
    end
endmodule

// bus2 inst/result
module risky_imm (input clk, inout [31:0] bus2, input imm_rinst, input imm_out);
    reg [31:0] inst = 0, result = 0;

    // Clock in instruction from the bus
    always @(posedge clk) begin
        if (imm_rinst)
            inst <= bus2;
    end

    // Combinational logic
    always @(*) begin
        casez (inst[`RISKY_INST_OP])
            `RISKY_INST_TYPE_I,
            `RISKY_INST_OP_JALR: result = {{20{inst[31]}}, inst[`RISKY_INST_IMM_I]}; // WHY JALR WHYYY
            `RISKY_INST_TYPE_S: result = {{20{inst[31]}}, inst[`RISKY_INST_IMM_S_H], inst[`RISKY_INST_IMM_S_L]};
            `RISKY_INST_TYPE_B: result = {{19{inst[31]}}, inst[`RISKY_INST_IMM_B_HH], inst[`RISKY_INST_IMM_B_HL], inst[`RISKY_INST_IMM_B_LH], inst[`RISKY_INST_IMM_B_LL], 1'd0};
            `RISKY_INST_TYPE_U: result = {inst[`RISKY_INST_IMM_U], 12'd0};
            `RISKY_INST_TYPE_J: result = {{12{inst[31]}}, inst[`RISKY_INST_IMM_J_H], inst[`RISKY_INST_IMM_J_M], inst[`RISKY_INST_IMM_J_L], 1'd0};
            default: result = 32'd0; // TODO error handling
        endcase
    end

    assign bus2 = imm_out ? result : {32{1'bz}};
endmodule

// bus1 rs1, bus2 inst/rs2/result
module risky_alu (input clk, inout [31:0] bus1, bus2, input alu_rinst, alu_rdata, alu_itype, alu_mtype, alu_btype, alu_out);
    reg [2:0] funct3 = 0;
    reg [6:0] funct7 = 0;
    reg [31:0] rs1 = 0, rs2 = 0, result = 0;

    // Clock in data from the bus
    always @(posedge clk) begin
        if (alu_rinst) begin
            funct3 <= bus2[`RISKY_INST_F3];
            funct7 <= bus2[`RISKY_INST_F7];
        end else if (alu_rdata) begin
            rs1 <= bus1;
            rs2 <= bus2;
        end
    end

    // RISC-V is beautiful, until you realise there are a bunch of little exceptions that make no sense
    // This brings me great pain
    wire itype_shift = (funct3 == `RISKY_INST_F3_SR || funct3 == `RISKY_INST_F3_SLL);

    wire [63:0] rs1_i64 = $signed(rs1);
    wire [63:0] rs2_i64 = $signed(rs2);

    // Combinational logic
    always @(*) begin
        if (!alu_mtype & !alu_btype) begin
            case ({(alu_itype && !itype_shift) ? 7'd0 : funct7, funct3})
                {`RISKY_INST_F7_ADD,`RISKY_INST_F3_ACC}:    result = rs1 + rs2;                             // ADD
                {`RISKY_INST_F7_SUB,`RISKY_INST_F3_ACC}:    result = rs1 - rs2;                             // SUB
                {7'd0,`RISKY_INST_F3_SLL}:                  result = rs1 << rs2[4:0];                       // SLL
                {7'd0,`RISKY_INST_F3_SLT}:                  result = {31'd0, $signed(rs1) < $signed(rs2)};  // SLT
                {7'd0,`RISKY_INST_F3_SLTU}:                 result = {31'd0, rs1 < rs2};                    // SLTU
                {7'd0,`RISKY_INST_F3_XOR}:                  result = rs1 ^ rs2;                             // XOR
                {`RISKY_INST_F7_SRL,`RISKY_INST_F3_SR}:     result = rs1 >> rs2[4:0];                       // SRL
                {`RISKY_INST_F7_SRA,`RISKY_INST_F3_SR}:     result = $signed(rs1) >>> rs2[4:0];             // SRA
                {7'd0,`RISKY_INST_F3_OR}:                   result = rs1 | rs2;                             // OR
                {7'd0,`RISKY_INST_F3_AND}:                  result = rs1 & rs2;                             // AND

                `ifdef RISKY_CONF_EXT_M // M extension
                {`RISKY_INST_F7_M,`RISKY_INST_F3_MUL}:      result = $signed(rs1) * $signed(rs2);                   // MUL
                {`RISKY_INST_F7_M,`RISKY_INST_F3_MULH}:     result = ($signed(rs1_i64) * $signed(rs2_i64)) >> 32;   // MULH
                {`RISKY_INST_F7_M,`RISKY_INST_F3_MULHSU}:   result = ($signed(rs1_i64) * {32'd0, rs2}) >> 32;       // MULHSU
                {`RISKY_INST_F7_M,`RISKY_INST_F3_MULHU}:    result = ({32'd0, rs1} * {32'd0, rs2}) >> 32;           // MULHU
                {`RISKY_INST_F7_M,`RISKY_INST_F3_DIV}:      result = $signed(rs1) / $signed(rs2);                   // DIV
                {`RISKY_INST_F7_M,`RISKY_INST_F3_DIVU}:     result = rs1 / rs2;                                     // DIVU
                {`RISKY_INST_F7_M,`RISKY_INST_F3_REM}:      result = $signed(rs1) % $signed(rs2);                   // REM
                {`RISKY_INST_F7_M,`RISKY_INST_F3_REMU}:     result = rs1 % rs2;                                     // REMU
                `endif
                default: result = 32'd0; // TODO error handling
            endcase
        end else if (alu_mtype)
            result = rs1 + rs2;
        else if (alu_btype) begin
            case (funct3)
                `RISKY_INST_F3_BEQ:     result = {31'd0,rs1 == rs2};
                `RISKY_INST_F3_BNE:     result = {31'd0,rs1 != rs2};
                `RISKY_INST_F3_BLT:     result = {31'd0,$signed(rs1) < $signed(rs2)};
                `RISKY_INST_F3_BGE:     result = {31'd0,$signed(rs1) >= $signed(rs2)};
                `RISKY_INST_F3_BLTU:    result = {31'd0,rs1 < rs2};
                `RISKY_INST_F3_BGEU:    result = {31'd0,rs1 >= rs2};
                default: result = 32'd0;
            endcase
        end
    end

    assign bus1 = (alu_out & (alu_mtype | alu_btype)) ? result : {32{1'bz}};
    assign bus2 = (alu_out & !(alu_mtype | alu_btype)) ? result : {32{1'bz}};
endmodule

// TODO ALU function generator that gets pushed onto the bus for things such as misaligned memory access and branches
// Will most likely need t to be much larger as this software emulation will take many many cycles
module risky_ctrl (input clk, inout [31:0] bus1, bus2,
    output reg
    pc_inc, pc_out1, pc_out2, pc_in,
    mem_r, mem_w,
    malign_rinst, malign_raddr, malign_rdatal, malign_rdatah, malign_wdatal, malign_wdatah, malign_waddr, malign_wmeml, malign_wmemh, malign_out_exception,
    reg_rinst, reg_rdata1, reg_rdata2, reg_wdata,
    imm_rinst, imm_out,
    alu_rinst, alu_rdata, alu_itype, alu_mtype, alu_btype, alu_out
);
    reg [2:0] t = 0;
    reg t_reset = 0, exception_read = 0;
    reg [6:0] opcode = 0;
    reg [31:0] exception = 0;

    always @(negedge clk) begin
        // All signals should be 0 unless driven
        pc_inc <= 0; pc_out1 <= 0; pc_out2 <= 0; pc_in <= 0;
        mem_r <= 0; mem_w <= 0;
        malign_rinst <= 0; malign_raddr <= 0; malign_rdatal <= 0; malign_rdatah <= 0; malign_wdatal <= 0; malign_wdatah <= 0; malign_waddr <= 0; malign_wmeml <= 0; malign_wmemh <= 0; malign_out_exception <= 0;
        reg_rinst <= 0; reg_rdata1 <= 0; reg_rdata2 <= 0; reg_wdata <= 0;
        imm_rinst <= 0; imm_out <= 0;
        alu_rinst <= 0; alu_rdata <= 0; alu_itype <= 0; alu_mtype <= 0; alu_btype <= 0; alu_out <= 0;

        t_reset <= 0; exception_read <= 0;

        casez ({t,opcode})
            {3'd0, 7'bzzzzzzz}: begin // t=0, same for every opcode
                pc_out1 <= 1;
                mem_r <= 1;
                malign_rinst <= 1;
                reg_rinst <= 1;
                alu_rinst <= 1;
                imm_rinst <= 1;
            end

            {3'd1, `RISKY_INST_OP_LUI}: begin
                imm_out <= 1;
                reg_wdata <= 1;
                pc_inc <= 1;
                t_reset <= 1;
            end

            {3'd1, `RISKY_INST_OP_AUIPC}: begin
                imm_out <= 1;
                pc_out1 <= 1;
                alu_mtype <= 1;
                alu_rdata <= 1;
            end
            {3'd2, `RISKY_INST_OP_AUIPC}: begin
                alu_mtype <= 1;
                alu_out <= 1;
                pc_in <= 1;
                t_reset <= 1;
            end

            {3'd1, `RISKY_INST_OP_JAL}: begin
                pc_out1 <= 1;
                imm_out <= 1;
                alu_mtype <= 1;
                alu_rdata <= 1;
            end
            {3'd2, `RISKY_INST_OP_JAL}: begin
                pc_inc <= 1;
            end
            {3'd3, `RISKY_INST_OP_JAL}: begin
                pc_out2 <= 1;
                reg_wdata <= 1;
            end
            {3'd4, `RISKY_INST_OP_JAL}: begin
                alu_mtype <= 1;
                alu_out <= 1;
                pc_in <= 1;
                t_reset <= 1;
            end

            // Spec says we should be setting the LSB to 0, but that is simply ignored by the program counter anyways
            {3'd1, `RISKY_INST_OP_JALR}: begin
                reg_rdata1 <= 1;
                imm_out <= 1;
                alu_mtype <= 1;
                alu_rdata <= 1;
            end
            {3'd2, `RISKY_INST_OP_JALR}: begin
                pc_inc <= 1;
            end
            {3'd3, `RISKY_INST_OP_JALR}: begin
                pc_out2 <= 1;
                reg_wdata <= 1;
            end
            {3'd4, `RISKY_INST_OP_JALR}: begin
                alu_mtype <= 1;
                alu_out <= 1;
                pc_in <= 1;
                t_reset <= 1;
            end

            {3'd1, `RISKY_INST_TYPE_B}: begin
                reg_rdata1 <= 1;
                reg_rdata2 <= 1;
                alu_rdata <= 1;
                alu_btype <= 1;
            end
            {3'd2, `RISKY_INST_TYPE_B}: begin
                alu_btype <= 1;
                alu_out <= 1;
                exception_read <= 1;
            end
            {3'd3, `RISKY_INST_TYPE_B}: begin
                if (exception[0]) begin // Branch taken
                    imm_out <= 1;
                    pc_out1 <= 1;
                    alu_mtype <= 1;
                    alu_rdata <= 1;
                end else begin // Branch not taken
                    pc_inc <= 1;
                    t_reset <= 1;
                end
            end
            {3'd4, `RISKY_INST_TYPE_B}: begin
                alu_mtype <= 1;
                alu_out <= 1;
                pc_in <= 1;
                t_reset <= 1;
            end

            // R-type ALU
            {3'd1, `RISKY_INST_TYPE_R}: begin
                reg_rdata1 <= 1;
                reg_rdata2 <= 1;
                alu_rdata <= 1;
            end
            {3'd2, `RISKY_INST_TYPE_R}: begin
                alu_out <= 1;
                reg_wdata <= 1;
                pc_inc <= 1;
                t_reset <= 1;
            end

            // ALU Immediate
            {3'd1, `RISKY_INST_OP_AI}: begin
                reg_rdata1 <= 1;
                imm_out <= 1;
                alu_itype <= 1;
                alu_rdata <= 1;
            end
            {3'd2, `RISKY_INST_OP_AI}: begin
                alu_itype <= 1;
                alu_out <= 1;
                reg_wdata <= 1;
                pc_inc <= 1;
                t_reset <= 1;
            end

            // Memory
            {3'd1, `RISKY_INST_OP_ML},
            {3'd1, `RISKY_INST_OP_MS}: begin
                reg_rdata1 <= 1;
                imm_out <= 1;
                alu_mtype <= 1;
                alu_rdata <= 1;
            end

            // Memory Load
            {3'd2, `RISKY_INST_OP_ML}: begin
                alu_mtype <= 1;
                alu_out <= 1;
                mem_r <= 1;
                malign_raddr <= 1; // TODO these signals might be able to be merged?
                malign_rdatal <= 1;
            end
            {3'd3, `RISKY_INST_OP_ML}: begin
                malign_wdatal <= 1;
                malign_out_exception <= 1;
                reg_wdata <= 1;
                exception_read <= 1;
            end
            {3'd4, `RISKY_INST_OP_ML}: begin
                if (exception[0]) begin // Unaligned read, read the next word into malign before storing again
                    malign_waddr <= 1;
                    mem_r <= 1;
                    malign_rdatah <= 1;
                end else begin
                    pc_inc <= 1;
                    t_reset <= 1;
                end
            end
            {3'd5, `RISKY_INST_OP_ML}: begin
                malign_wdatal <= 1;
                reg_wdata <= 1;
                pc_inc <= 1;
                t_reset <= 1;
            end

            // Memory Store
            {3'd2, `RISKY_INST_OP_MS}: begin
                alu_mtype <= 1;
                alu_out <= 1;
                mem_r <= 1;
                malign_raddr <= 1;
                malign_wmeml <= 1; // TODO we don't need to load the word if we're storing an aligned word
            end
            {3'd3, `RISKY_INST_OP_MS}: begin
                reg_rdata2 <= 1;
                malign_rdatal <= 1;
            end
            {3'd4, `RISKY_INST_OP_MS}: begin
                alu_mtype <= 1;
                alu_out <= 1;
                malign_wdatal <= 1;
                mem_w <= 1;
            end
            {3'd5, `RISKY_INST_OP_MS}: begin
                malign_out_exception <= 1;
                exception_read <= 1;
            end
            {3'd6, `RISKY_INST_OP_MS}: begin
                if (exception[0]) begin
                    malign_waddr <= 1;
                    mem_r <= 1;
                    malign_wmemh <= 1;
                end else begin
                    pc_inc <= 1;
                    t_reset <= 1;
                end
            end
            {3'd7, `RISKY_INST_OP_MS}: begin
                alu_mtype <= 1;
                alu_out <= 1;
                malign_wdatal <= 1;
                mem_w <= 1;
                pc_inc <= 1;
                t_reset <= 1;
            end

            default: t_reset <= 1; // Undefined instruction or state, halt
        endcase
    end

    always @(posedge clk) begin
        case (t_reset)
            1'd0: t <= t + 1;
            1'd1: t <= 0;
        endcase
        if (t == 0)
            opcode <= bus2[`RISKY_INST_OP];
        if (exception_read)
            exception <= bus1;
    end
endmodule
