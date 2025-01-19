`timescale 1ns / 1ps

module risky_testbench();
    reg clk = 0;
    always #1 clk = ~clk;

    reg [31:0] mem [4000000:0];
    reg [31:0] rom [1000000:0];
    wire [31:0] mem_data, mem_addr, mem_addr_ram;
    wire mem_oe, mem_we, mem_rom, mem_ram;

    assign mem_rom = mem_addr[31:26] == 0;
    assign mem_ram = mem_addr[31:26] == 1;
    assign mem_addr_ram = {3'd0, mem_addr[25:0]};

    assign mem_data = (mem_oe & mem_ram) ? mem[mem_addr_ram] : {32{1'bz}};
    assign mem_data = (mem_oe & mem_rom) ? rom[mem_addr] : {32{1'bz}};

    always @(posedge clk) begin
        if (mem_we & mem_ram)
            mem[mem_addr_ram] <= mem_data;
    end

    always @(posedge clk) begin
        if (mem[0]) begin
            $display("Application returned (", mem[1], "), ending simulation");
            $finish;
        end
        if (mem[3]) begin
            $write("%s", mem[2][7:0]);
            mem[3] <= 0;
        end
    end

    risky rsky (clk, mem_data, mem_addr, mem_oe, mem_we);

    integer file, bytes_read, i;
    reg [7:0] data [4000000:0];
    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0,risky_testbench);

        file = $fopen("out.bin", "rb");
        if (file == 0) begin
            $display("Failed to open out.bin");
            $finish;
        end

        bytes_read = $fread(data, file);
        $fclose(file);

        // Convert the byte array into 32-bit words
        for (i = 0; i <= bytes_read / 4; i = i + 1) begin
            rom[i] = {data[i*4+3], data[i*4+2], data[i*4+1], data[i*4]};
        end

        $display("Risky execution started");

        #100000

        $display("Application did not return within simulation period");
        $finish;
    end
endmodule
