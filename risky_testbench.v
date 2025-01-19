`timescale 1ns / 1ps

module risky_testbench();
    reg clk = 0;
    always #1 clk = ~clk;

    reg [31:0] mem [1023:0];
    wire [31:0] mem_data, mem_addr;
    wire mem_oe, mem_we;

    assign mem_data = mem_oe ? mem[mem_addr] : {32{1'bz}};

    always @(*) begin
        if (mem_we)
            mem[mem_addr] <= mem_data;
    end

    risky rsky (clk, mem_data, mem_addr, mem_oe, mem_we);

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0,risky_testbench);

        $display("Risky testbench started");

        mem[0] = {12'd16,5'd0,`RISKY_INST_F3_WORD,5'd1,`RISKY_INST_OP_ML}; // LW
        mem[1] = {12'd1,5'd1,`RISKY_INST_F3_ACC,5'd2,`RISKY_INST_OP_AI}; // ADDI
        mem[2] = {6'd0,5'd2,5'd0,`RISKY_INST_F3_WORD,5'd4*5'd4,`RISKY_INST_OP_MS}; // SW
        mem[4] = 32'd42069; // DATA

        mem[3] = {12'd6*12'd4,5'd0,3'd0,5'd3,`RISKY_INST_OP_JALR}; // JALR
        mem[6] = {6'd0,5'd3,5'd0,`RISKY_INST_F3_WORD,5'd5*5'd4,`RISKY_INST_OP_MS}; // SW

        mem[7] = {12'd10*12'd4,5'd0,`RISKY_INST_F3_WORD,5'd1,`RISKY_INST_OP_ML}; // LW
        mem[8] = {7'd0,5'd0,5'd1,`RISKY_INST_F3_BEQ,5'd8,`RISKY_INST_TYPE_B}; // BEQ NOT TAKEN
        mem[9] = {7'd0,5'd1,5'd1,`RISKY_INST_F3_BEQ,5'd8,`RISKY_INST_TYPE_B};// BEQ TAKEN
        mem[10] = 32'd42069; // DATA
        mem[11] = {6'd0,5'd1,5'd0,`RISKY_INST_F3_WORD,5'd6*5'd4,`RISKY_INST_OP_MS}; // SW

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
