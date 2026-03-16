module risky_pc (
    input clk,

    output [31:0] raddr,
    input inc_en,

    input [31:0] waddr,
    input wr_en
);

    reg [31:0] pc = 32'd0;

    assign raddr = pc;

    always @(posedge clk) begin
        if (wr_en) begin
            pc <= waddr;
        end else if (inc_en) begin
            pc <= pc + 32'd4;
        end
    end

endmodule
