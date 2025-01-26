`timescale 1ns / 1ps

module risky_testbench();
    reg clk = 0;
    always #1 clk = ~clk;

    reg [31:0] ram [4000000:0];
    reg [31:0] rom [1000000:0];
    reg [31:0] mmio [15:0];
    wire [31:0] mem_data, mem_addr, mem_addr_ram;
    wire mem_oe, mem_we, mem_rom, mem_ram;

    assign mem_rom = mem_addr[31:26] == 6'd0;
    assign mem_ram = mem_addr[31:26] == 6'd1;
    assign mem_mmio = mem_addr[31:26] == 6'd2;
    assign mem_addr_ram = {3'd0, mem_addr[25:0]};

    assign mem_data = (mem_oe & mem_ram) ? ram[mem_addr_ram] : {32{1'bz}};
    assign mem_data = (mem_oe & mem_rom) ? rom[mem_addr] : {32{1'bz}};
    assign mem_data = (mem_oe & mem_mmio) ? mmio[mem_addr_ram] : {32{1'bz}};

    always @(posedge clk) begin
        if (mem_we & mem_ram)
            ram[mem_addr_ram] <= mem_data;
        if (mem_we & mem_mmio)
            mmio[mem_addr_ram] <= mem_data;
    end

    // MMIO handler
    always @(posedge clk) begin
        // Application finished execution
        if (mmio[0]) begin
            $display("Application returned (", mmio[1], "), ending simulation");
            $finish;
        end

        // STDOUT
        if (mmio[3]) begin
            $write("%s", mmio[2][7:0]);
            mmio[3] <= 0;
        end

        // STDIN
        if (mmio[5]) begin
            mmio[4] = $fgetc('h8000_0000);
            mmio[5] <= 0;
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
