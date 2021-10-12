// Also contains program counter
// TODO PC overwriting for branches

module risky_fetch (
  input clk,
  input [31:0] mem_data,
  output [31:0] mem_address
);
  reg [31:0] pc = 0;

  always @(posedge clk) begin
    pc <= pc + 32'd4;
  end

  risky_decode decode (
      .clk(clk),
      .inst(mem_data),
      .pc(pc)
    );
endmodule
