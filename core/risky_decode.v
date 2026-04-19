module risky_decode (
    input clk,

    input hazard_stall,
    input hazard_flush,

    output [4:0] rs1_addr,
    input [31:0] rs1_data,
    output [4:0] rs2_addr,
    input [31:0] rs2_data,

    input [31:0] fetch_inst_addr,
    input [31:0] fetch_inst_data,
    input fetch_flush_propogate,

    output reg execute_flush_propogate
);

    //assign rs1_addr = ; // TODO Instruction decoder

    always @(posedge clk) begin
        if (!(hazard_stall || hazard_flush)) begin
            execute_flush_propogate <= 1'd0;
        end else if (hazard_flush) begin
            execute_flush_propogate <= 1'd1;
        end
    end

endmodule
