module risky (
  input clk,
  inout [31:0] data,
  output [31:0] addr,
  output write_enable
);

  wire [31:0] fetch_data, fetch_address;
  risky_fetch fetch (
    .clk(clk),
    .mem_data(fetch_data),
    .mem_address(fetch_address)
  );

  wire [31:0] writeback_reg_data;
  wire [4:0] writeback_reg_sel;
  risky_writeback writeback (
    .clk(clk),
    .reg_data(writeback_reg_data),
    .reg_sel(writeback_reg_sel)
  );

  risky_regfile regfile (
    .clk(clk),
    .out_a(),
    .out_a_sel(),
    .out_b(),
    .out_b_sel(),
    .in(writeback_reg_data),
    .in_sel(writeback_reg_sel)
  );

  // FIXME this is temporary until memory conflicts can be handled with a single port ram
  risky_dualportmem tempmem (
    .clk(clk),
    .a_write(1'b0),
    .b_write(),
    .a_address(fetch_address),
    .b_address(),
    .a_data(fetch_data),
    .b_data()
  );

  // TODO global wire for stalls and hazards
  wire stall;
  // TODO/FIXME if a branch instruction enters the pipeline just stall lol
endmodule

// Create our own dual port memory for now to avoid implimenting pipeline stalling
module risky_dualportmem (
  input clk, a_write, b_write,
  input [31:0] a_address, b_address,
  inout reg [31:0] a_data, b_data
);
  reg [31:0] mem [1024:0];
  always @(posedge clk) begin
    if (a_write)
      mem[a_address] <= a_data;
    else
      a_data = mem[a_address];
    if (b_write)
      mem[b_address] <= b_data;
    else
      b_data = mem[b_address];
  end
endmodule
