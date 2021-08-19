`define RISKY_PC_READ   2'd1
`define RISKY_PC_WRITE  2'd2
`define RISKY_PC_INC    2'd3

module risky_pc (
  input clk,
  input [1:0] ctrl,
  inout [31:0] bus
);
  wire read,write,inc;
  assign read = ctrl == `RISKY_PC_READ;
  assign write = ctrl == `RISKY_PC_WRITE;
  assign inc = ctrl == `RISKY_PC_INC;

  reg [31:0] value = 0;

  assign bus = read ? value : {32{1'bz}};

  always @(posedge clk) begin
    if (write)
      value <= bus;
    if (inc)
      value <= value + 4;
  end
endmodule
