// Two out one in regfile
module risky_regfile (
  input clk,
  input [4:0] out_a_sel, out_b_sel, in_sel,
  input [31:0] in,
  output reg [31:0] out_a, out_b
);
  reg [31:0] regfile [31:0];

  always @(posedge clk) begin
    out_a <= regfile[out_a_sel];
    out_b <= regfile[out_b_sel];
    regfile[in_sel] <= in;
  end
endmodule
