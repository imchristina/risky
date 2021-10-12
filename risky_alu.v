// Mode input is simply {F7 (single bit), F3} to simplify instruction decoding

module risky_alu (
  input clk,
  input [3:0] mode,
  input [31:0] a,b,
  output reg [31:0] c
);
  wire [2:0] f3;
  wire f7;
  assign f3 = mode[2:0];
  assign f7 = mode[3];

  always @(posedge clk) begin
    case (f3)
      `RISKY_INST_F3_ACC: begin
        case (f7)
          `RISKY_INST_F7_ADD:
            c <= a + b;
          `RISKY_INST_F7_SUB:
            c <= a - b;
        endcase
      end

    endcase
  end
endmodule
