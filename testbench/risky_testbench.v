`timescale 1ns / 1ps

module risky_testbench();
    reg clk = 0;
    always #1 clk = ~clk;

    reg [31:0] mem [1023:0];
    wire [31:0] mem_rdata, mem_wdata, mem_addr;
    wire [3:0] mem_byte_en;
    wire mem_rd_en, mem_wr_en;

    assign mem_rdata = mem_rd_en ? mem[mem_addr[31:2]] : {32{1'bz}};

    always @(*) begin
        if (mem_wr_en) begin
            if (mem_byte_en[0]) mem[mem_addr[31:2]][7:0]   = mem_wdata[7:0];
            if (mem_byte_en[1]) mem[mem_addr[31:2]][15:8]  = mem_wdata[15:8];
            if (mem_byte_en[2]) mem[mem_addr[31:2]][23:16] = mem_wdata[23:16];
            if (mem_byte_en[3]) mem[mem_addr[31:2]][31:24] = mem_wdata[31:24];
        end
    end

    risky rsky (
        .clk(clk),
        .addr(mem_addr),
        .rdata(mem_rdata),
        .rd_en(mem_rd_en),
        .wdata(mem_wdata),
        .byte_en(mem_byte_en),
        .wr_en(mem_wr_en)
    );

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0,risky_testbench);

        $display("Risky testbench started");

        mem[0] = {12'd16,5'd0,`RISKY_INST_F3_WORD,5'd1,`RISKY_INST_OP_LOAD}; // LW
        mem[1] = {12'd1,5'd1,`RISKY_INST_F3_ACC,5'd2,`RISKY_INST_OP_IMM}; // ADDI
        mem[2] = {6'd0,5'd2,5'd0,`RISKY_INST_F3_WORD,5'd4*5'd4,`RISKY_INST_OP_STORE}; // SW
        mem[4] = 32'd42069; // DATA

        mem[3] = {12'd6*12'd4,5'd0,3'd0,5'd3,`RISKY_INST_OP_JALR}; // JALR
        mem[6] = {6'd0,5'd3,5'd0,`RISKY_INST_F3_WORD,5'd5*5'd4,`RISKY_INST_OP_STORE}; // SW

        mem[7] = {12'd10*12'd4,5'd0,`RISKY_INST_F3_WORD,5'd1,`RISKY_INST_OP_LOAD}; // LW
        mem[8] = {7'd0,5'd0,5'd1,`RISKY_INST_F3_BEQ,5'd8,`RISKY_INST_TYPE_B}; // BEQ NOT TAKEN
        mem[9] = {7'd0,5'd1,5'd1,`RISKY_INST_F3_BEQ,5'd8,`RISKY_INST_TYPE_B};// BEQ TAKEN
        mem[10] = 32'd42069; // DATA
        mem[11] = {6'd0,5'd1,5'd0,`RISKY_INST_F3_WORD,5'd6*5'd4,`RISKY_INST_OP_STORE}; // SW

        #1000;
        if (mem[4] == 32'd42070)
            $display("SIMPLE LW, ADDI, SW: PASS");
        else
            $display("SIMPLE LW, ADDI, SW: FAIL:", mem[4]);

        if (mem[5] == 32'd16)
            $display("SIMPLE JALR: PASS");
        else
            $display("SIMPLE JALR: FAIL:", mem[5]);

        if (mem[6] == 32'd42069)
            $display("SIMPLE BEQ: PASS");
        else
            $display("SIMPLE BEQ: FAIL:", mem[6]);

        $finish;
    end
endmodule
