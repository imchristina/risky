`define RISKY_REGFILE_READ    2'd1
`define RISKY_REGFILE_WRITE   2'd2
`define RISKY_REGFILE_SELECT  2'd3

module risky_regfile (
  input clk,
  input [1:0] ctrl,
  inout [31:0] bus
);
  reg [4:0] select = 0;
  reg [31:0] regfile [31:0];

  assign bus = (ctrl == `RISKY_REGFILE_READ) ? regfile[select] : {32{1'bz}};

  always @(posedge clk) begin
    if (ctrl == `RISKY_REGFILE_WRITE)
      regfile[select] <= bus;
    if (ctrl == `RISKY_REGFILE_SELECT)
      select <= bus[4:0];
  end
endmodule
