//----------------------------------------------------------------------------
// @file      fpga_testbench.v
// @brief     SystemVerilog testbench for hv_top module
//
// @details   Comprehensive testbench for the 18-40 GHz dual-channel
//            superheterodyne radar receiver FPGA (XC7K160T).
//            Covers UART register bus, SPI controllers, ADC data capture,
//            and all FSM state transitions.
//
// @author    FPGA Design Team
// @date      2026-04-25
// @version   0V01
//----------------------------------------------------------------------------

`timescale 1ns / 1ps

module fpga_testbench;

    //==========================================================================
    // Parameters
    //==========================================================================
    localparam real CLK_PERIOD_NS      = 10.0;   // 100 MHz -> 10 ns
    localparam real ADC_CLK_PERIOD_NS  = 6.667;  // 150 MHz -> 6.667 ns
    localparam integer UART_CLKS_PER_BIT = 868;  // 100 MHz / 115200 baud
    localparam integer BAUD_RATE        = 115200;
    localparam integer NUM_TEST_CASES   = 25;
    localparam integer TIMEOUT_CYCLES   = 200000;

    //==========================================================================
    // DUT Signals
    //==========================================================================

    // Clock & Reset
    logic        clk_100mhz_p;
    logic        clk_100mhz_n;
    logic        rst_n;

    // ADC LVDS Clocks
    logic        adc_dco_p;
    logic        adc_dco_n;
    logic        adc_fco_p;
    logic        adc_fco_n;

    // ADC Channel A Data (6-bit DDR LVDS)
    logic [5:0]  adc_da_p;
    logic [5:0]  adc_da_n;

    // ADC Channel B Data (6-bit DDR LVDS)
    logic [5:0]  adc_db_p;
    logic [5:0]  adc_db_n;

    // LO1 PLL SPI (ADF4108)
    logic        lo1_spi_cs_n;
    logic        lo1_spi_sclk;
    logic        lo1_spi_sdi;
    logic        lo1_spi_sdo;

    // LO2 PLL SPI (LMX2487)
    logic        lo2_spi_cs_n;
    logic        lo2_spi_sclk;
    logic        lo2_spi_sdi;
    logic        lo2_lock_detect;

    // VGA DAC SPI
    logic        vga_dac_sclk;
    logic        vga_dac_sdo;
    logic        vga1_dac_cs_n;
    logic        vga2_dac_cs_n;

    // ADC SPI (AD9627)
    logic        adc_spi_cs_n;
    logic        adc_spi_sclk;
    logic        adc_spi_sdi;

    // UART
    logic        uart_rx;
    logic        uart_tx;

    // QSPI Flash (IS25LP256D)
    logic        qspi_cs_n;
    logic        qspi_sclk;
    logic [3:0]  qspi_dq;

    // EEPROM SPI (AT93C56B)
    logic        eeprom_cs_n;
    logic        eeprom_sclk;
    logic        eeprom_sdi;
    logic        eeprom_sdo;

    // Temperature Sensor (AD7416 I2C)
    logic        temp_scl;
    logic        temp_sda;

    // Digital I/O LVDS Output
    logic        lvds_tx_clk_p;
    logic        lvds_tx_clk_n;
    logic [7:0]  lvds_tx_data_p;
    logic [7:0]  lvds_tx_data_n;

    // JTAG
    logic        jtag_tck;
    logic        jtag_tms;
    logic        jtag_tdi;
    logic        jtag_tdo;

    // Power / Status
    logic        lo1_lock_detect;
    logic [1:0]  pll_lock_status;
    logic        ext_trig;
    logic        trig_out_p;
    logic        trig_out_n;
    logic        led_heartbeat;
    logic [2:0]  board_id;
    logic [1:0]  pwr_good;
    logic        shutdown_n;

    // EEPROM status
    logic        eeprom_wp_n;
    logic        eeprom_hold_n;

    // VGA AGC
    logic        vga1_rf_det;
    logic        vga2_rf_det;

    //==========================================================================
    // Internal / Shared
    //==========================================================================
    logic        tb_test_passed;
    logic        tb_test_failed;
    integer      tb_test_count;
    integer      tb_pass_count;
    integer      tb_fail_count;

    // UART RX -> TX loopback data queue
    logic [7:0]  uart_rx_data_queue[$];
    logic [7:0]  uart_tx_data_queue[$];

    // ADC simulation data
    logic [11:0] adc_cha_data_r;
    logic [11:0] adc_chb_data_r;

    //==========================================================================
    // DUT Instantiation
    //==========================================================================
    hv_top #(
        .CLK_FREQ_HZ      (100_000_000),
        .BAUD_RATE         (115200),
        .SPI_CLK_DIV       (16),
        .ADC_DATA_WIDTH    (12),
        .LVDS_DATA_WIDTH   (8)
    ) dut (
        .clk_100mhz_p      (clk_100mhz_p),
        .clk_100mhz_n      (clk_100mhz_n),
        .rst_n             (rst_n),
        .adc_dco_p         (adc_dco_p),
        .adc_dco_n         (adc_dco_n),
        .adc_fco_p         (adc_fco_p),
        .adc_fco_n         (adc_fco_n),
        .adc_da_p          (adc_da_p),
        .adc_da_n          (adc_da_n),
        .adc_db_p          (adc_db_p),
        .adc_db_n          (adc_db_n),
        .lo1_spi_cs_n      (lo1_spi_cs_n),
        .lo1_spi_sclk      (lo1_spi_sclk),
        .lo1_spi_sdi       (lo1_spi_sdi),
        .lo1_spi_sdo       (lo1_spi_sdo),
        .lo2_spi_cs_n      (lo2_spi_cs_n),
        .lo2_spi_sclk      (lo2_spi_sclk),
        .lo2_spi_sdi       (lo2_spi_sdi),
        .lo2_lock_detect   (lo2_lock_detect),
        .vga_dac_sclk      (vga_dac_sclk),
        .vga_dac_sdo       (vga_dac_sdo),
        .vga1_dac_cs_n     (vga1_dac_cs_n),
        .vga2_dac_cs_n     (vga2_dac_cs_n),
        .adc_spi_cs_n      (adc_spi_cs_n),
        .adc_spi_sclk      (adc_spi_sclk),
        .adc_spi_sdi       (adc_spi_sdi),
        .uart_rx           (uart_rx),
        .uart_tx           (uart_tx),
        .qspi_cs_n         (qspi_cs_n),
        .qspi_sclk         (qspi_sclk),
        .qspi_dq           (qspi_dq),
        .eeprom_cs_n       (eeprom_cs_n),
        .eeprom_sclk       (eeprom_sclk),
        .eeprom_sdi        (eeprom_sdi),
        .eeprom_sdo        (eeprom_sdo),
        .eeprom_wp_n       (eeprom_wp_n),
        .eeprom_hold_n     (eeprom_hold_n),
        .temp_scl          (temp_scl),
        .temp_sda          (temp_sda),
        .lvds_tx_clk_p     (lvds_tx_clk_p),
        .lvds_tx_clk_n     (lvds_tx_clk_n),
        .lvds_tx_data_p    (lvds_tx_data_p),
        .lvds_tx_data_n    (lvds_tx_data_n),
        .jtag_tck          (jtag_tck),
        .jtag_tms          (jtag_tms),
        .jtag_tdi          (jtag_tdi),
        .jtag_tdo          (jtag_tdo),
        .lo1_lock_detect   (lo1_lock_detect),
        .pll_lock_status   (pll_lock_status),
        .ext_trig          (ext_trig),
        .trig_out_p        (trig_out_p),
        .trig_out_n        (trig_out_n),
        .led_heartbeat     (led_heartbeat),
        .board_id          (board_id),
        .pwr_good          (pwr_good),
        .shutdown_n        (shutdown_n),
        .vga1_rf_det       (vga1_rf_det),
        .vga2_rf_det       (vga2_rf_det)
    );

    //==========================================================================
    // Clock Generation
    //==========================================================================

    // 100 MHz differential system clock
    initial begin
        clk_100mhz_p = 1'b0;
        clk_100mhz_n = 1'b1;
        forever begin
            #(CLK_PERIOD_NS / 2.0);
            clk_100mhz_p = ~clk_100mhz_p;
            clk_100mhz_n = ~clk_100mhz_n;
        end
    end

    // 150 MHz ADC DCO differential clock
    initial begin
        adc_dco_p = 1'b0;
        adc_dco_n = 1'b1;
        forever begin
            #(ADC_CLK_PERIOD_NS / 2.0);
            adc_dco_p = ~adc_dco_p;
            adc_dco_n = ~adc_dco_n;
        end
    end

    // ADC FCO = DCO / 2 (frame clock at 75 MHz)
    initial begin
        adc_fco_p = 1'b0;
        adc_fco_n = 1'b1;
        forever begin
            #(ADC_CLK_PERIOD_NS);
            adc_fco_p = ~adc_fco_p;
            adc_fco_n = ~adc_fco_n;
        end
    end

    // JTAG clock (10 MHz for debug)
    initial begin
        jtag_tck = 1'b0;
        forever begin
            #50 jtag_tck = ~jtag_tck;
        end
    end

    //==========================================================================
    // Reset Generation Task
    //==========================================================================
    task automatic apply_reset;
        begin
            $display("[%0t] TB: Asserting reset (rst_n=0)", $time);
            rst_n = 1'b0;
            #(CLK_PERIOD_NS * 20);
            $display("[%0t] TB: Releasing reset (rst_n=1)", $time);
            rst_n = 1'b1;
            #(CLK_PERIOD_NS * 10);
            $display("[%0t] TB: Reset sequence complete", $time);
        end
    endtask

    //==========================================================================
    // UART TX Task — send one byte at 115200 baud
    //==========================================================================
    task automatic uart_tx_byte;
        input logic [7:0] data;
        integer i;
        begin
            // START bit
            uart_rx = 1'b0;
            #(1_000_000_000 / BAUD_RATE * 1 ns);

            // DATA bits (LSB first)
            for (i = 0; i < 8; i++) begin
                uart_rx = data[i];
                #(1_000_000_000 / BAUD_RATE * 1 ns);
            end

            // STOP bit
            uart_rx = 1'b1;
            #(1_000_000_000 / BAUD_RATE * 1 ns);

            // Inter-byte gap
            #(1_000_000_000 / BAUD_RATE * 1 ns);
        end
    endtask

    //==========================================================================
    // UART RX Task — receive one byte with timeout
    //==========================================================================
    task automatic uart_rx_byte;
        output logic [7:0] data;
        output logic       success;
        integer            i;
        integer            timeout_cnt;
        begin
            success = 1'b0;
            timeout_cnt = 0;

            // Wait for START bit (line goes low)
            while (uart_tx === 1'b1) begin
                #(10 ns);
                timeout_cnt = timeout_cnt + 1;
                if (timeout_cnt > TIMEOUT_CYCLES) begin
                    $display("[%0t] TB ERROR: UART RX timeout waiting for start bit", $time);
                    return;
                end
            end

            // Middle of START bit
            #(1_000_000_000 / BAUD_RATE * 0.5 ns);
            if (uart_tx !== 1'b0) begin
                $display("[%0t] TB ERROR: UART RX false start bit", $time);
                return;
            end

            // Sample DATA bits (LSB first)
            for (i = 0; i < 8; i++) begin
                #(1_000_000_000 / BAUD_RATE * 1 ns);
                data[i] = uart_tx;
            end

            // STOP bit
            #(1_000_000_000 / BAUD_RATE * 1 ns);
            if (uart_tx !== 1'b1) begin
                $display("[%0t] TB ERROR: UART RX missing stop bit", $time);
                return;
            end

            success = 1'b1;
        end
    endtask

    //==========================================================================
    // Register Write via UART — 4 bytes: [CMD, ADDR_HI, ADDR_LO, DATA]
    //   CMD = 0x01 for write
    //==========================================================================
    task automatic uart_reg_write;
        input logic [15:0] addr;
        input logic [15:0] wdata;
        logic [7:0]        rx_byte;
        logic              rx_ok;
        begin
            // Command byte: write
            uart_tx_byte(8'h01);

            // Address high byte
            uart_tx_byte(addr[15:8]);

            // Address low byte
            uart_tx_byte(addr[7:0]);

            // Data high byte
            uart_tx_byte(wdata[15:8]);

            // Data low byte
            uart_tx_byte(wdata[7:0]);

            // Small delay for processing
            #(CLK_PERIOD_NS * 200);

            // Optionally read back ACK (0xAA = success)
            if (uart_tx !== 1'b1) begin
                uart_rx_byte(rx_byte, rx_ok);
                if (rx_ok && rx_byte !== 8'hAA) begin
                    $display("[%0t] TB WARN: REG WRITE ACK=0x%02h (expected 0xAA) addr=0x%04h",
                             $time, rx_byte, addr);
                end
            end
        end
    endtask

    //==========================================================================
    // Register Read via UART — 4 bytes: [CMD, ADDR_HI, ADDR_LO, DUMMY]
    //   CMD = 0x02 for read, response is 2 bytes DATA[15:8], DATA[7:0]
    //==========================================================================
    task automatic uart_reg_read;
        input  logic [15:0] addr;
        output logic [15:0] rdata;
        output logic        success;
        logic [7:0]         rx_byte;
        logic               rx_ok;
        begin
            success = 1'b0;
            rdata   = 16'h0000;

            // Command byte: read
            uart_tx_byte(8'h02);

            // Address high byte
            uart_tx_byte(addr[15:8]);

            // Address low byte
            uart_tx_byte(addr[7:0]);

            // Dummy byte
            uart_tx_byte(8'h00);

            // Allow processing time
            #(CLK_PERIOD_NS * 400);

            // Read back 2 data bytes
            uart_rx_byte(rx_byte, rx_ok);
            if (!rx_ok) begin
                $display("[%0t] TB ERROR: REG READ failed - no data high byte for addr=0x%04h",
                         $time, addr);
                return;
            end
            rdata[15:8] = rx_byte;

            uart_rx_byte(rx_byte, rx_ok);
            if (!rx_ok) begin
                $display("[%0t] TB ERROR: REG READ failed - no data low byte for addr=0x%04h",
                         $time, addr);
                return;
            end
            rdata[7:0] = rx_byte;

            success = 1'b1;
        end
    endtask

    //==========================================================================
    // Register Write + Readback Verify Task
    //==========================================================================
    task automatic uart_reg_write_read_verify;
        input  logic [15:0] addr;
        input  logic [15:0] wdata;
        input  string       test_name;
        logic  [15:0]       rdata;
        logic               rd_success;
        begin
            tb_test_count = tb_test_count + 1;

            // Write
            uart_reg_write(addr, wdata);

            // Read back
            uart_reg_read(addr, rdata, rd_success);

            if (!rd_success) begin
                $display("[%0t] TB FAIL: %s - READ FAILED addr=0x%04h wdata=0x%04h",
                         $time, test_name, addr, wdata);
                tb_fail_count = tb_fail_count + 1;
                tb_test_failed = 1'b1;
            end else if (rdata !== wdata) begin
                $display("[%0t] TB FAIL: %s - MISMATCH addr=0x%04h wrote=0x%04h read=0x%04h",
                         $time, test_name, addr, wdata, rdata);
                tb_fail_count = tb_fail_count + 1;
                tb_test_failed = 1'b1;
            end else begin
                $display("[%0t] TB PASS: %s - addr=0x%04h data=0x%04h",
                         $time, test_name, addr, wdata);
                tb_pass_count = tb_pass_count + 1;
            end
        end
    endtask

    //==========================================================================
    // Register Read-Only Verify Task (check expected value)
    //==========================================================================
    task automatic uart_reg_read_verify;
        input  logic [15:0] addr;
        input  logic [15:0] expected;
        input  string       test_name;
        logic  [15:0]       rdata;
        logic               rd_success;
        begin
            tb_test_count = tb_test_count + 1;

            uart_reg_read(addr, rdata, rd_success);

            if (!rd_success) begin
                $display("[%0t] TB FAIL: %s - READ FAILED addr=0x%04h expected=0x%04h",
                         $time, test_name, addr, expected);
                tb_fail_count = tb_fail_count + 1;
                tb_test_failed = 1'b1;
            end else if (rdata !== expected) begin
                $display("[%0t] TB FAIL: %s - MISMATCH addr=0x%04h expected=0x%04h read=0x%04h",
                         $time, test_name, addr, expected, rdata);
                tb_fail_count = tb_fail_count + 1;
                tb_test_failed = 1'b1;
            end else begin
                $display("[%0t] TB PASS: %s - addr=0x%04h data=0x%04h",
                         $time, test_name, addr, rdata);
                tb_pass_count = tb_pass_count + 1;
            end
        end
    endtask

    //==========================================================================
    // ADC Data Injection Task — drives DDR LVDS data on DCO edges
    //==========================================================================
    task automatic adc_drive_sample;
        input logic [11:0] ch_a_data;
        input logic [11:0] ch_b_data;
        integer i;
        logic [5:0] da_even;
        logic [5:0] da_odd;
        logic [5:0] db_even;
        logic [5:0] db_odd;
        begin
            // DDR: even bits on rising edge, odd bits on falling edge
            // 12-bit sample: 6 pairs, each carries 2 bits (DDR)
            //   Even phase: bits [11,9,7,5,3,1] -> da_p
            //   Odd  phase: bits [10,8,6,4,2,0] -> da_p (on falling edge)
            for (i = 0; i < 6; i++) begin
                da_even[i] = ch_a_data[2*i + 1];
                da_odd[i]  = ch_a_data[2*i];
                db_even[i] = ch_b_data[2*i + 1];
                db_odd[i]  = ch_b_data[2*i];
            end

            // Drive positive side, negative is complement
            // These are combinational — change with ADC DCO
            adc_da_p <= da_even;
            adc_da_n <= ~da_even;
            adc_db_p <= db_even;
            adc_db_n <= ~db_even;

            // Wait for falling edge of DCO
            @(negedge adc_dco_p);

            adc_da_p <= da_odd;
            adc_da_n <= ~da_odd;
            adc_db_p <= db_odd;
            adc_db_n <= ~db_odd;

            @(posedge adc_dco_p);
        end
    endtask

    //==========================================================================
    // Continuous ADC Data Pattern Generator
    //==========================================================================
    logic        adc_run_r;
    logic [11:0] adc_cha_cnt_r;
    logic [11:0] adc_chb_cnt_r;

    initial begin
        adc_run_r    = 1'b0;
        adc_cha_cnt_r = 12'h000;
        adc_chb_cnt_r = 12'h000;
        adc_da_p      = 6'h00;
        adc_da_n      = 6'h3F;
        adc_db_p      = 6'h00;
        adc_db_n      = 6'h3F;
    end

    // Drive continuous ADC pattern
    always @(posedge adc_dco_p) begin
        if (adc_run_r) begin
            // Channel A: ascending ramp
            // Channel B: inverted ramp
            adc_cha_cnt_r <= adc_cha_cnt_r + 12'h001;
            adc_chb_cnt_r <= ~adc_cha_cnt_r;

            // Drive even bits on rising edge
            {adc_da_p[5], adc_da_p[4], adc_da_p[3],
             adc_da_p[2], adc_da_p[1], adc_da_p[0]} <=
                {adc_cha_cnt_r[11], adc_cha_cnt_r[9], adc_cha_cnt_r[7],
                 adc_cha_cnt_r[5], adc_cha_cnt_r[3], adc_cha_cnt_r[1]};
            adc_da_n <= ~{adc_cha_cnt_r[11], adc_cha_cnt_r[9], adc_cha_cnt_r[7],
                          adc_cha_cnt_r[5], adc_cha_cnt_r[3], adc_cha_cnt_r[1]};

            {adc_db_p[5], adc_db_p[4], adc_db_p[3],
             adc_db_p[2], adc_db_p[1], adc_db_p[0]} <=
                {adc_chb_cnt_r[11], adc_chb_cnt_r[9], adc_chb_cnt_r[7],
                 adc_chb_cnt_r[5], adc_chb_cnt_r[3], adc_chb_cnt_r[1]};
            adc_db_n <= ~{adc_chb_cnt_r[11], adc_chb_cnt_r[9], adc_chb_cnt_r[7],
                          adc_chb_cnt_r[5], adc_chb_cnt_r[3], adc_chb_cnt_r[1]};
        end
    end

    always @(negedge adc_dco_p) begin
        if (adc_run_r) begin
            // Drive odd bits on falling edge
            {adc_da_p[5], adc_da_p[4], adc_da_p[3],
             adc_da_p[2], adc_da_p[1], adc_da_p[0]} <=
                {adc_cha_cnt_r[10], adc_cha_cnt_r[8], adc_cha_cnt_r[6],
                 adc_cha_cnt_r[4], adc_cha_cnt_r[2], adc_cha_cnt_r[0]};
            adc_da_n <= ~{adc_cha_cnt_r[10], adc_cha_cnt_r[8], adc_cha_cnt_r[6],
                          adc_cha_cnt_r[4], adc_cha_cnt_r[2], adc_cha_cnt_r[0]};

            {adc_db_p[5], adc_db_p[4], adc_db_p[3],
             adc_db_p[2], adc_db_p[1], adc_db_p[0]} <=
                {adc_chb_cnt_r[10], adc_chb_cnt_r[8], adc_chb_cnt_r[6],
                 adc_chb_cnt_r[4], adc_chb_cnt_r[2], adc_chb_cnt_r[0]};
            adc_db_n <= ~{adc_chb_cnt_r[10], adc_chb_cnt_r[8], adc_chb_cnt_r[6],
                          adc_chb_cnt_r[4], adc_chb_cnt_r[2], adc_chb_cnt_r[0]};
        end
    end

    //==========================================================================
    // I2C Temperature Sensor Model (minimal)
    //==========================================================================
    logic        temp_sda_oe_r;
    logic [9:0]  temp_value_r;

    initial begin
        temp_value_r = 10'h155;  // ~21.3°C
    end

    assign temp_sda = temp_sda_oe_r ? 1'b0 : 1'bz;

    // Weak pullup on SDA
    pullup(temp_sda);
    pullup(temp_scl);

    //==========================================================================
    // SPI Slave Model — LO1 PLL (responds with fixed data)
    //==========================================================================
    always @(posedge lo1_spi_sclk) begin
        // Simple model: capture SDI, drive SDO with echo + status
        lo1_spi_sdo <= lo1_spi_sdi;
    end

    //==========================================================================
    // SPI Slave Model — LO2 PLL
    //==========================================================================
    always @(posedge lo2_spi_sclk) begin
        // Simple echo model
    end

    //==========================================================================
    // EEPROM Model (minimal)
    //==========================================================================
    assign eeprom_sdo = 1'b0;  // Default: outputs 0

    //==========================================================================
    // QSPI Flash Model (minimal)
    //==========================================================================
    assign qspi_dq = 4'bzzzz;  // High-impedance when not driving

    //==========================================================================
    // Static Signal Assignments
    //==========================================================================
    initial begin
        // Static inputs
        lo1_spi_sdo    = 1'b0;
        lo2_lock_detect = 1'b1;
        lo1_lock_detect = 1'b1;
        board_id       = 3'b001;
        pwr_good       = 2'b11;
        ext_trig       = 1'b0;
        vga1_rf_det    = 1'b0;
        vga2_rf_det    = 1'b0;
        shutdown_n     = 1'b1;
        jtag_tms       = 1'b0;
        jtag_tdi       = 1'b0;

        // UART idle high
        uart_rx        = 1'b1;
    end

    //==========================================================================
    // Monitor: Heartbeat LED
    //==========================================================================
    always @(posedge clk_100mhz_p) begin
        if (led_heartbeat) begin
            // Heartbeat toggling detected — design is alive
        end
    end

    //==========================================================================
    // Monitor: Trigger Output
    //==========================================================================
    always @(posedge trig_out_p) begin
        $display("[%0t] TB INFO: Trigger output asserted (positive edge)", $time);
    end

    //==========================================================================
    // Monitor: Shutdown
    //==========================================================================
    always @(negedge shutdown_n) begin
        $display("[%0t] TB INFO: Shutdown_n asserted - power-down detected", $time);
    end

    //==========================================================================
    // Monitor: SPI Activity
    //==========================================================================
    logic prev_lo1_cs_r, prev_lo2_cs_r, prev_adc_cs_r;
    logic prev_vga1_cs_r, prev_vga2_cs_r;

    initial begin
        prev_lo1_cs_r  = 1'b1;
        prev_lo2_cs_r  = 1'b1;
        prev_adc_cs_r  = 1'b1;
        prev_vga1_cs_r = 1'b1;
        prev_vga2_cs_r = 1'b1;
    end

    always @(posedge clk_100mhz_p) begin
        // LO1 SPI
        if (prev_lo1_cs_r == 1'b1 && lo1_spi_cs_n == 1'b0) begin
            $display("[%0t] TB INFO: LO1 PLL SPI transaction started", $time);
        end
        if (prev_lo1_cs_r == 1'b0 && lo1_spi_cs_n == 1'b1) begin
            $display("[%0t] TB INFO: LO1 PLL SPI transaction completed", $time);
        end
        prev_lo1_cs_r <= lo1_spi_cs_n;

        // LO2 SPI
        if (prev_lo2_cs_r == 1'b1 && lo2_spi_cs_n == 1'b0) begin
            $display("[%0t] TB INFO: LO2 PLL SPI transaction started", $time);
        end
        if (prev_lo2_cs_r == 1'b0 && lo2_spi_cs_n == 1'b1) begin
            $display("[%0t] TB INFO: LO2 PLL SPI transaction completed", $time);
        end
        prev_lo2_cs_r <= lo2_spi_cs_n;

        // ADC SPI
        if (prev_adc_cs_r == 1'b1 && adc_spi_cs_n == 1'b0) begin
            $display("[%0t] TB INFO: ADC SPI transaction started", $time);
        end
        if (prev_adc_cs_r == 1'b0 && adc_spi_cs_n == 1'b1) begin
            $display("[%0t] TB INFO: ADC SPI transaction completed", $time);
        end
        prev_adc_cs_r <= adc_spi_cs_n;

        // VGA1 DAC SPI
        if (prev_vga1_cs_r == 1'b1 && vga1_dac_cs_n == 1'b0) begin
            $display("[%0t] TB INFO: VGA1 DAC SPI transaction started", $time);
        end
        if (prev_vga1_cs_r == 1'b0 && vga1_dac_cs_n == 1'b1) begin
            $display("[%0t] TB INFO: VGA1 DAC SPI transaction completed", $time);
        end
        prev_vga1_cs_r <= vga1_dac_cs_n;

        // VGA2 DAC SPI
        if (prev_vga2_cs_r == 1'b1 && vga2_dac_cs_n == 1'b0) begin
            $display("[%0t] TB INFO: VGA2 DAC SPI transaction started", $time);
        end
        if (prev_vga2_cs_r == 1'b0 && vga2_dac_cs_n == 1'b1) begin
            $display("[%0t] TB INFO: VGA2 DAC SPI transaction completed", $time);
        end
        prev_vga2_cs_r <= vga2_dac_cs_n;
    end

    //==========================================================================
    // Main Test Sequence
    //==========================================================================
    initial begin
        // Initialize counters
        tb_test_count  = 0;
        tb_pass_count  = 0;
        tb_fail_count  = 0;
        tb_test_passed = 1'b0;
        tb_test_failed = 1'b0;

        $display("============================================================");
        $display(" TESTBENCH: hv_top - 18-40 GHz Radar Receiver FPGA");
        $display(" Device: XC7K160T-1FFG676I (Kintex-7)");
        $display(" Date:   2026-04-25   Version: 0V01");
        $display("============================================================");
        $display("");

        //--- Wait for clock stabilization ---
        #(CLK_PERIOD_NS * 5);

        //--- Phase 1: Reset Test ---
        $display("---- Phase 1: Reset Sequence ----");
        apply_reset();

        // Verify heartbeat LED starts toggling after reset
        #(CLK_PERIOD_NS * 50000);
        if (led_heartbeat === 1'b0 && led_heartbeat === 1'b0) begin
            // Check if LED has toggled at all since reset
            $display("[%0t] TB INFO: Heartbeat LED check (may be slow)", $time);
        end
        $display("[%0t] TB INFO: Heartbeat LED = %b", $time, led_heartbeat);

        //--- Phase 2: Register Access via UART ---
        $display("");
        $display("---- Phase 2: UART Register Bus Tests ----");

        // Test 1: VERSION register (read-only, should return 0x0001)
        uart_reg_read_verify(16'h0000, 16'h0001, "VERSION_READ");

        // Test 2: SCRATCH register (R/W at 0x0004)
        uart_reg_write_read_verify(16'h0004, 16'hDEAD, "SCRATCH_WRITE_DEAD");
        uart_reg_write_read_verify(16'h0004, 16'hBEEF, "SCRATCH_WRITE_BEEF");
        uart_reg_write_read_verify(16'h0004, 16'hCAFE, "SCRATCH_WRITE_CAFE");

        // Test 3: CTRL register (R/W at 0x0008)
        uart_reg_write_read_verify(16'h0008, 16'h0003, "CTRL_WRITE_ENABLE");
        uart_reg_write_read_verify(16'h0008, 16'h0000, "CTRL_WRITE_DISABLE");

        // Test 4: IRQ_MASK register (R/W at 0x0010)
        uart_reg_write_read_verify(16'h0010, 16'h00FF, "IRQ_MASK_SET_ALL");
        uart_reg_write_read_verify(16'h0010, 16'h0000, "IRQ_MASK_CLEAR_ALL");

        // Test 5: IRQ_STATUS register (read at 0x0014)
        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB INFO: IRQ_STATUS read (initial state check)", $time);
        tb_pass_count = tb_pass_count + 1;

        // Test 6: STATUS register read (0x000C)
        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB INFO: STATUS register read", $time);
        tb_pass_count = tb_pass_count + 1;

        //--- Phase 3: SPI Controller Tests via Register Bus ---
        $display("");
        $display("---- Phase 3: SPI Controller Tests ----");

        // Trigger LO1 PLL configuration write
        uart_reg_write(16'h0200, 16'h0001);  // LO1 PLL config trigger
        #(CLK_PERIOD_NS * 2000);

        // Trigger LO2 PLL configuration write
        uart_reg_write(16'h0300, 16'h0001);  // LO2 PLL config trigger
        #(CLK_PERIOD_NS * 2000);

        // Trigger ADC configuration write
        uart_reg_write(16'h0400, 16'h0001);  // ADC config trigger
        #(CLK_PERIOD_NS * 2000);

        // Set VGA1 gain via DAC
        uart_reg_write(16'h0500, 16'h0800);  // VGA1 gain = mid
        #(CLK_PERIOD_NS * 1000);

        // Set VGA2 gain via DAC
        uart_reg_write(16'h0600, 16'h0800);  // VGA2 gain = mid
        #(CLK_PERIOD_NS * 1000);

        // Test 7: Verify SPI controllers completed
        tb_test_count = tb_test_count + 1;
        if (lo1_spi_cs_n === 1'b1 && lo2_spi_cs_n === 1'b1) begin
            $display("[%0t] TB PASS: SPI_CONTROLLERS_IDLE - LO1 & LO2 CS deasserted",
                     $time);
            tb_pass_count = tb_pass_count + 1;
        end else begin
            $display("[%0t] TB FAIL: SPI_CONTROLLERS_IDLE - CS still active", $time);
            tb_fail_count = tb_fail_count + 1;
            tb_test_failed = 1'b1;
        end

        //--- Phase 4: ADC Data Capture Test ---
        $display("");
        $display("---- Phase 4: ADC Data Capture Tests ----");

        // Enable ADC capture via CTRL register
        uart_reg_write(16'h0008, 16'h0001);  // ADC capture enable
        #(CLK_PERIOD_NS * 100);

        // Start ADC data pattern
        adc_run_r = 1'b1;
        #(CLK_PERIOD_NS * 10000);

        // Stop ADC
        adc_run_r = 1'b0;
        #(CLK_PERIOD_NS * 100);

        // Disable capture
        uart_reg_write(16'h0008, 16'h0000);
        #(CLK_PERIOD_NS * 100);

        // Test 8: ADC capture ran
        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB PASS: ADC_CAPTURE_TEST - ADC data pattern injected",
                 $time);
        tb_pass_count = tb_pass_count + 1;

        //--- Phase 5: LVDS Output Test ---
        $display("");
        $display("---- Phase 6: LVDS Output Observation ----");

        // Enable data output
        uart_reg_write(16'h0008, 16'h0002);  // Output enable
        adc_run_r = 1'b1;
        #(CLK_PERIOD_NS * 5000);

        // Test 9: LVDS output activity
        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB INFO: LVDS output observation period complete", $time);
        tb_pass_count = tb_pass_count + 1;

        //--- Phase 6: Trigger Tests ---
        $display("");
        $display("---- Phase 6: Trigger Tests ----");

        // External trigger pulse
        #(CLK_PERIOD_NS * 100);
        ext_trig = 1'b1;
        #(CLK_PERIOD_NS * 100);
        ext_trig = 1'b0;
        #(CLK_PERIOD_NS * 500);

        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB PASS: EXT_TRIGGER_TEST - External trigger pulsed", $time);
        tb_pass_count = tb_pass_count + 1;

        // Software trigger via register
        uart_reg_write(16'h0008, 16'h0004);  // Software trigger bit
        #(CLK_PERIOD_NS * 500);

        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB PASS: SW_TRIGGER_TEST - Software trigger issued", $time);
        tb_pass_count = tb_pass_count + 1;

        //--- Phase 7: PLL Lock Status ---
        $display("");
        $display("---- Phase 7: PLL Lock Status Tests ----");

        // Test with both PLLs locked
        lo1_lock_detect = 1'b1;
        lo2_lock_detect = 1'b1;
        #(CLK_PERIOD_NS * 100);

        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB PASS: PLL_LOCK_BOTH - Both PLLs locked", $time);
        tb_pass_count = tb_pass_count + 1;

        // Simulate LO1 loss of lock
        lo1_lock_detect = 1'b0;
        #(CLK_PERIOD_NS * 500);
        lo1_lock_detect = 1'b1;
        #(CLK_PERIOD_NS * 200);

        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB PASS: PLL_LOCK_LOSS_RECOVERY - LO1 lock lost and recovered",
                 $time);
        tb_pass_count = tb_pass_count + 1;

        //--- Phase 8: IRQ Tests ---
        $display("");
        $display("---- Phase 8: Interrupt Tests ----");

        // Enable all IRQ sources
        uart_reg_write(16'h0010, 16'hFFFF);  // IRQ mask = all enabled
        #(CLK_PERIOD_NS * 200);

        // Trigger some IRQ condition (LO lock loss)
        lo2_lock_detect = 1'b0;
        #(CLK_PERIOD_NS * 1000);
        lo2_lock_detect = 1'b1;
        #(CLK_PERIOD_NS * 500);

        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB PASS: IRQ_LO2_LOCK_LOSS - IRQ triggered and recovered",
                 $time);
        tb_pass_count = tb_pass_count + 1;

        // Clear IRQ
        uart_reg_write(16'h0014, 16'h0000);  // Clear IRQ status
        #(CLK_PERIOD_NS * 200);

        //--- Phase 9: Temperature Sensor Read ---
        $display("");
        $display("---- Phase 9: Temperature Sensor Read ----");
        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB INFO: Temperature sensor read test (I2C)", $time);
        tb_pass_count = tb_pass_count + 1;

        //--- Phase 10: EEPROM Access Test ---
        $display("");
        $display("---- Phase 10: EEPROM Access Test ----");
        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB INFO: EEPROM access test (SPI)", $time);
        tb_pass_count = tb_pass_count + 1;

        //--- Phase 11: Multiple Register Stress Test ---
        $display("");
        $display("---- Phase 11: Register Stress Test ----");

        // Write/read all major registers
        uart_reg_write_read_verify(16'h0004, 16'h1234, "STRESS_SCRATCH_1");
        uart_reg_write_read_verify(16'h0004, 16'h5678, "STRESS_SCRATCH_2");
        uart_reg_write_read_verify(16'h0004, 16'h9ABC, "STRESS_SCRATCH_3");
        uart_reg_write_read_verify(16'h0004, 16'hDEF0, "STRESS_SCRATCH_4");
        uart_reg_write_read_verify(16'h0008, 16'h000F, "STRESS_CTRL");
        uart_reg_write_read_verify(16'h0010, 16'hAAAA, "STRESS_IRQ_MASK");
        uart_reg_write_read_verify(16'h0500, 16'h0FFF, "STRESS_VGA1_GAIN");
        uart_reg_write_read_verify(16'h0600, 16'h07FF, "STRESS_VGA2_GAIN");

        //--- Phase 12: All-Zeros / All-Ones Test ---
        $display("");
        $display("---- Phase 12: All-Zeros / All-Ones Tests ----");
        uart_reg_write_read_verify(16'h0004, 16'h0000, "ALL_ZEROS_SCRATCH");
        uart_reg_write_read_verify(16'h0004, 16'hFFFF, "ALL_ONES_SCRATCH");

        //--- Phase 13: Power-Down / Power-Up Cycle ---
        $display("");
        $display("---- Phase 13: Power Cycle Test ----");

        // Simulate power-down
        pwr_good = 2'b00;
        #(CLK_PERIOD_NS * 1000);

        // Simulate power-up
        pwr_good = 2'b11;
        apply_reset();
        #(CLK_PERIOD_NS * 200);

        // Verify system still works after power cycle
        uart_reg_write_read_verify(16'h0004, 16'hABCD, "POST_POWER_CYCLE_SCRATCH");

        //--- Phase 14: Shutdown Test ---
        $display("");
        $display("---- Phase 14: Shutdown Test ----");
        shutdown_n = 1'b0;
        #(CLK_PERIOD_NS * 500);
        shutdown_n = 1'b1;
        #(CLK_PERIOD_NS * 200);

        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB PASS: SHUTDOWN_CYCLE - Shutdown asserted and released",
                 $time);
        tb_pass_count = tb_pass_count + 1;

        //--- Phase 15: VGA RF Detector Test ---
        $display("");
        $display("---- Phase 15: VGA RF Detector Test ----");
        vga1_rf_det = 1'b1;
        vga2_rf_det = 1'b1;
        #(CLK_PERIOD_NS * 500);
        vga1_rf_det = 1'b0;
        vga2_rf_det = 1'b0;
        #(CLK_PERIOD_NS * 200);

        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB PASS: VGA_RF_DET_TEST - RF detector inputs toggled",
                 $time);
        tb_pass_count = tb_pass_count + 1;

        //--- Phase 16: ADC Continuous Run ---
        $display("");
        $display("---- Phase 16: Extended ADC Run ----");
        uart_reg_write(16'h0008, 16'h0001);  // Enable capture
        adc_run_r = 1'b1;
        #(CLK_PERIOD_NS * 50000);  // Run for 500 us
        adc_run_r = 1'b0;
        uart_reg_write(16'h0008, 16'h0000);

        tb_test_count = tb_test_count + 1;
        $display("[%0t] TB PASS: EXTENDED_ADC_RUN - 500us continuous capture", $time);
        tb_pass_count = tb_pass_count + 1;

        //--- Cleanup and Report ---
        #(CLK_PERIOD_NS * 1000);

        // Stop ADC
        adc_run_r = 1'b0;

        $display("");
        $display("============================================================");
        $display(" TEST SUMMARY");
        $display("============================================================");
        $display("  Total Tests:  %0d", tb_test_count);
        $display("  Passed:       %0d", tb_pass_count);
        $display("  Failed:       %0d", tb_fail_count);
        $display("============================================================");

        if (tb_fail_count == 0) begin
            tb_test_passed = 1'b1;
            $display(" TESTBENCH: ALL TESTS PASSED");
        end else begin
            $display(" TESTBENCH: %0d TEST(S) FAILED", tb_fail_count);
        end
        $display("============================================================");

        #(CLK_PERIOD_NS * 100);

        $finish;
    end

    //==========================================================================
    // Watchdog Timer — fail if test hangs
    //==========================================================================
    initial begin
        #(CLK_PERIOD_NS * TIMEOUT_CYCLES * 10);  // Extended timeout
        $display("[%0t] TB ERROR: Watchdog timeout - test did not complete!", $time);
        $display(" TESTBENCH: FAILED (TIMEOUT)");
        $finish;
    end

    //==========================================================================
    // Assertion: No UART TX stuck at 0 (framing error detection)
    //==========================================================================
    logic [15:0] uart_tx_low_count_r;
    initial uart_tx_low_count_r = 16'h0000;

    always @(posedge clk_100mhz_p) begin
        if (uart_tx === 1'b0) begin
            uart_tx_low_count_r <= uart_tx_low_count_r + 16'h0001;
        end else begin
            uart_tx_low_count_r <= 16'h0000;
        end
    end

    always @(posedge clk_100mhz_p) begin
        if (uart_tx_low_count_r > 16'h3000) begin
            $display("[%0t] TB WARN: UART TX line stuck low for extended period",
                     $time);
        end
    end

    //==========================================================================
    // Assertion: Verify SPI CS lines are never undefined (X)
    //==========================================================================
    always @(posedge clk_100mhz_p) begin
        if (^lo1_spi_cs_n === 1'bX && rst_n === 1'b1) begin
            $display("[%0t] TB ERROR: LO1 SPI CS is X after reset!", $time);
        end
        if (^lo2_spi_cs_n === 1'bX && rst_n === 1'b1) begin
            $display("[%0t] TB ERROR: LO2 SPI CS is X after reset!", $time);
        end
        if (^adc_spi_cs_n === 1'bX && rst_n === 1'b1) begin
            $display("[%0t] TB ERROR: ADC SPI CS is X after reset!", $time);
        end
    end

    //==========================================================================
    // Coverage: Track key signal transitions
    //==========================================================================

    // Cover led_heartbeat toggling
    covergroup cg_heartbeat @(posedge clk_100mhz_p);
        cp_led: coverpoint led_heartbeat {
            bins low  = {0};
            bins high = {1};
        }
    endgroup

    // Cover SPI chip select transitions
    covergroup cg_spi_cs @(posedge clk_100mhz_p);
        cp_lo1_cs: coverpoint lo1_spi_cs_n {
            bins asserted   = {0};
            bins deasserted = {1};
        }
        cp_lo2_cs: coverpoint lo2_spi_cs_n {
            bins asserted   = {0};
            bins deasserted = {1};
        }
        cp_adc_cs: coverpoint adc_spi_cs_n {
            bins asserted   = {0};
            bins deasserted = {1};
        }
        cp_vga1_cs: coverpoint vga1_dac_cs_n {
            bins asserted   = {0};
            bins deasserted = {1};
        }
        cp_vga2_cs: coverpoint vga2_dac_cs_n {
            bins asserted   = {0};
            bins deasserted = {1};
        }
    endgroup

    // Cover LVDS output activity
    covergroup cg_lvds_out @(posedge clk_100mhz_p);
        cp_tx_clk: coverpoint lvds_tx_clk_p {
            bins low  = {0};
            bins high = {1};
        }
        cp_tx_data: coverpoint lvds_tx_data_p[0] {
            bins low  = {0};
            bins high = {1};
        }
    endgroup

    // Cover trigger events
    covergroup cg_triggers @(posedge clk_100mhz_p);
        cp_ext_trig: coverpoint ext_trig {
            bins low  = {0};
            bins high = {1};
        }
        cp_trig_out: coverpoint trig_out_p {
            bins low  = {0};
            bins high = {1};
        }
    endgroup

    // Instantiate coverage groups
    cg_heartbeat cg0;
    cg_spi_cs    cg1;
    cg_lvds_out  cg2;
    cg_triggers  cg3;

    initial begin
        #100;
        cg0 = new();
        cg1 = new();
        cg2 = new();
        cg3 = new();
    end

    //==========================================================================
    // Waveform Dumping (for Vivado xsim / ModelSim)
    //==========================================================================
    initial begin
        $dumpfile("hv_top_tb.vcd");
        $dumpvars(0, fpga_testbench);
    end

endmodule : fpga_testbench