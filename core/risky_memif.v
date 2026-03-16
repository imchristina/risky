module risky_memif (
    input clk,

    input [31:0] fetch_addr,
    output [31:0] fetch_rdata,
    output fetch_stall,

    input [31:0] mem_addr,
    output [31:0] mem_rdata,
    input mem_rd_en,
    input [31:0] mem_wdata,
    input [3:0] mem_byte_en,
    input mem_wr_en,

    output [31:0] phy_addr,
    input [31:0] phy_rdata,
    output phy_rd_en,
    output [31:0] phy_wdata,
    output [3:0] phy_byte_en,
    output phy_wr_en
);

    wire mem_active;
    assign mem_active = (mem_rd_en || mem_wr_en);

    assign phy_addr = mem_active ? mem_addr : fetch_addr;
    assign phy_rd_en = mem_active ? mem_rd_en : 1'd1;
    assign phy_wdata = mem_active ? mem_wdata : 1'd0;
    assign phy_byte_en = mem_active ? mem_byte_en : 4'b1111;
    assign phy_wr_en = mem_wr_en;

    assign fetch_rdata = mem_active ? 32'd0 : phy_rdata;
    assign mem_rdata = mem_active ? phy_rdata : 32'd0;

endmodule
