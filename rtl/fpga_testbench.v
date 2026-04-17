// ============================================================
// Testbench : jhf_top_tb
// Project   : jhf
// ============================================================
`timescale 1ns / 1ps

module jhf_top_tb;

    // DUT ports
    reg        clk        = 0;
    reg        rst_n      = 0;
    reg [15:0] reg_addr   = 0;
    reg [15:0] reg_wdata  = 0;
    wire[15:0] reg_rdata;
    reg        reg_wr     = 0;
    reg        reg_rd     = 0;
    wire       busy;
    wire       error_flag;

    // Instantiate DUT
    jhf_top dut (.*);

    // Clock 50 MHz
    always #10 clk = ~clk;

    // Tasks
    task write_reg;
        input [15:0] addr;
        input [15:0] data;
        begin
            @(posedge clk); reg_addr = addr; reg_wdata = data; reg_wr = 1;
            @(posedge clk); reg_wr = 0;
        end
    endtask

    task read_reg;
        input  [15:0] addr;
        output [15:0] data;
        begin
            @(posedge clk); reg_addr = {1'b1, addr[14:0]}; reg_rd = 1;
            @(posedge clk); data = reg_rdata; reg_rd = 0;
        end
    endtask

    reg [15:0] rd_data;
    integer pass_cnt = 0;
    integer fail_cnt = 0;

    initial begin
        $dumpfile("jhf_tb.vcd");
        $dumpvars(0, jhf_top_tb);

        // Reset
        rst_n = 0; repeat(5) @(posedge clk);
        rst_n = 1; repeat(2) @(posedge clk);

        // Test 1: Scratch register read-back
        write_reg(16'h0003, 16'hA5A5);
        read_reg(16'h0003, rd_data);
        if (rd_data === 16'hA5A5) begin
            $display("PASS: Scratch R/W 0xA5A5"); pass_cnt = pass_cnt + 1;
        end else begin
            $display("FAIL: Scratch R/W got %04X expected A5A5", rd_data); fail_cnt = fail_cnt + 1;
        end

        // Test 2: Version register read-only
        read_reg(16'h0002, rd_data);
        if (rd_data === 16'h0100) begin
            $display("PASS: VERSION = 0x0100"); pass_cnt = pass_cnt + 1;
        end else begin
            $display("FAIL: VERSION got %04X expected 0100", rd_data); fail_cnt = fail_cnt + 1;
        end

        repeat(5) @(posedge clk);

        if (fail_cnt == 0)
            $display("TESTBENCH: ALL TESTS PASSED (%0d tests)", pass_cnt);
        else
            $display("TESTBENCH: %0d FAILURES of %0d tests", fail_cnt, pass_cnt + fail_cnt);

        $finish;
    end

endmodule
