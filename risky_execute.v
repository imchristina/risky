module risky_execute (
  input clk,
  input [31:0] pc
);
  risky_alu alu (
    .clk(clk)
  );
endmodule
