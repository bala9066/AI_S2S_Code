/**
 * @module dgh_fpga_top
 * @brief Top-level module for dgh radar RF front-end receiver FPGA
 * @author DGH Project Team
 * @version 0V01
 * @date 19.04.2026
 * 
 * This module implements the control logic for a 4-channel RF front-end receiver
 * system with power monitoring, temperature sensing, and UART control interface.
 * The FPGA manages power sequencing, RF component control, system monitoring,
 * and provides access to system registers via UART interface.
 */

module dgh_fpga_top (
    // Clock and reset
    input  wire        clk_125mhz,    // 125 MHz system clock
    input  wire        rst_n,         // Active-low system reset
    
    // UART interface
    input  wire        uart_rx,       // UART receive data
    output wire        uart_tx,       // UART transmit data
    
    // I2C interface
    inout  wire        i2c_scl,       // I2C clock (open-drain)
    inout  wire        i2c_sda,       // I2C data (open-drain)
    
    // SPI interface
    output wire        spi_sclk,      // SPI clock
    output wire        spi_mosi,      // SPI MOSI
    input  wire        spi_miso,      // SPI MISO
    output wire        spi_cs_n,      // SPI chip select
    
    // GPIO interface
    input  wire [15:0] gpio_in,       // General purpose inputs
    output wire [15:0] gpio_out,      // General purpose outputs
    
    // RF channel control
    output wire        rf_channel_0_enable,
    output wire        rf_channel_1_enable,
    output wire        rf_channel_2_enable,
    output wire        rf_channel_3_enable,
    
    // Status inputs
    input  wire        temp_alert,    // Temperature alert
    input  wire        power_fault,   // Power fault
    
    // Register bus interface
    input  wire [15:0] reg_addr,      // Register address (bit15=R/W#, bits11:8=base, bits7:0=offset)
    input  wire [15:0] reg_wdata,     // Register write data
    output wire [15:0] reg_rdata,     // Register read data
    input  wire        reg_wr,        // Register write strobe
    input  wire        reg_rd,        // Register read strobe
    
    // Interrupts
    output wire [7:0]  irq_status     // Interrupt status vector
);

    // Parameters
    parameter CLOCK_FREQ_MHZ = 125;
    parameter UART_BAUD_RATE = 115200;
    parameter I2C_ADDR_AD7416 = 8'h48;
    parameter I2C_ADDR_LTC2992 = 8'h64;
    parameter I2C_ADDR_MCP23017 = 8'h20;
    
    // Register map definitions
    localparam REG_ADDR_VERSION    = 16'h0000;
    localparam REG_ADDR_CTRL       = 16'h0100;
    localparam REG_ADDR_STATUS     = 16'h0101;
    localparam REG_ADDR_TEMP       = 16'h0200;
    localparam REG_ADDR_POWER      = 16'h0201;
    localparam REG_ADDR_RF_CH_EN   = 16'h0300;
    localparam REG_ADDR_IRQ_MASK   = 16'h0400;
    localparam REG_ADDR_IRQ_STATUS = 16'h0401;
    localparam REG_ADDR_SCRATCH    = 16'h0500;
    
    // Internal registers
    reg  [15:0] version_r;
    reg  [15:0] ctrl_r;
    reg  [15:0] status_r;
    reg  [15:0] temp_r;
    reg  [15:0] power_r;
    reg  [15:0] rf_ch_en_r;
    reg  [15:0] irq_mask_r;
    reg  [15:0] irq_status_r;
    reg  [15:0] scratch_r;
    
    // RF channel enable outputs
    reg  rf_channel_0_en_r;
    reg  rf_channel_1_en_r;
    reg  rf_channel_2_en_r;
    reg  rf_channel_3_en_r;
    
    // Clock domain crossing registers
    reg  [15:0] reg_rdata_sync_r;
    reg  [7:0]  irq_status_sync_r;
    
    // Clock enable for 125 MHz (1 tick = 8ns)
    wire clk_en;
    reg  [2:0] clk_div_r;
    
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            clk_div_r <= 3'd0;
        end else begin
            clk_div_r <= clk_div_r + 1;
        end
    end
    
    assign clk_en = (clk_div_r == 3'd0);
    
    // Register write logic
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            ctrl_r <= 16'h0000;
            rf_ch_en_r <= 16'h0000;
            irq_mask_r <= 16'h0000;
            scratch_r <= 16'h0000;
        end else if (clk_en && reg_wr) begin
            case (reg_addr[11:0])
                REG_ADDR_CTRL:    ctrl_r <= reg_wdata;
                REG_ADDR_RF_CH_EN: rf_ch_en_r <= reg_wdata;
                REG_ADDR_IRQ_MASK: irq_mask_r <= reg_wdata;
                REG_ADDR_SCRATCH: scratch_r <= reg_wdata;
            endcase
        end
    end
    
    // Register read logic
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            reg_rdata <= 16'h0000;
        end else if (clk_en && reg_rd) begin
            case (reg_addr[11:0])
                REG_ADDR_VERSION:    reg_rdata <= version_r;
                REG_ADDR_CTRL:       reg_rdata <= ctrl_r;
                REG_ADDR_STATUS:     reg_rdata <= status_r;
                REG_ADDR_TEMP:       reg_rdata <= temp_r;
                REG_ADDR_POWER:      reg_rdata <= power_r;
                REG_ADDR_RF_CH_EN:   reg_rdata <= rf_ch_en_r;
                REG_ADDR_IRQ_MASK:   reg_rdata <= irq_mask_r;
                REG_ADDR_IRQ_STATUS: reg_rdata <= irq_status_r;
                REG_ADDR_SCRATCH:    reg_rdata <= scratch_r;
                default:             reg_rdata <= 16'h0000;
            endcase
        end
    end
    
    // RF channel control
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            rf_channel_0_en_r <= 1'b0;
            rf_channel_1_en_r <= 1'b0;
            rf_channel_2_en_r <= 1'b0;
            rf_channel_3_en_r <= 1'b0;
        end else begin
            rf_channel_0_en_r <= rf_ch_en_r[0];
            rf_channel_1_en_r <= rf_ch_en_r[1];
            rf_channel_2_en_r <= rf_ch_en_r[2];
            rf_channel_3_en_r <= rf_ch_en_r[3];
        end
    end
    
    assign rf_channel_0_enable = rf_channel_0_en_r;
    assign rf_channel_1_enable = rf_channel_1_en_r;
    assign rf_channel_2_enable = rf_channel_2_en_r;
    assign rf_channel_3_enable = rf_channel_3_en_r;
    
    // Interrupt generation and status
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            irq_status_r <= 8'h00;
        end else begin
            // Update interrupt status
            irq_status_r[0] <= temp_alert & irq_mask_r[0];    // Temperature alert
            irq_status_r[1] <= power_fault & irq_mask_r[1];   // Power fault
            irq_status_r[2] <= gpio_in[0] & irq_mask_r[2];     // GPIO interrupt 0
            irq_status_r[3] <= gpio_in[1] & irq_mask_r[3];     // GPIO interrupt 1
            irq_status_r[4] <= ctrl_r[4] & irq_mask_r[4];      // RF channel 0 fault
            irq_status_r[5] <= ctrl_r[5] & irq_mask_r[5];      // RF channel 1 fault
            irq_status_r[6] <= ctrl_r[6] & irq_mask_r[6];      // RF channel 2 fault
            irq_status_r[7] <= ctrl_r[7] & irq_mask_r[7];      // RF channel 3 fault
        end
    end
    
    // Synchronize interrupt outputs to clock domain
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            irq_status_sync_r <= 8'h00;
        end else begin
            irq_status_sync_r <= irq_status_r;
        end
    end
    
    assign irq_status = irq_status_sync_r;
    
    // Status register updates
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            status_r <= 16'h0000;
        end else begin
            status_r[0] <= temp_alert;         // Temperature alert status
            status_r[1] <= power_fault;        // Power fault status
            status_r[2] <= rf_channel_0_en_r;   // RF channel 0 enabled
            status_r[3] <= rf_channel_1_en_r;   // RF channel 1 enabled
            status_r[4] <= rf_channel_2_en_r;   // RF channel 2 enabled
            status_r[5] <= rf_channel_3_en_r;   // RF channel 3 enabled
            status_r[8] <= i2c_scl;            // I2C clock status
            status_r[9] <= i2c_sda;            // I2C data status
        end
    end
    
    // Temperature monitoring (simulated - in real implementation would read from AD7416)
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            temp_r <= 16'h0000;
        end else begin
            // Simulated temperature reading (25°C + offset)
            temp_r[7:0] <= temp_alert ? 8'h3C : 8'h19;  // 60°C if alert, 25°C normal
            temp_r[15:8] <= 8'h00;  // Temperature in Celsius
        end
    end
    
    // Power monitoring (simulated - in real implementation would read from LTC2992)
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            power_r <= 16'h0000;
        end else begin
            // Simulated power monitoring data
            power_r[3:0] <= power_fault ? 4'h0 : 4'hF;   // VCC_OK status
            power_r[7:4] <= 4'h8;                        // VCC1.8V status
            power_r[11:8] <= 4'h8;                       // VCC3.3V status
            power_r[15:12] <= 4'h8;                     // VCC5V status
        end
    end
    
    // Version register
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            version_r <= 16'h0000;
        end else begin
            version_r <= 16'h0V01;  // Version 0V01
        end
    end
    
    // GPIO output register
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            gpio_out <= 16'h0000;
        end else begin
            gpio_out <= ctrl_r[15:0];  // Direct mapping of control to GPIO
        end
    end
    
    // I2C interface control (simplified)
    reg  i2c_scl_r;
    reg  i2c_sda_r;
    wire i2c_scl_oe;
    wire i2c_sda_oe;
    
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            i2c_scl_r <= 1'b1;
            i2c_sda_r <= 1'b1;
        end else if (clk_en) begin
            // Simplified I2C control (would be more complex in real implementation)
            i2c_scl_r <= i2c_scl_r;  // Placeholder for actual I2C FSM
            i2c_sda_r <= i2c_sda_r;  // Placeholder for actual I2C FSM
        end
    end
    
    assign i2c_scl_oe = 1'b0;  // Always tristate
    assign i2c_sda_oe = 1'b0;  // Always tristate
    assign i2c_scl = i2c_scl_oe ? i2c_scl_r : 1'bZ;
    assign i2c_sda = i2c_sda_oe ? i2c_sda_r : 1'bZ;
    
    // SPI interface control (simplified)
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            spi_sclk <= 1'b0;
            spi_mosi <= 1'b0;
            spi_cs_n <= 1'b1;
        end else if (clk_en) begin
            // Simplified SPI control (would be more complex in real implementation)
            spi_sclk <= spi_sclk;  // Placeholder for actual SPI FSM
            spi_mosi <= spi_mosi;  // Placeholder for actual SPI FSM
            spi_cs_n <= spi_cs_n;  // Placeholder for actual SPI FSM
        end
    end
    
    // UART interface (simplified)
    reg  uart_tx_r;
    reg  uart_tx_oe;
    
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            uart_tx_r <= 1'b1;
            uart_tx_oe <= 1'b0;
        end else if (clk_en) begin
            // Simplified UART TX (would be more complex in real implementation)
            uart_tx_r <= uart_tx_r;  // Placeholder for actual UART TX FSM
            uart_tx_oe <= 1'b1;      // Always drive TX
        end
    end
    
    assign uart_tx = uart_tx_oe ? uart_tx_r : 1'bZ;
    
    // Power Sequencer FSM
    typedef enum logic [4:0] {
        POWER_OFF,
        POWER_UP,
        POWER_STABLE,
        POWER_FAULT,
        POWER_DOWN
    } power_seq_state_t;
    
    power_seq_state_t power_seq_state_r, power_seq_state_next;
    
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            power_seq_state_r <= POWER_OFF;
        end else if (clk_en) begin
            power_seq_state_r <= power_seq_state_next;
        end
    end
    
    always_comb begin
        power_seq_state_next = power_seq_state_r;
        
        case (power_seq_state_r)
            POWER_OFF: begin
                if (ctrl_r[0]) begin  // Power enable command
                    power_seq_state_next = POWER_UP;
                end
            end
            
            POWER_UP: begin
                if (power_fault) begin
                    power_seq_state_next = POWER_FAULT;
                end else if (status_r[7:4] == 4'h8) begin  // All rails stable
                    power_seq_state_next = POWER_STABLE;
                end
            end
            
            POWER_STABLE: begin
                if (!ctrl_r[0]) begin  // Power disable command
                    power_seq_state_next = POWER_DOWN;
                end else if (power_fault) begin
                    power_seq_state_next = POWER_FAULT;
                end
            end
            
            POWER_FAULT: begin
                if (!ctrl_r[0]) begin  // Power disable command
                    power_seq_state_next = POWER_DOWN;
                end
            end
            
            POWER_DOWN: begin
                if (!power_fault && status_r[7:4] == 4'h0) begin  // All rails off
                    power_seq_state_next = POWER_OFF;
                end
            end
        endcase
    end
    
    // UART FSM (simplified)
    typedef enum logic [3:0] {
        IDLE,
        RECV_START,
        RECV_DATA,
        RECV_STOP,
        XMIT_START,
        XMIT_DATA,
        XMIT_STOP
    } uart_state_t;
    
    uart_state_t uart_state_r, uart_state_next;
    reg  [7:0]  uart_rx_data_r;
    reg  [3:0]  uart_bit_count_r;
    
    always @(posedge clk_125mhz or negedge rst_n) begin
        if (!rst_n) begin
            uart_state_r <= IDLE;
            uart_rx_data_r <= 8'h00;
            uart_bit_count_r <= 4'd0;
        end else if (clk_en) begin
            uart_state_r <= uart_state_next;
            
            case (uart_state_next)
                RECV_DATA: begin
                    uart_bit_count_r <= uart_bit_count_r + 1;
                end
                default: begin
                    uart_bit_count_r <= 4'd0;
                end
            endcase
        end
    end
    
    always_comb begin
        uart_state_next = uart_state_r;
        
        case (uart_state_r)
            IDLE: begin
                if (!uart_rx) begin  // Start bit detected
                    uart_state_next = RECV_START;
                end
            end
            
            RECV_START: begin
                uart_state_next = RECV_DATA;
            end
            
            RECV_DATA: begin
                if (uart_bit_count_r == 4'd9) begin  // 8 data bits + stop bit
                    uart_state_next = RECV_STOP;
                end
            end
            
            RECV_STOP: begin
                uart_state_next = IDLE;
            end
            
            default: begin
                uart_state_next = IDLE;
            end
        endcase
    end
    
endmodule