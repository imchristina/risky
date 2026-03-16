module risky_fetch (
    input clk,

    input hazard_stall,
    input hazard_flush,

    output [31:0] memif_addr,
    input [31:0] memif_rdata,

    input [31:0] pc_raddr,
    output pc_inc_en,

    output [31:0] decode_inst_addr,
    output [31:0] decode_inst_data,
    output decode_flush_propogate
);

    assign pc_inc_en = ~(hazard_stall || hazard_flush);

    always @(posedge clk) begin

    end

endmodule
