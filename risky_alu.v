// Mode input is simply {F7 (single bit), F3} to simplify instruction decoding

`define RISKY_ALU_READ        3'd1
`define RISKY_ALU_WRITE_A     3'd2
`define RISKY_ALU_WRITE_B     3'd3
`define RISKY_ALU_WRITE_MODE  3'd4

module risky_alu (
  input clk,
  input [2:0] ctrl,
  inout [31:0] bus
);
  reg [31:0] a,b,result = 0;
  reg [3:0] mode = 0;

  wire [2:0] f3;
  wire f7;
  assign f3 = mode[2:0];
  assign f7 = mode[3];

  assign bus = (ctrl == `RISKY_ALU_READ) ? result : {32{1'bz}};

  always @(posedge clk) begin
    if (ctrl == `RISKY_ALU_WRITE_A)
      a <= bus;
    if (ctrl == `RISKY_ALU_WRITE_B)
      b <= bus;
    if (ctrl == `RISKY_ALU_WRITE_MODE)
      mode <= bus[3:0];
  end

  always @(*) begin
    result = 0;
    case (f3)
      `RISKY_INST_F3_ACC: begin
        case (f7)
          `RISKY_INST_F7_ADD:
            result = a + b;
          `RISKY_INST_F7_SUB:
            result = a - b;
        endcase
      end

    endcase
  end
endmodule
