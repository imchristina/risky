// Microcoded all the way down
// If it's easier to make a resource shared, do it even if it means terrible performance

module risky (
  input clk,
  inout [31:0] data,
  output [31:0] addr,
  output write_enable
);
  // The main bus that everything connects to
  wire [31:0] bus;

  wire [1:0] pc_ctrl;
  risky_pc pc (
    .clk(clk),
    .ctrl(pc_ctrl),
    .bus(bus)
  );

  wire [1:0] regfile_ctrl;
  risky_regfile regfile (
    .clk(clk),
    .ctrl(regfile_ctrl),
    .bus(bus)
  );

  wire [2:0] alu_ctrl;
  risky_alu alu (
    .clk(clk),
    .ctrl(alu_ctrl),
    .bus(bus)
  );

  risky_ctrl ctrl (
    .clk(clk),
    .bus(bus),
    .pc(pc_ctrl),
    .alu(alu_ctrl)
  );
endmodule
