// Risky RV32I Core
module risky (
    input clk,
    inout [31:0] mem_data,
    output [31:0] mem_addr,
    output mem_oe,
    output mem_we
);

    wire [4:0] reg_rs1_addr, reg_rs2_addr, reg_rd_addr;
    wire [31:0] reg_rs1_data, reg_rs2_data, reg_rd_data;
    wire reg_rd_wr_en;

    risky_regfile regfile (
        .clk(clk),

        .rs1_addr(reg_rs1_addr),
        .rs1_data(reg_rs1_data),

        .rs2_addr(reg_rs2_addr),
        .rs2_data(reg_rs2_data),

        .rd_addr(reg_rd_addr),
        .rd_data(reg_rd_data),
        .rd_wr_en(reg_rd_wr_en)
    );

endmodule
