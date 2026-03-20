module risky_fetch (
    input clk,

    input hazard_stall,
    input hazard_flush,

    output [31:0] memif_addr,
    input [31:0] memif_rdata,

    input [31:0] pc_raddr,
    output pc_inc_en,

    output reg [31:0] decode_inst_addr,
    output reg [31:0] decode_inst_data,
    output reg decode_flush_propogate
);

    assign pc_inc_en = !(hazard_stall || hazard_flush);
    assign memif_addr = pc_raddr;

    always @(posedge clk) begin
        if (!(hazard_stall || hazard_flush)) begin
            decode_inst_addr <= pc_raddr;
            decode_inst_data <= memif_rdata;
            decode_flush_propogate <= 1'd0;
        end else if (hazard_flush) begin
            decode_flush_propogate <= 1'd1;
        end
    end

endmodule
