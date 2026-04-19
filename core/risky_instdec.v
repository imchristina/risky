module risky_instdec (
    input [31:0] inst,

    output reg [`RISKY_EXECUTE_CTRL_LEN-1:0] execute_ctrl,
    output reg [`RISKY_MEM_CTRL_LEN-1:0] mem_ctrl,
    output reg [`RISKY_WRITEBACK_CTRL_LEN-1:0] writeback_ctrl
);

    always @(*) begin
        execute_ctrl = 0;
        mem_ctrl = 0;
        writeback_ctrl = 0;

        casez (inst[`RISKY_INST_OP])
            `RISKY_INST_TYPE_R: begin
                execute_ctrl = `RISKY_EXECUTE_CTRL_OP;
                mem_ctrl = `RISKY_MEM_CTRL_NOP;
                writeback_ctrl = `RISKY_WRITEBACK_CTRL_REG;
            end
        endcase
    end

endmodule
