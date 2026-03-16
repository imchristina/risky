module risky_regfile (
    input clk,

    input [4:0] rs1_addr,
    output [31:0] rs1_data,

    input [4:0] rs2_addr,
    output [31:0] rs2_data,

    input [4:0] rd_addr,
    input [31:0] rd_data,
    input rd_wr_en
);

    reg [31:0] regfile [31:0];

    assign rs1_data = (rs1_addr == 5'd0) ? 32'd0 : regfile[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? 32'd0 : regfile[rs2_addr];

    always @(posedge clk) begin
        if (rd_wr_en && (rd_addr != 5'd0)) begin
            regfile[rd_addr] <= rd_data;
        end
    end

endmodule
