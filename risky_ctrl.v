module risky_ctrl (
  input clk,
  inout [31:0] bus,
  output [1:0] pc,
  output [1:0] regfile,
  output [2:0] alu
);
  // Main control registers
  reg [2:0] step = 0;
  reg [31:0] inst;

  // Alias wires
  wire [6:0] op,f7;
  wire [4:0] rd,rs1,rs2;
  wire [2:0] f3;

  // Alias assignments
  assign op = inst & `RISKY_INST_MASK_OP;
  assign rd = inst & `RISKY_INST_MASK_RD;

  wire step_reset;

  always @(negedge clk) begin
    step <= step + 1'b1;
    if (step_reset)
      step <= 0;
  end

  always @(*) begin
    case (op)
      `RISKY_INST_TYPE_R: begin

      end
    endcase
  end
endmodule
