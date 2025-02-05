// MMIO UART

// States
`define RISKY_UART_STATE_IDLE   3'd0
`define RISKY_UART_STATE_START  3'd1
`define RISKY_UART_STATE_DATA   3'd2
`define RISKY_UART_STATE_PARITY 3'd3
`define RISKY_UART_STATE_STOP   3'd4

module risky_uart #(
    parameter CLK_FREQ = 100000000, BAUD_RATE = 9200,
    parameter addr_tx_data = 32'h20000008, addr_tx_ack = 32'h2000000C
)(
    input clk, mem_read, mem_write, rx,
    input [31:0] mem_addr,
    inout [31:0] mem_data,
    output tx
);
    reg tx_start = 0;
    wire tx_ack, tx_stop;
    reg [7:0] tx_data;
    risky_uart_tx #(CLK_FREQ, BAUD_RATE) risky_uart_tx_inst (
        clk, tx_start,
        tx_data,
        tx, tx_ack, tx_stop
    );

    // MMIO registers
    reg [31:0] mmio_tx_data = 0, mmio_tx_ack = 0;

    // Output TX ACK to memory bus
    assign mem_data = (mem_read && mem_addr == addr_tx_ack) ? mmio_tx_ack : {32{1'bz}};

    always @(posedge clk) begin
        if (mem_write && mem_addr == addr_tx_ack) begin
            mmio_tx_ack <= mem_data;
        end else if (mem_write && mem_addr == addr_tx_data) begin
            mmio_tx_data <= mem_data;
        end

        if (!tx_start && mmio_tx_ack >= 1) begin
            tx_start <= 1;
            tx_data <= mmio_tx_data[7:0];
        end else if (tx_start && tx_ack) begin
            tx_start <= 0;
        end else if (tx_stop) begin
            mmio_tx_ack <= 0;
        end
    end
endmodule

module risky_uart_tx #(
    parameter CLK_FREQ = 100000000, BAUD_RATE = 9200
)(
    input clk, start,
    input [7:0] data,
    output reg tx, ack, stop
);
    reg [2:0] state = `RISKY_UART_STATE_IDLE;

    reg [31:0] clk_div = 0;
    reg clk_uart;

    always @(posedge clk) begin
        if (clk_div >= CLK_FREQ/BAUD_RATE) begin
            clk_uart <= !clk_uart;
            clk_div <= 0;
        end else
            clk_div <= clk_div + 1;
    end

    reg [2:0] data_out_counter = 0;
    reg parity = 0;

    always @(posedge clk_uart) begin
        tx <= 1; ack <= 0; stop <= 0;

        case (state)
            `RISKY_UART_STATE_IDLE: begin
                if (start)
                    state <= `RISKY_UART_STATE_START;
            end
            `RISKY_UART_STATE_START: begin
                tx <= 0;
                state <= `RISKY_UART_STATE_DATA;
            end
            `RISKY_UART_STATE_DATA: begin
                tx <= data[data_out_counter];
                parity <= parity + data[data_out_counter];
                if (data_out_counter >= 3'd7) begin
                    data_out_counter <= 0;
                    state <= `RISKY_UART_STATE_PARITY;
                end else
                    data_out_counter <= data_out_counter + 1;
            end
            `RISKY_UART_STATE_PARITY: begin
                tx <= parity;
                state <= `RISKY_UART_STATE_STOP;
            end
            `RISKY_UART_STATE_STOP: begin
                stop <= 1;
                state <= `RISKY_UART_STATE_IDLE;
            end
            default: state <= `RISKY_UART_STATE_IDLE;
        endcase
    end
endmodule

module risky_uart_rx();

endmodule
