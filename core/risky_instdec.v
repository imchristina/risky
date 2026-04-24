module risky_instdec (
    input [31:0] inst,

    output reg [4:0] alu_word,
    output reg mem_read_en,
    output reg mem_write_en,
    output reg writeback_rd_en,
    output reg writeback_pc_en
);

    wire [4:0] alu_word_inst;
    risky_instdec_alu instdec_alu (
        .funct3(inst[`RISKY_INST_F3]),
        .funct7(inst[`RISKY_INST_F7]),
        .alu_word(alu_word_inst)
    );

    always @(*) begin
        mem_read_en = 0;
        mem_write_en = 0;
        writeback_rd_en = 0;
        writeback_pc_en = 0;

        case (inst[`RISKY_INST_OP])
            `RISKY_INST_OP_REG: begin
                writeback_rd_en = 1;
                alu_word = alu_word_inst;
            end
        endcase
    end

endmodule

module risky_instdec_alu (
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [4:0] alu_word
);

    always @(*) begin
        case ({funct7, funct3})
            {`RISKY_INST_F7_ADD,`RISKY_INST_F3_ACC}: alu_word = `RISKY_ALU_ADD;
            {`RISKY_INST_F7_SUB,`RISKY_INST_F3_ACC}: alu_word = `RISKY_ALU_SUB;
        endcase
    end

endmodule

module risky_instdec_imm (
    input [31:0] inst,
    output [31:0] i,
    output [31:0] s,
    output [31:0] b,
    output [31:0] u,
    output [31:0] j
);

    assign i = {{20{inst[31]}},inst[30:25],inst[24:21],inst[20]};
    assign s = {{20{inst[31]}},inst[30:25],inst[11:8],inst[7]};
    assign b = {{19{inst[31]}},inst[7],inst[30:25],inst[11:8],1'd0};
    assign u = {inst[31],inst[30:20],inst[19:12],12'd0};
    assign j = {{12{inst[31]}},inst[19:12],inst[20],inst[30:25],inst[24:21],1'd0};

endmodule
