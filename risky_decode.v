module risky_decode (
  input clk,
  input [31:0] inst, pc
);
  // Alias wires
  wire [6:0] op,f7;
  wire [4:0] rd,rs1,rs2;
  wire [2:0] f3;

  // Alias assignments
  assign op = inst[`RISKY_INST_OP];
  assign rd = inst[`RISKY_INST_RD];

  // Buffer the program counter to stay in sync
  reg pc_buff;

  always @(*) begin
    case (op)
      `RISKY_INST_TYPE_R: begin

      end
      `RISKY_INST_TYPE_J: begin
        // TODO branch/mem types signal a bubble to the fetch stage
      end
    endcase

    pc_buff <= pc;
  end

  risky_execute execute (
      .clk(clk),
      .pc(pc_buff)
    );
endmodule
