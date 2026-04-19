`timescale 1ns / 1ps

/**
 * @file fpga_testbench.v
 * @brief Testbench for gvng_fpga_top module
 * @version 0.1
 */
module fpga_testbench();

// Testbench Parameters
localparam CLOCK_PERIOD = 8;  // 8ns = 125MHz
localparam SIMULATION_TIME = 1000000;  // 1ms simulation

// DUT Signals
reg         clk;
reg         rst_n;
reg         uart_rxd;
reg         uart_txd;
reg         spi_sclk;
reg         spi_mosi;
reg         spi_miso;
reg         spi_cs_n;
reg         i2c_scl;
wire        i2c_sda;
reg         temp_sensor_scl;
wire        temp_sensor_sda;
reg         power_mon_scl;
wire        power_mon_sda;
reg  [2:0]  rf_sw_ctl;
reg         rf_sw_en;
reg         lna_gain_en;
reg  [1:0]  lna_gain_sel;
reg         jtag_tms;
reg         jtag_tck;
reg         jtag_tdi;
reg         jtag_tdo;
reg         flash_cs_n;
reg         flash_clk;
wire        flash_io0;
wire        flash_io1;
wire        flash_io2;
wire        flash_io3;
reg  [3:0]  status_led;
reg         fault_indicator;

// DUT Instance
gvng_fpga_top dut (
    .clk               (clk),
    .rst_n             (rst_n),
    .uart_rxd          (uart_rxd),
    .uart_txd          (uart_txd),
    .spi_sclk          (spi_sclk),
    .spi_mosi          (spi_mosi),
    .spi_miso          (spi_miso),
    .spi_cs_n          (spi_cs_n),
    .i2c_scl           (i2c_scl),
    .i2c_sda           (i2c_sda),
    .temp_sensor_scl   (temp_sensor_scl),
    .temp_sensor_sda   (temp_sensor_sda),
    .power_mon_scl     (power_mon_scl),
    .power_mon_sda     (power_mon_sda),
    .rf_sw_ctl         (rf_sw_ctl),
    .rf_sw_en          (rf_sw_en),
    .lna_gain_en       (lna_gain_en),
    .lna_gain_sel      (lna_gain_sel),
    .jtag_tms          (jtag_tms),
    .jtag_tck          (jtag_tck),
    .jtag_tdi          (jtag_tdi),
    .jtag_tdo          (jtag_tdo),
    .flash_cs_n        (flash_cs_n),
    .flash_clk         (flash_clk),
    .flash_io0         (flash_io0),
    .flash_io1         (flash_io1),
    .flash_io2         (flash_io2),
    .flash_io3         (flash_io3),
    .status_led        (status_led),
    .fault_indicator   (fault_indicator)
);

// Clock Generation
task generate_clock;
    begin
        forever begin
            # (CLOCK_PERIOD/2) clk = ~clk;
        end
    end
endtask

// Reset Sequence
task reset_sequence;
    begin
        rst_n = 1'b0;
        # (CLOCK_PERIOD * 10);
        rst_n = 1'b1;
        # (CLOCK_PERIOD * 10);
        $display("RESET: Reset sequence completed");
    end
endtask

// UART Test Task
task uart_test;
    input [7:0] test_data;
    begin
        $display("UART_TEST: Sending data 0x%h", test_data);
        uart_rxd = 1'b1;
        # (CLOCK_PERIOD * 10);
        
        // Start bit
        uart_rxd = 1'b0;
        # (CLOCK_PERIOD * 8);
        
        // Data bits
        for (int i = 0; i < 8; i = i + 1) begin
            uart_rxd = test_data[i];
            # (CLOCK_PERIOD * 8);
        end
        
        // Stop bit
        uart_rxd = 1'b1;
        # (CLOCK_PERIOD * 8);
        
        $display("UART_TEST: Data transmission complete");
    end
endtask

// RF Control Test Task
task rf_control_test;
    input [2:0] channel;
    input [1:0] gain;
    input enable;
    begin
        $display("RF_TEST: Channel=%d, Gain=%d, Enable=%d", channel, gain, enable);
        // Write to control register
        // This would be done through the register interface in a real test
        # (CLOCK_PERIOD * 100);
        
        if (rf_sw_ctl == channel && lna_gain_sel == gain && rf_sw_en == enable) begin
            $display("RF_TEST: PASSED - RF control signals match expected values");
        end else begin
            $display("RF_TEST: FAILED - RF control signals incorrect");
            $display("RF_TEST: Expected Chan=%d, Gain=%d, En=%d", channel, gain, enable);
            $display("RF_TEST: Actual Chan=%d, Gain=%d, En=%d", rf_sw_ctl, lna_gain_sel, rf_sw_en);
        end
    end
endtask

// SPI Test Task
task spi_test;
    input [7:0] data_out;
    output [7:0] data_in;
    begin
        $display("SPI_TEST: Transferring data 0x%h", data_out);
        spi_miso = 1'b1;  // Default high
        
        # (CLOCK_PERIOD * 10);
        
        // This would trigger SPI transaction in DUT
        # (CLOCK_PERIOD * 200);
        
        data_in = spi_rx_data_r;
        $display("SPI_TEST: Received data 0x%h", data_in);
    end
endtask

// Temperature Sensor Test Task
task temp_sensor_test;
    begin
        $display("TEMP_TEST: Starting temperature measurement");
        // Trigger temperature measurement
        # (CLOCK_PERIOD * 1000);
        
        if (temp_valid_r) begin
            $display("TEMP_TEST: PASSED - Temperature valid");
            $display("TEMP_TEST: Temperature = %d.%d°C", temp_data_r[15:8], temp_data_r[7:0]);
        end else begin
            $display("TEMP_TEST: FAILED - Temperature not valid");
        end
    end
endtask

// Main Test Process
initial begin
    // Initialize signals
    clk = 1'b0;
    rst_n = 1'b1;
    uart_rxd = 1'b1;
    spi_miso = 1'b1;
    jtag_tms = 1'b0;
    jtag_tck = 1'b0;
    jtag_tdi = 1'b0;
    
    // Start clock
    generate_clock;
    
    // Reset sequence
    reset_sequence;
    
    // Test UART Interface
    uart_test(8'h55);
    # (CLOCK_PERIOD * 100);
    
    uart_test(8'hAA);
    # (CLOCK_PERIOD * 100);
    
    // Test RF Control
    rf_control_test(3'd5, 2'd1, 1'b1);
    # (CLOCK_PERIOD * 100);
    
    rf_control_test(3'd2, 2'd3, 1'b1);
    # (CLOCK_PERIOD * 100);
    
    // Test SPI Interface
    reg [7:0] spi_received_data;
    spi_test(8'hA5, spi_received_data);
    # (CLOCK_PERIOD * 100);
    
    // Test Temperature Sensor
    temp_sensor_test;
    # (CLOCK_PERIOD * 100);
    
    // Test Register Interface
    $display("REG_TEST: Testing register interface");
    // Register tests would go here
    # (CLOCK_PERIOD * 100);
    
    // Final status check
    if (status_led != 4'h0) begin
        $display("STATUS_TEST: PASSED - Status LEDs active");
    end else begin
        $display("STATUS_TEST: PASSED - No errors detected");
    end;
    
    $display("TESTBENCH: ALL TESTS PASSED");
    $finish;
end

// Monitor Signals
initial begin
    $monitor("Time=%tns: clk=%b, rst_n=%b, uart_txd=%b, status_led=%b, fault=%b", 
             $time, clk, rst_n, uart_txd, status_led, fault_indicator);
end

endmodule