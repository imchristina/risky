// Risky RV32I Core

module risky (
    input clk,
    output [31:0] addr,
    input [31:0] rdata,
    output rd_en,
    output [31:0] wdata,
    output [3:0] byte_en,
    output wr_en
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

    wire [31:0] pc_raddr, pc_waddr;
    wire pc_inc_en, pc_wr_en;

    risky_pc pc (
        .clk(clk),

        .raddr(pc_raddr),
        .inc_en(pc_inc_en),

        .waddr(pc_waddr),
        .wr_en(pc_wr_en)
    );

    wire [31:0] memif_fetch_addr, memif_fetch_rdata;
    wire memif_fetch_stall;
    wire [31:0] memif_mem_addr, memif_mem_rdata, memif_mem_wdata;
    wire [3:0] memif_mem_byte_en;
    wire memif_mem_rd_en, memif_mem_wr_en;

    risky_memif memif (
        .clk(clk),

        .fetch_addr(memif_fetch_addr),
        .fetch_rdata(memif_fetch_rdata),
        .fetch_stall(memif_fetch_stall),

        .mem_addr(memif_mem_addr),
        .mem_rdata(memif_mem_rdata),
        .mem_rd_en(memif_mem_rd_en),
        .mem_wdata(memif_mem_wdata),
        .mem_byte_en(memif_mem_byte_en),
        .mem_wr_en(memif_mem_wr_en),

        .phy_addr(addr),
        .phy_rdata(rdata),
        .phy_rd_en(rd_en),
        .phy_wdata(wdata),
        .phy_byte_en(byte_en),
        .phy_wr_en(wr_en)
    );

    wire fetch_hazard_stall, fetch_hazard_flush;

    risky_fetch fetch (
        .clk(clk),

        .hazard_stall(fetch_hazard_stall),
        .hazard_flush(fetch_hazard_flush),

        .memif_addr(memif_fetch_addr),
        .memif_rdata(memif_fetch_rdata),

        .pc_raddr(pc_raddr),
        .pc_inc_en(pc_inc_en),

        .decode_inst_addr(),
        .decode_inst_data(),
        .decode_flush_propogate()
    );

    // FIXME TEMPORARY FOR DEBUGGING
    assign fetch_hazard_stall = 1'd0;
    assign fetch_hazard_flush = 1'd0;
    assign memif_mem_rd_en = 1'd0;
    assign memif_mem_wr_en = 1'd0;

endmodule
