// Testbench : hm_top_tb
// Project   : hm
`timescale 1ns / 1ps

module hm_top_tb;
    reg         clk = 0;
    reg         rst_n = 0;
    reg  [15:0] reg_addr = 0, reg_wdata = 0;
    wire [15:0] reg_rdata;
    reg         reg_wr = 0, reg_rd = 0;
    wire        irq_out, busy, error_flag;
    wire        spi_clk_w, spi_mosi_w;
    wire [3:0]  spi_cs_n_w;
    reg         spi_miso = 0;
    reg  [31:0] adc_data = 0;
    reg         adc_data_valid = 0;
    wire        adc_sync;
    wire [7:0]  gpio_out;
    reg  [7:0]  gpio_in = 0;
    reg         uart_rxd = 1;
    wire        uart_txd;

    hm_top dut (.*);
    always #0.5 clk = ~clk;

    task write_reg(input [15:0] a, input [15:0] d);
        begin @(posedge clk); reg_addr=a; reg_wdata=d; reg_wr=1;
              @(posedge clk); reg_wr=0; end
    endtask
    task read_reg(input [15:0] a, output [15:0] d);
        begin @(posedge clk); reg_addr=a; reg_rd=1;
              @(posedge clk); d=reg_rdata; reg_rd=0; end
    endtask

    reg [15:0] rd; integer pass_c=0, fail_c=0;
    task check(input [15:0] exp, input [8*32-1:0] label);
        if (rd===exp) begin $display("PASS: %0s = 0x%04X",label,rd); pass_c=pass_c+1; end
        else          begin $display("FAIL: %0s got 0x%04X exp 0x%04X",label,rd,exp); fail_c=fail_c+1; end
    endtask

    initial begin
        $dumpfile("hm_tb.vcd"); $dumpvars(0, hm_top_tb);
        rst_n=0; repeat(5) @(posedge clk); rst_n=1; repeat(2) @(posedge clk);

        // T1: Version register
        read_reg(16'h0002, rd); check(16'h0100, "VERSION");

        // T2: Scratch R/W
        write_reg(16'h0003, 16'hCAFE);
        read_reg(16'h0003, rd); check(16'hCAFE, "SCRATCH");

        // T3: CTRL write + busy assert
        write_reg(16'h0000, 16'h0003);  // enable + start
        repeat(3) @(posedge clk);
        read_reg(16'h0001, rd);
        if (rd[0]) begin $display("PASS: busy asserted"); pass_c=pass_c+1; end
        else       begin $display("FAIL: busy not asserted"); fail_c=fail_c+1; end

        // T4: ADC capture
        adc_data = 32'hABCD; adc_data_valid = 1;
        repeat(5) @(posedge clk); adc_data_valid = 0;
        read_reg(16'h0010, rd); check(16'hABCD, "ADC_DATA_L");

        // T5: SPI transfer
        write_reg(16'h0021, 16'h55AA);  // TX data
        write_reg(16'h0020, 16'h0008);  // slave 0, start
        repeat(40) @(posedge clk);
        read_reg(16'h0023, rd);
        $display("INFO: SPI status = 0x%04X", rd);

        // T6: IRQ mask/status
        write_reg(16'hF00, 16'h0001);  // enable IRQ[0]
        read_reg(16'hF01, rd);
        $display("INFO: IRQ status = 0x%04X", rd);

        // T7: Unknown register returns 0xDEAD
        read_reg(16'hFFF, rd); check(16'hDEAD, "UNKNOWN_REG");

        repeat(10) @(posedge clk);
        if (fail_c==0) $display("\nALL %0d TESTS PASSED", pass_c);
        else           $display("\n%0d FAILURES of %0d tests", fail_c, pass_c+fail_c);
        $finish;
    end
endmodule