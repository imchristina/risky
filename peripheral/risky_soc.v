// System on a chip

module risky_soc (
    input clk, rx,
    output tx
);
    wire mem_oe, mem_we;
    wire [31:0] mem_data, mem_addr;

    risky risky_soc_inst (clk, mem_data, mem_addr, mem_oe, mem_we);

    risky_uart #(
        .CLK_FREQ(12000000), .BAUD_RATE(9200),
        .addr_tx_data(32'h20000008), .addr_tx_ack(32'h2000000C)
    ) uart_soc_inst (
        clk, mem_oe, mem_we, rx, mem_addr, mem_data, tx
    );

    reg [31:0] ram [1000:0];
    reg [31:0] rom [1000:0];
    wire [31:0] mem_addr_ram;
    wire mem_rom, mem_ram;

    assign mem_rom = mem_addr[31:26] == 6'd0;
    assign mem_ram = mem_addr[31:26] == 6'd1;
    assign mem_addr_ram = {3'd0, mem_addr[25:0]};

    assign mem_data = (mem_oe & mem_ram) ? ram[mem_addr_ram] : {32{1'bz}};
    assign mem_data = (mem_oe & mem_rom) ? rom[mem_addr] : {32{1'bz}};

    always @(posedge clk) begin
        if (mem_we & mem_ram)
            ram[mem_addr_ram] <= mem_data;
    end

    initial begin
        $readmemh("out.hex", rom);
    end
endmodule
