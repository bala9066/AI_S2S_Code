//============================================================================
// @file      fpga_top.v
// @brief     Top-level module for hjjg project — Dual-channel 2–6 GHz
//            double-IF superheterodyne radar receiver FPGA.
//
// @details   Implements the complete digital processing core on a Kintex-7
//            XC7K160T-1FBG676C FPGA (PFP-KX7_PLUS-310LC board). Includes:
//              • Dual-channel 14-bit LVDS ADC interfaces (AD9643 @ 170 MSPS)
//              • Digital Downconverter (DDC) with NCO and CIC/decimation
//              • UART register bus (115.2 kbps) for host control
//              • Dual SPI masters for PLL1 (LO1) and PLL2 (LO2) programming
//              • I2C master for telemetry (TMP116, ADM1177, 24AA025E48)
//              • Configuration flash SPI (AT25SL321)
//              • Dual FSMs: UART RX/TX protocol engine, SPI master sequencer
//              • 16-bit register access layer with IRQ support
//
// @author    FPGA Design Team — hjjg project
// @date      2026-04-25
// @version   0V01
// @copyright Copyright (c) 2026 hjjg project. All rights reserved.
//
// @note      Target: Xilinx Kintex-7 XC7K160T-1FBG676C
// @note      Clock:  170 MHz primary (from ADC clock buffer)
//============================================================================

`timescale 1ns / 1ps

module hjjg_top
(
    //---- Clock / Reset ---------------------------------------------------
    input  wire        clk_170_p,           //!< 170 MHz system clock (LVDS+)
    input  wire        clk_170_n,           //!< 170 MHz system clock (LVDS-)
    input  wire        clk_10_p,            //!< 10 MHz OCXO reference (LVDS+)
    input  wire        clk_10_n,            //!< 10 MHz OCXO reference (LVDS-)
    input  wire        rst_n,               //!< Active-low synchronous reset

    //---- UART Host Interface ---------------------------------------------
    input  wire        uart_rxd,            //!< UART RX from FTDI bridge
    output reg         uart_txd,            //!< UART TX to FTDI bridge

    //---- ADC Channel A (AD9643) ------------------------------------------
    input  wire [13:0] adc_cha_d_p,         //!< Ch-A ADC data (LVDS+)
    input  wire [13:0] adc_cha_d_n,         //!< Ch-A ADC data (LVDS-)
    input  wire        adc_cha_dco_p,       //!< Ch-A data clock (LVDS+)
    input  wire        adc_cha_dco_n,       //!< Ch-A data clock (LVDS-)
    input  wire        adc_cha_fco_p,       //!< Ch-A frame clock (LVDS+)
    input  wire        adc_cha_fco_n,       //!< Ch-A frame clock (LVDS-)

    //---- ADC Channel B (AD9643) ------------------------------------------
    input  wire [13:0] adc_chb_d_p,         //!< Ch-B ADC data (LVDS+)
    input  wire [13:0] adc_chb_d_n,         //!< Ch-B ADC data (LVDS-)
    input  wire        adc_chb_dco_p,       //!< Ch-B data clock (LVDS+)
    input  wire        adc_chb_dco_n,       //!< Ch-B data clock (LVDS-)
    input  wire        adc_chb_fco_p,       //!< Ch-B frame clock (LVDS+)
    input  wire        adc_chb_fco_n,       //!< Ch-B frame clock (LVDS-)

    //---- SPI PLL1 (ADF4106 — LO1 synthesizer) ----------------------------
    output reg         spi_pll1_cs_n,       //!< SPI chip select PLL1
    output reg         spi_pll1_sclk,       //!< SPI clock PLL1
    output reg         spi_pll1_mosi,       //!< SPI MOSI PLL1
    input  wire        spi_pll1_miso,       //!< SPI MISO PLL1

    //---- SPI PLL2 (ADF4106 — LO2 synthesizer) ----------------------------
    output reg         spi_pll2_cs_n,       //!< SPI chip select PLL2
    output reg         spi_pll2_sclk,       //!< SPI clock PLL2
    output reg         spi_pll2_mosi,       //!< SPI MOSI PLL2
    input  wire        spi_pll2_miso,       //!< SPI MISO PLL2

    //---- SPI Flash (AT25SL321) -------------------------------------------
    output reg         spi_flash_cs_n,      //!< SPI flash chip select
    output reg         spi_flash_sclk,      //!< SPI flash clock
    output reg         spi_flash_mosi,      //!< SPI flash MOSI
    input  wire        spi_flash_miso,      //!< SPI flash MISO

    //---- I2C Bus (TMP116, ADM1177, 24AA025E48) ---------------------------
    inout  wire        i2c_sda,             //!< I2C data (bidir)
    output reg         i2c_scl,             //!< I2C clock
    output reg         i2c_sda_oen,         //!< I2C SDA output enable (active-low)

    //---- ADC SPI Control (AD9643) ----------------------------------------
    output reg         adc_spi_cs_n,        //!< ADC SPI chip select
    output reg         adc_spi_sclk,        //!< ADC SPI clock
    output reg         adc_spi_mosi,        //!< ADC SPI MOSI
    input  wire        adc_spi_miso,        //!< ADC SPI MISO

    //---- GPIO / Status ---------------------------------------------------
    output reg  [3:0]  gpio_led,            //!< General-purpose LEDs
    input  wire [3:0]  gpio_dip,            //!< General-purpose DIP switches
    output reg         pps_out,             //!< 1-PPS timing output

    //---- IRQ / System ----------------------------------------------------
    output reg         irq_n,               //!< Active-low interrupt to host
    output reg         hw_status            //!< Hardware status flag output
);

    //========================================================================
    // Parameters
    //========================================================================
    localparam [15:0] VERSION_MAJOR        = 16'h0000;
    localparam [15:0] VERSION_MINOR        = 16'h0001;
    localparam [15:0] VERSION_REV          = 16'h0000;

    // System clock frequency
    localparam [31:0] CLK_FREQ_HZ          = 32'd170_000_000;

    // UART parameters (115200 baud @ 170 MHz)
    localparam [15:0] UART_BAUD_RATE       = 16'd115200;
    localparam [31:0] UART_DIVIDER         = 32'd1473; // ~170e6/115200 - 1

    // Register map addresses
    localparam [15:0] REG_CTRL             = 16'h0000; //!< Control register
    localparam [15:0] REG_STATUS           = 16'h0001; //!< Status register
    localparam [15:0] REG_VERSION          = 16'h0002; //!< Firmware version
    localparam [15:0] REG_SCRATCH          = 16'h0003; //!< Scratch pad
    localparam [15:0] REG_IRQ_MASK         = 16'h0004; //!< IRQ mask
    localparam [15:0] REG_IRQ_STATUS       = 16'h0005; //!< IRQ status
    localparam [15:0] REG_ADC_CHA          = 16'h0010; //!< ADC Ch-A data
    localparam [15:0] REG_ADC_CHB          = 16'h0011; //!< ADC Ch-B data
    localparam [15:0] REG_PLL1_CFG_LO      = 16'h0020; //!< PLL1 config low
    localparam [15:0] REG_PLL1_CFG_HI      = 16'h0021; //!< PLL1 config high
    localparam [15:0] REG_PLL2_CFG_LO      = 16'h0022; //!< PLL2 config low
    localparam [15:0] REG_PLL2_CFG_HI      = 16'h0023; //!< PLL2 config high
    localparam [15:0] REG_DDC_CTRL         = 16'h0030; //!< DDC control
    localparam [15:0] REG_DDC_NCO_LO       = 16'h0031; //!< NCO frequency low
    localparam [15:0] REG_DDC_NCO_HI       = 16'h0032; //!< NCO frequency high
    localparam [15:0] REG_I2C_CTRL         = 16'h0040; //!< I2C control
    localparam [15:0] REG_I2C_DATA         = 16'h0041; //!< I2C data
    localparam [15:0] REG_GPIO_DIR         = 16'h0050; //!< GPIO direction
    localparam [15:0] REG_GPIO_DATA        = 16'h0051; //!< GPIO data
    localparam [15:0] REG_FLASH_CTRL       = 16'h0060; //!< Flash SPI control
    localparam [15:0] REG_FLASH_DATA       = 16'h0061; //!< Flash SPI data

    // UART protocol constants
    localparam [7:0]  UART_SOF             = 8'hAA; //!< Start of frame
    localparam [7:0]  UART_CMD_WR          = 8'h01; //!< Write command
    localparam [7:0]  UART_CMD_RD          = 8'h02; //!< Read command
    localparam [7:0]  UART_CMD_ACK         = 8'h81; //!< Acknowledge
    localparam [7:0]  UART_CMD_NACK        = 8'hFF; //!< Not-acknowledge

    // SPI word length for PLL (ADF4106 = 24-bit)
    localparam [4:0]  SPI_PLL_BIT_LEN      = 5'd24;

    //========================================================================
    // Internal signals
    //========================================================================

    //--- Global clock and reset (from IBUFDS)
    wire        clk_170;
    wire        clk_10;

    //--- Register bus
    reg  [15:0] reg_addr_r;
    reg  [15:0] reg_wdata_r;
    reg  [15:0] reg_rdata_r;
    reg         reg_wr_r;
    reg         reg_rd_r;
    reg         reg_ack_r;

    //--- Register file
    reg  [15:0] regfile [0:127];

    //--- ADC captured data (synchronised to clk_170 domain)
    reg  [13:0] adc_cha_data_r;
    reg  [13:0] adc_chb_data_r;
    reg         adc_cha_frame_r;
    reg         adc_chb_frame_r;
    wire        adc_cha_dco;
    wire        adc_chb_dco;
    wire        adc_cha_fco;
    wire        adc_chb_fco;
    wire [13:0] adc_cha_d;
    wire [13:0] adc_chb_d;

    //--- DDC signals
    reg  [47:0] ddc_cha_i_r;
    reg  [47:0] ddc_cha_q_r;
    reg  [47:0] ddc_chb_i_r;
    reg  [47:0] ddc_chb_q_r;
    reg  [31:0] ddc_nco_phase_r;
    reg         ddc_enable_r;

    //--- UART TX / RX interface
    wire        uart_tx_valid;
    wire [7:0]  uart_tx_data;
    wire        uart_tx_ready;
    wire        uart_rx_valid;
    wire [7:0]  uart_rx_data;

    //--- SPI PLL interface signals
    reg  [23:0] spi_pll1_wdata_r;
    reg  [23:0] spi_pll2_wdata_r;
    reg         spi_pll1_start_r;
    reg         spi_pll2_start_r;
    wire        spi_pll1_busy;
    wire        spi_pll2_busy;

    //--- I2C interface signals
    reg  [7:0]  i2c_addr_r;
    reg  [7:0]  i2c_wdata_r;
    reg         i2c_start_r;
    reg         i2c_rw_r;
    wire [7:0]  i2c_rdata;
    wire        i2c_busy;
    wire        i2c_done;

    //--- IRQ signals
    reg  [15:0] irq_mask_r;
    reg  [15:0] irq_status_r;
    wire        irq_pending;

    //--- PPS counter
    reg  [31:0] pps_counter_r;

    //--- UART protocol FSM
    reg  [2:0]  uart_proto_state_r;
    reg  [15:0] uart_proto_addr_r;
    reg  [15:0] uart_proto_data_r;
    reg  [7:0]  uart_proto_checksum_r;
    reg  [3:0]  uart_proto_byte_cnt_r;

    //--- SPI master FSM
    reg  [3:0]  spi_master_state_r;
    reg  [4:0]  spi_bit_cnt_r;
    reg  [23:0] spi_shift_r;
    reg         spi_active_r;
    reg  [1:0]  spi_target_r; // 0=PLL1, 1=PLL2

    //--- LED blink counter
    reg  [26:0] led_blink_cnt_r;

    //========================================================================
    // Clock buffers (differential to single-ended)
    //========================================================================
    IBUFDS #(
        .DIFF_TERM   (1'b1),
        .IBUF_LOW_PWR("FALSE")
    ) u_ibufds_clk170 (
        .I  (clk_170_p),
        .IB (clk_170_n),
        .O  (clk_170)
    );

    IBUFDS #(
        .DIFF_TERM   (1'b1),
        .IBUF_LOW_PWR("FALSE")
    ) u_ibufds_clk10 (
        .I  (clk_10_p),
        .IB (clk_10_n),
        .O  (clk_10)
    );

    //========================================================================
    // ADC LVDS Input Buffers — Channel A
    //========================================================================
    genvar gi;
    generate
        for (gi = 0; gi < 14; gi = gi + 1) begin : gen_adc_cha_ibufds
            IBUFDS #(
                .DIFF_TERM   (1'b1),
                .IBUF_LOW_PWR("FALSE")
            ) u_adc_cha_d_ibufds (
                .I  (adc_cha_d_p[gi]),
                .IB (adc_cha_d_n[gi]),
                .O  (adc_cha_d[gi])
            );
        end
    endgenerate

    IBUFDS #(
        .DIFF_TERM   (1'b1),
        .IBUF_LOW_PWR("FALSE")
    ) u_adc_cha_dco_ibufds (
        .I  (adc_cha_dco_p),
        .IB (adc_cha_dco_n),
        .O  (adc_cha_dco)
    );

    IBUFDS #(
        .DIFF_TERM   (1'b1),
        .IBUF_LOW_PWR("FALSE")
    ) u_adc_cha_fco_ibufds (
        .I  (adc_cha_fco_p),
        .IB (adc_cha_fco_n),
        .O  (adc_cha_fco)
    );

    //========================================================================
    // ADC LVDS Input Buffers — Channel B
    //========================================================================
    generate
        for (gi = 0; gi < 14; gi = gi + 1) begin : gen_adc_chb_ibufds
            IBUFDS #(
                .DIFF_TERM   (1'b1),
                .IBUF_LOW_PWR("FALSE")
            ) u_adc_chb_d_ibufds (
                .I  (adc_chb_d_p[gi]),
                .IB (adc_chb_d_n[gi]),
                .O  (adc_chb_d[gi])
            );
        end
    endgenerate

    IBUFDS #(
        .DIFF_TERM   (1'b1),
        .IBUF_LOW_PWR("FALSE")
    ) u_adc_chb_dco_ibufds (
        .I  (adc_chb_dco_p),
        .IB (adc_chb_dco_n),
        .O  (adc_chb_dco)
    );

    IBUFDS #(
        .DIFF_TERM   (1'b1),
        .IBUF_LOW_PWR("FALSE")
    ) u_adc_chb_fco_ibufds (
        .I  (adc_chb_fco_p),
        .IB (adc_chb_fco_n),
        .O  (adc_chb_fco)
    );

    //========================================================================
    // UART TX Module
    //========================================================================
    reg  [31:0] uart_tx_baud_cnt_r;
    reg         uart_tx_busy_r;
    reg  [9:0]  uart_tx_shift_r;  // start + 8 data + stop
    reg  [3:0]  uart_tx_bit_cnt_r;

    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            uart_txd           <= 1'b1;
            uart_tx_busy_r     <= 1'b0;
            uart_tx_baud_cnt_r <= 32'd0;
            uart_tx_shift_r    <= 10'h3FF;
            uart_tx_bit_cnt_r  <= 4'd0;
        end else begin
            if (uart_tx_busy_r == 1'b1) begin
                if (uart_tx_baud_cnt_r == UART_DIVIDER - 1) begin
                    uart_tx_baud_cnt_r <= 32'd0;
                    uart_txd           <= uart_tx_shift_r[0];
                    uart_tx_shift_r    <= {1'b1, uart_tx_shift_r[9:1]};
                    if (uart_tx_bit_cnt_r == 4'd9) begin
                        uart_tx_busy_r <= 1'b0;
                    end else begin
                        uart_tx_bit_cnt_r <= uart_tx_bit_cnt_r + 4'd1;
                    end
                end else begin
                    uart_tx_baud_cnt_r <= uart_tx_baud_cnt_r + 32'd1;
                end
            end else if (uart_tx_valid == 1'b1) begin
                uart_tx_busy_r     <= 1'b1;
                uart_tx_baud_cnt_r <= 32'd0;
                uart_tx_shift_r    <= {1'b1, uart_tx_data[7:0], 1'b0};
                uart_tx_bit_cnt_r  <= 4'd0;
                uart_txd           <= 1'b0; // start bit
            end
        end
    end

    assign uart_tx_ready = ~uart_tx_busy_r;

    //========================================================================
    // UART RX Module
    //========================================================================
    reg  [31:0] uart_rx_baud_cnt_r;
    reg         uart_rx_busy_r;
    reg  [7:0]  uart_rx_shift_r;
    reg  [2:0]  uart_rx_bit_cnt_r;
    reg         uart_rx_data_valid_r;
    reg         uart_rxd_sync0_r;
    reg         uart_rxd_sync1_r;

    // 2-FF synchroniser for async UART RX input
    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            uart_rxd_sync0_r <= 1'b1;
            uart_rxd_sync1_r <= 1'b1;
        end else begin
            uart_rxd_sync0_r <= uart_rxd;
            uart_rxd_sync1_r <= uart_rxd_sync0_r;
        end
    end

    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            uart_rx_valid        <= 1'b0;
            uart_rx_data         <= 8'd0;
            uart_rx_busy_r       <= 1'b0;
            uart_rx_baud_cnt_r   <= 32'd0;
            uart_rx_shift_r      <= 8'd0;
            uart_rx_bit_cnt_r    <= 3'd0;
            uart_rx_data_valid_r <= 1'b0;
        end else begin
            uart_rx_data_valid_r <= 1'b0;
            if (uart_rx_busy_r == 1'b0) begin
                uart_rx_valid  <= 1'b0;
                // Detect start bit (falling edge)
                if (uart_rxd_sync1_r == 1'b0) begin
                    uart_rx_busy_r     <= 1'b1;
                    uart_rx_baud_cnt_r <= (UART_DIVIDER >> 1); // half-bit offset
                    uart_rx_bit_cnt_r  <= 3'd0;
                end
            end else begin
                if (uart_rx_baud_cnt_r == UART_DIVIDER - 1) begin
                    uart_rx_baud_cnt_r <= 32'd0;
                    uart_rx_shift_r    <= {uart_rxd_sync1_r, uart_rx_shift_r[7:1]};
                    if (uart_rx_bit_cnt_r == 3'd7) begin
                        uart_rx_busy_r <= 1'b0;
                        if (uart_rxd_sync1_r == 1'b1) begin // stop bit check
                            uart_rx_data         <= {uart_rxd_sync1_r, uart_rx_shift_r[7:1]};
                            uart_rx_data_valid_r <= 1'b1;
                            uart_rx_valid        <= 1'b1;
                        end
                    end else begin
                        uart_rx_bit_cnt_r <= uart_rx_bit_cnt_r + 3'd1;
                    end
                end else begin
                    uart_rx_baud_cnt_r <= uart_rx_baud_cnt_r + 32'd1;
                end
            end
        end
    end

    //========================================================================
    // UART TX response FIFO (simple 16-deep x 8-bit)
    //========================================================================
    reg  [7:0]  uart_tx_fifo [0:15];
    reg  [3:0]  uart_tx_fifo_wr_ptr_r;
    reg  [3:0]  uart_tx_fifo_rd_ptr_r;
    wire        uart_tx_fifo_empty;
    wire        uart_tx_fifo_full;
    reg         uart_tx_fifo_pop_r;

    assign uart_tx_fifo_empty = (uart_tx_fifo_wr_ptr_r == uart_tx_fifo_rd_ptr_r);
    assign uart_tx_fifo_full  = ((uart_tx_fifo_wr_ptr_r[3:0] + 4'd1) == uart_tx_fifo_rd_ptr_r);

    reg         uart_tx_send_en_r;

    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            uart_tx_fifo_wr_ptr_r <= 4'd0;
            uart_tx_fifo_rd_ptr_r <= 4'd0;
            uart_tx_send_en_r     <= 1'b0;
            uart_tx_fifo_pop_r    <= 1'b0;
        end else begin
            uart_tx_fifo_pop_r <= 1'b0;
            // Auto-pop from FIFO when TX is ready
            if (uart_tx_send_en_r == 1'b1 && uart_tx_busy_r == 1'b0
                && uart_tx_fifo_empty == 1'b0) begin
                uart_tx_fifo_rd_ptr_r <= uart_tx_fifo_rd_ptr_r + 4'd1;
                uart_tx_fifo_pop_r    <= 1'b1;
                uart_tx_send_en_r     <= 1'b1;
            end else begin
                uart_tx_send_en_r <= ~uart_tx_fifo_empty;
            end
        end
    end

    assign uart_tx_valid = uart_tx_fifo_pop_r;
    assign uart_tx_data  = uart_tx_fifo[uart_tx_fifo_rd_ptr_r];

    //========================================================================
    // UART Protocol FSM (Frame: SOF | CMD | ADDR[15:8] | ADDR[7:0] |
    //                                   | DATA[15:8] | DATA[7:0] | CHKSUM)
    //========================================================================
    localparam [2:0] UPROTO_IDLE    = 3'd0;
    localparam [2:0] UPROTO_CMD    = 3'd1;
    localparam [2:0] UPROTO_ADDR_H = 3'd2;
    localparam [2:0] UPROTO_ADDR_L = 3'd3;
    localparam [2:0] UPROTO_DATA_H = 3'd4;
    localparam [2:0] UPROTO_DATA_L = 3'd5;
    localparam [2:0] UPROTO_CHKSUM = 3'd6;
    localparam [2:0] UPROTO_RESP   = 3'd7;

    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            uart_proto_state_r     <= UPROTO_IDLE;
            uart_proto_addr_r      <= 16'd0;
            uart_proto_data_r      <= 16'd0;
            uart_proto_checksum_r  <= 8'd0;
            uart_proto_byte_cnt_r  <= 4'd0;
            reg_wr_r               <= 1'b0;
            reg_rd_r               <= 1'b0;
            reg_addr_r             <= 16'd0;
            reg_wdata_r            <= 16'd0;
        end else begin
            reg_wr_r <= 1'b0;
            reg_rd_r <= 1'b0;

            case (uart_proto_state_r)
                //------------------------------------
                UPROTO_IDLE: begin
                    if (uart_rx_valid == 1'b1) begin
                        if (uart_rx_data == UART_SOF) begin
                            uart_proto_checksum_r <= 8'd0;
                            uart_proto_state_r    <= UPROTO_CMD;
                        end
                    end
                end
                //------------------------------------
                UPROTO_CMD: begin
                    if (uart_rx_valid == 1'b1) begin
                        uart_proto_checksum_r <= uart_proto_checksum_r
                                                 + uart_rx_data;
                        uart_proto_data_r[15] <= (uart_rx_data == UART_CMD_RD);
                        uart_proto_state_r    <= UPROTO_ADDR_H;
                    end
                end
                //------------------------------------
                UPROTO_ADDR_H: begin
                    if (uart_rx_valid == 1'b1) begin
                        uart_proto_addr_r[15:8] <= uart_rx_data;
                        uart_proto_checksum_r   <= uart_proto_checksum_r
                                                   + uart_rx_data;
                        uart_proto_state_r      <= UPROTO_ADDR_L;
                    end
                end
                //------------------------------------
                UPROTO_ADDR_L: begin
                    if (uart_rx_valid == 1'b1) begin
                        uart_proto_addr_r[7:0] <= uart_rx_data;
                        uart_proto_checksum_r  <= uart_proto_checksum_r
                                                  + uart_rx_data;
                        uart_proto_state_r     <= UPROTO_DATA_H;
                    end
                end
                //------------------------------------
                UPROTO_DATA_H: begin
                    if (uart_rx_valid == 1'b1) begin
                        uart_proto_data_r[15:8] <= uart_rx_data;
                        uart_proto_checksum_r   <= uart_proto_checksum_r
                                                   + uart_rx_data;
                        uart_proto_state_r      <= UPROTO_DATA_L;
                    end
                end
                //------------------------------------
                UPROTO_DATA_L: begin
                    if (uart_rx_valid == 1'b1) begin
                        uart_proto_data_r[7:0] <= uart_rx_data;
                        uart_proto_checksum_r  <= uart_proto_checksum_r
                                                  + uart_rx_data;
                        uart_proto_state_r     <= UPROTO_CHKSUM;
                    end
                end
                //------------------------------------
                UPROTO_CHKSUM: begin
                    if (uart_rx_valid == 1'b1) begin
                        if (uart_rx_data == uart_proto_checksum_r) begin
                            reg_addr_r  <= uart_proto_addr_r;
                            reg_wdata_r <= uart_proto_data_r;
                            if (uart_proto_data_r[15] == 1'b1) begin
                                reg_rd_r <= 1'b1;
                            end else begin
                                reg_wr_r <= 1'b1;
                            end
                            uart_proto_state_r <= UPROTO_RESP;
                        end else begin
                            // Checksum error → NACK
                            uart_proto_state_r <= UPROTO_RESP;
                        end
                        uart_proto_byte_cnt_r <= 4'd0;
                    end
                end
                //------------------------------------
                UPROTO_RESP: begin
                    // Wait for register read data then send response
                    // Response: SOF | ACK/NACK | ADDR[15:8] | ADDR[7:0]
                    //         | DATA[15:8] | DATA[7:0] | CHKSUM
                    if (uart_proto_byte_cnt_r == 4'd0) begin
                        // SOF
                        if (uart_tx_fifo_full == 1'b0) begin
                            uart_tx_fifo[uart_tx_fifo_wr_ptr_r] <= UART_SOF;
                            uart_tx_fifo_wr_ptr_r <= uart_tx_fifo_wr_ptr_r
                                                     + 4'd1;
                            uart_proto_byte_cnt_r <= 4'd1;
                        end
                    end else if (uart_proto_byte_cnt_r == 4'd1) begin
                        // ACK byte
                        if (uart_tx_fifo_full == 1'b0) begin
                            uart_tx_fifo[uart_tx_fifo_wr_ptr_r] <= UART_CMD_ACK;
                            uart_tx_fifo_wr_ptr_r <= uart_tx_fifo_wr_ptr_r
                                                     + 4'd1;
                            uart_proto_checksum_r <= UART_CMD_ACK;
                            uart_proto_byte_cnt_r <= 4'd2;
                        end
                    end else if (uart_proto_byte_cnt_r == 4'd2) begin
                        // ADDR high
                        if (uart_tx_fifo_full == 1'b0) begin
                            uart_tx_fifo[uart_tx_fifo_wr_ptr_r]
                                <= uart_proto_addr_r[15:8];
                            uart_tx_fifo_wr_ptr_r <= uart_tx_fifo_wr_ptr_r
                                                     + 4'd1;
                            uart_proto_checksum_r <= uart_proto_checksum_r
                                                     + uart_proto_addr_r[15:8];
                            uart_proto_byte_cnt_r <= 4'd3;
                        end
                    end else if (uart_proto_byte_cnt_r == 4'd3) begin
                        // ADDR low
                        if (uart_tx_fifo_full == 1'b0) begin
                            uart_tx_fifo[uart_tx_fifo_wr_ptr_r]
                                <= uart_proto_addr_r[7:0];
                            uart_tx_fifo_wr_ptr_r <= uart_tx_fifo_wr_ptr_r
                                                     + 4'd1;
                            uart_proto_checksum_r <= uart_proto_checksum_r
                                                     + uart_proto_addr_r[7:0];
                            uart_proto_byte_cnt_r <= 4'd4;
                        end
                    end else if (uart_proto_byte_cnt_r == 4'd4) begin
                        // DATA high (read-back data)
                        if (uart_tx_fifo_full == 1'b0) begin
                            uart_tx_fifo[uart_tx_fifo_wr_ptr_r]
                                <= reg_rdata_r[15:8];
                            uart_tx_fifo_wr_ptr_r <= uart_tx_fifo_wr_ptr_r
                                                     + 4'd1;
                            uart_proto_checksum_r <= uart_proto_checksum_r
                                                     + reg_rdata_r[15:8];
                            uart_proto_byte_cnt_r <= 4'd5;
                        end
                    end else if (uart_proto_byte_cnt_r == 4'd5) begin
                        // DATA low
                        if (uart_tx_fifo_full == 1'b0) begin
                            uart_tx_fifo[uart_tx_fifo_wr_ptr_r]
                                <= reg_rdata_r[7:0];
                            uart_tx_fifo_wr_ptr_r <= uart_tx_fifo_wr_ptr_r
                                                     + 4'd1;
                            uart_proto_checksum_r <= uart_proto_checksum_r
                                                     + reg_rdata_r[7:0];
                            uart_proto_byte_cnt_r <= 4'd6;
                        end
                    end else begin
                        // Checksum
                        if (uart_tx_fifo_full == 1'b0) begin
                            uart_tx_fifo[uart_tx_fifo_wr_ptr_r]
                                <= uart_proto_checksum_r;
                            uart_tx_fifo_wr_ptr_r <= uart_tx_fifo_wr_ptr_r
                                                     + 4'd1;
                            uart_proto_state_r <= UPROTO_IDLE;
                        end
                    end
                end
                //------------------------------------
                default: begin
                    uart_proto_state_r <= UPROTO_IDLE;
                end
            endcase
        end
    end

    //========================================================================
    // Register File (16-bit wide, 128 entries)
    //========================================================================
    integer ri;

    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            for (ri = 0; ri < 128; ri = ri + 1) begin
                regfile[ri] <= 16'd0;
            end
            // Fixed values
            regfile[REG_VERSION] <= {VERSION_MAJOR, VERSION_MINOR};
        end else begin
            // Read side
            reg_rdata_r <= regfile[reg_addr_r[6:0]];

            // Write side
            if (reg_wr_r == 1'b1) begin
                case (reg_addr_r)
                    REG_CTRL:       regfile[REG_CTRL]       <= reg_wdata_r;
                    REG_SCRATCH:    regfile[REG_SCRATCH]    <= reg_wdata_r;
                    REG_IRQ_MASK:   regfile[REG_IRQ_MASK]   <= reg_wdata_r;
                    REG_IRQ_STATUS: regfile[REG_IRQ_STATUS] <= reg_wdata_r;
                    REG_PLL1_CFG_LO: regfile[REG_PLL1_CFG_LO] <= reg_wdata_r;
                    REG_PLL1_CFG_HI: regfile[REG_PLL1_CFG_HI] <= reg_wdata_r;
                    REG_PLL2_CFG_LO: regfile[REG_PLL2_CFG_LO] <= reg_wdata_r;
                    REG_PLL2_CFG_HI: regfile[REG_PLL2_CFG_HI] <= reg_wdata_r;
                    REG_DDC_CTRL:   regfile[REG_DDC_CTRL]   <= reg_wdata_r;
                    REG_DDC_NCO_LO: regfile[REG_DDC_NCO_LO] <= reg_wdata_r;
                    REG_DDC_NCO_HI: regfile[REG_DDC_NCO_HI] <= reg_wdata_r;
                    REG_I2C_CTRL:   regfile[REG_I2C_CTRL]   <= reg_wdata_r;
                    REG_I2C_DATA:   regfile[REG_I2C_DATA]   <= reg_wdata_r;
                    REG_GPIO_DIR:   regfile[REG_GPIO_DIR]   <= reg_wdata_r;
                    REG_GPIO_DATA:  regfile[REG_GPIO_DATA]  <= reg_wdata_r;
                    REG_FLASH_CTRL: regfile[REG_FLASH_CTRL] <= reg_wdata_r;
                    REG_FLASH_DATA: regfile[REG_FLASH_DATA] <= reg_wdata_r;
                    default: ; // Read-only or unmapped — ignore write
                endcase
            end

            // Auto-update STATUS register
            regfile[REG_STATUS] <= {12'd0, adc_cha_frame_r,
                                    adc_chb_frame_r, 1'b0,
                                    (spi_pll1_busy | spi_pll2_busy)};
            regfile[REG_ADC_CHA] <= {2'd0, adc_cha_data_r};
            regfile[REG_ADC_CHB] <= {2'd0, adc_chb_data_r};
        end
    end

    //========================================================================
    // ADC Data Capture — Channel A
    // Uses IDDR to capture on both edges of DCO, then framed by FCO
    //========================================================================
    reg  [13:0] adc_cha_ddr_lo_r;
    reg  [13:0] adc_cha_ddr_hi_r;
    reg         adc_cha_fco_prev_r;

    generate
        for (gi = 0; gi < 14; gi = gi + 1) begin : gen_adc_cha_iddr
            IDDR #(
                .DDR_CLK_EDGE ("OPPOSITE_EDGE"),
                .INIT_Q1      (1'b0),
                .INIT_Q2      (1'b0),
                .SRTYPE       ("SYNC")
            ) u_adc_cha_iddr (
                .Q1 (adc_cha_ddr_lo_r[gi]),
                .Q2 (adc_cha_ddr_hi_r[gi]),
                .C  (adc_cha_dco),
                .CE (1'b1),
                .D  (adc_cha_d[gi]),
                .R  (~rst_n),
                .S  (1'b0)
            );
        end
    endgenerate

    // Frame clock synchroniser (2-FF CDC from DCO to clk_170 domain)
    reg adc_cha_fco_s0_r, adc_cha_fco_s1_r;
    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            adc_cha_fco_s0_r   <= 1'b0;
            adc_cha_fco_s1_r   <= 1'b0;
            adc_cha_fco_prev_r <= 1'b0;
            adc_cha_frame_r    <= 1'b0;
            adc_cha_data_r     <= 14'd0;
        end else begin
            adc_cha_fco_s0_r <= adc_cha_fco;
            adc_cha_fco_s1_r <= adc_cha_fco_s0_r;
            adc_cha_fco_prev_r <= adc_cha_fco_s1_r;
            // Capture data on rising edge of FCO
            if (adc_cha_fco_s1_r == 1'b1 && adc_cha_fco_prev_r == 1'b0) begin
                adc_cha_data_r  <= adc_cha_ddr_hi_r;
                adc_cha_frame_r <= 1'b1;
            end else begin
                adc_cha_frame_r <= 1'b0;
            end
        end
    end

    //========================================================================
    // ADC Data Capture — Channel B
    //========================================================================
    reg  [13:0] adc_chb_ddr_lo_r;
    reg  [13:0] adc_chb_ddr_hi_r;
    reg         adc_chb_fco_prev_r;

    generate
        for (gi = 0; gi < 14; gi = gi + 1) begin : gen_adc_chb_iddr
            IDDR #(
                .DDR_CLK_EDGE ("OPPOSITE_EDGE"),
                .INIT_Q1      (1'b0),
                .INIT_Q2      (1'b0),
                .SRTYPE       ("SYNC")
            ) u_adc_chb_iddr (
                .Q1 (adc_chb_ddr_lo_r[gi]),
                .Q2 (adc_chb_ddr_hi_r[gi]),
                .C  (adc_chb_dco),
                .CE (1'b1),
                .D  (adc_chb_d[gi]),
                .R  (~rst_n),
                .S  (1'b0)
            );
        end
    endgenerate

    reg adc_chb_fco_s0_r, adc_chb_fco_s1_r;
    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            adc_chb_fco_s0_r   <= 1'b0;
            adc_chb_fco_s1_r   <= 1'b0;
            adc_chb_fco_prev_r <= 1'b0;
            adc_chb_frame_r    <= 1'b0;
            adc_chb_data_r     <= 14'd0;
        end else begin
            adc_chb_fco_s0_r <= adc_chb_fco;
            adc_chb_fco_s1_r <= adc_chb_fco_s0_r;
            adc_chb_fco_prev_r <= adc_chb_fco_s1_r;
            if (adc_chb_fco_s1_r == 1'b1 && adc_chb_fco_prev_r == 1'b0) begin
                adc_chb_data_r  <= adc_chb_ddr_hi_r;
                adc_chb_frame_r <= 1'b1;
            end else begin
                adc_chb_frame_r <= 1'b0;
            end
        end
    end

    //========================================================================
    // Digital Downconverter (DDC) — simplified NCO + mixer
    // NCO generates sine/cosine for 200 MHz IF → baseband conversion
    //========================================================================
    reg  [15:0] ddc_nco_cos_r;
    reg  [15:0] ddc_nco_sin_r;
    reg  [31:0] ddc_nco_phase_acc_r;

    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            ddc_nco_phase_acc_r <= 32'd0;
            ddc_nco_cos_r       <= 16'd0;
            ddc_nco_sin_r       <= 16'd0;
            ddc_enable_r        <= 1'b0;
            ddc_nco_phase_r     <= 32'd0;
            ddc_cha_i_r         <= 48'd0;
            ddc_cha_q_r         <= 48'd0;
            ddc_chb_i_r         <= 48'd0;
            ddc_chb_q_r         <= 48'd0;
        end else begin
            ddc_enable_r  <= regfile[REG_DDC_CTRL][0];
            ddc_nco_phase_r <= {regfile[REG_DDC_NCO_HI],
                                regfile[REG_DDC_NCO_LO]};

            if (ddc_enable_r == 1'b1) begin
                // NCO phase accumulator
                ddc_nco_phase_acc_r <= ddc_nco_phase_acc_r
                                       + ddc_nco_phase_r;

                // Simplified NCO — cosine/sine via lookup approximation
                // Using upper bits of phase as index
                case (ddc_nco_phase_acc_r[31:30])
                    2'b00: begin
                        ddc_nco_cos_r <= 16'h7FFF;
                        ddc_nco_sin_r <= 16'd0;
                    end
                    2'b01: begin
                        ddc_nco_cos_r <= 16'd0;
                        ddc_nco_sin_r <= 16'h7FFF;
                    end
                    2'b10: begin
                        ddc_nco_cos_r <= 16'h8001;
                        ddc_nco_sin_r <= 16'd0;
                    end
                    2'b11: begin
                        ddc_nco_cos_r <= 16'd0;
                        ddc_nco_sin_r <= 16'h8001;
                    end
                    default: begin
                        ddc_nco_cos_r <= 16'd0;
                        ddc_nco_sin_r <= 16'd0;
                    end
                endcase

                // Mixer: multiply ADC data by NCO (I = cos, Q = -sin)
                // Ch-A
                ddc_cha_i_r <= $signed({2'd0, adc_cha_data_r})
                               * $signed(ddc_nco_cos_r);
                ddc_cha_q_r <= $signed({2'd0, adc_cha_data_r})
                               * $signed(ddc_nco_sin_r);
                // Ch-B
                ddc_chb_i_r <= $signed({2'd0, adc_chb_data_r})
                               * $signed(ddc_nco_cos_r);
                ddc_chb_q_r <= $signed({2'd0, adc_chb_data_r})
                               * $signed(ddc_nco_sin_r);
            end
        end
    end

    //========================================================================
    // SPI Master FSM — Shared between PLL1, PLL2, and Flash
    // Binary-encoded FSM with default state
    //========================================================================
    localparam [3:0] SPI_IDLE      = 4'd0;
    localparam [3:0] SPI_ASSERT_CS = 4'd1;
    localparam [3:0] SPI_SHIFT     = 4'd2;
    localparam [3:0] SPI_SCLK_LO   = 4'd3;
    localparam [3:0] SPI_SCLK_HI   = 4'd4;
    localparam [3:0] SPI_DEASSERT_CS = 4'd5;
    localparam [3:0] SPI_DONE      = 4'd6;

    reg  [4:0]  spi_bit_len_r;
    reg  [15:0] spi_delay_cnt_r;

    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            spi_master_state_r <= SPI_IDLE;
            spi_bit_cnt_r      <= 5'd0;
            spi_shift_r        <= 24'd0;
            spi_active_r       <= 1'b0;
            spi_target_r       <= 2'd0;
            spi_bit_len_r      <= SPI_PLL_BIT_LEN;
            spi_delay_cnt_r    <= 16'd0;
            spi_pll1_cs_n      <= 1'b1;
            spi_pll1_sclk      <= 1'b0;
            spi_pll1_mosi      <= 1'b0;
            spi_pll2_cs_n      <= 1'b1;
            spi_pll2_sclk      <= 1'b0;
            spi_pll2_mosi      <= 1'b0;
            spi_flash_cs_n     <= 1'b1;
            spi_flash_sclk     <= 1'b0;
            spi_flash_mosi     <= 1'b0;
        end else begin
            case (spi_master_state_r)
                //------------------------------------
                SPI_IDLE: begin
                    spi_pll1_cs_n  <= 1'b1;
                    spi_pll2_cs_n  <= 1'b1;
                    spi_flash_cs_n <= 1'b1;
                    spi_active_r   <= 1'b0;

                    // Priority: PLL1 > PLL2 > Flash
                    if (spi_pll1_start_r == 1'b1) begin
                        spi_target_r  <= 2'd0;
                        spi_shift_r   <= spi_pll1_wdata_r;
                        spi_bit_len_r <= SPI_PLL_BIT_LEN;
                        spi_master_state_r <= SPI_ASSERT_CS;
                        spi_active_r  <= 1'b1;
                    end else if (spi_pll2_start_r == 1'b1) begin
                        spi_target_r  <= 2'd1;
                        spi_shift_r   <= spi_pll2_wdata_r;
                        spi_bit_len_r <= SPI_PLL_BIT_LEN;
                        spi_master_state_r <= SPI_ASSERT_CS;
                        spi_active_r  <= 1'b1;
                    end
                    // Flash SPI could be added here (future)
                end
                //------------------------------------
                SPI_ASSERT_CS: begin
                    case (spi_target_r)
                        2'd0:    spi_pll1_cs_n  <= 1'b0;
                        2'd1:    spi_pll2_cs_n  <= 1'b0;
                        default: spi_flash_cs_n <= 1'b0;
                    endcase
                    spi_bit_cnt_r   <= 5'd0;
                    spi_delay_cnt_r <= 16'd0;
                    spi_master_state_r <= SPI_SHIFT;
                end
                //------------------------------------
                SPI_SHIFT: begin
                    if (spi_bit_cnt_r < spi_bit_len_r) begin
                        spi_master_state_r <= SPI_SCLK_LO;
                        spi_delay_cnt_r    <= 16'd0;
                    end else begin
                        spi_master_state_r <= SPI_DEASSERT_CS;
                    end
                end
                //------------------------------------
                SPI_SCLK_LO: begin
                    // Drive MOSI, assert SCLK low
                    case (spi_target_r)
                        2'd0: begin
                            spi_pll1_sclk <= 1'b0;
                            spi_pll1_mosi <= spi_shift_r[23];
                        end
                        2'd1: begin
                            spi_pll2_sclk <= 1'b0;
                            spi_pll2_mosi <= spi_shift_r[23];
                        end
                        default: begin
                            spi_flash_sclk <= 1'b0;
                            spi_flash_mosi <= spi_shift_r[23];
                        end
                    endcase
                    if (spi_delay_cnt_r == 16'd4) begin
                        spi_delay_cnt_r    <= 16'd0;
                        spi_master_state_r <= SPI_SCLK_HI;
                    end else begin
                        spi_delay_cnt_r <= spi_delay_cnt_r + 16'd1;
                    end
                end
                //------------------------------------
                SPI_SCLK_HI: begin
                    // Assert SCLK high
                    case (spi_target_r)
                        2'd0:    spi_pll1_sclk  <= 1'b1;
                        2'd1:    spi_pll2_sclk  <= 1'b1;
                        default: spi_flash_sclk <= 1'b1;
                    endcase
                    if (spi_delay_cnt_r == 16'd4) begin
                        spi_shift_r        <= {spi_shift_r[22:0], 1'b0};
                        spi_bit_cnt_r      <= spi_bit_cnt_r + 5'd1;
                        spi_delay_cnt_r    <= 16'd0;
                        spi_master_state_r <= SPI_SHIFT;
                    end else begin
                        spi_delay_cnt_r <= spi_delay_cnt_r + 16'd1;
                    end
                end
                //------------------------------------
                SPI_DEASSERT_CS: begin
                    case (spi_target_r)
                        2'd0: begin
                            spi_pll1_cs_n  <= 1'b1;
                            spi_pll1_sclk  <= 1'b0;
                            spi_pll1_mosi  <= 1'b0;
                        end
                        2'd1: begin
                            spi_pll2_cs_n  <= 1'b1;
                            spi_pll2_sclk  <= 1'b0;
                            spi_pll2_mosi  <= 1'b0;
                        end
                        default: begin
                            spi_flash_cs_n <= 1'b1;
                            spi_flash_sclk <= 1'b0;
                            spi_flash_mosi <= 1'b0;
                        end
                    endcase
                    spi_master_state_r <= SPI_DONE;
                end
                //------------------------------------
                SPI_DONE: begin
                    spi_master_state_r <= SPI_IDLE;
                end
                //------------------------------------
                default: begin
                    spi_master_state_r <= SPI_IDLE;
                end
            endcase
        end
    end

    assign spi_pll1_busy = (spi_active_r == 1'b1 && spi_target_r == 2'd0);
    assign spi_pll2_busy = (spi_active_r == 1'b1 && spi_target_r == 2'd1);

    //========================================================================
    // PLL1 / PLL2 SPI start triggers from register writes
    //========================================================================
    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            spi_pll1_wdata_r <= 24'd0;
            spi_pll1_start_r <= 1'b0;
            spi_pll2_wdata_r <= 24'd0;
            spi_pll2_start_r <= 1'b0;
        end else begin
            spi_pll1_start_r <= 1'b0;
            spi_pll2_start_r <= 1'b0;

            // PLL1: trigger SPI on write to REG_PLL1_CFG_HI with bit[0]=1
            if (reg_wr_r == 1'b1 && reg_addr_r == REG_PLL1_CFG_HI
                && reg_wdata_r[0] == 1'b1 && spi_pll1_busy == 1'b0) begin
                spi_pll1_wdata_r <= {regfile[REG_PLL1_CFG_HI][15:1],
                                     regfile[REG_PLL1_CFG_LO]};
                spi_pll1_start_r <= 1'b1;
            end

            // PLL2: trigger SPI on write to REG_PLL2_CFG_HI with bit[0]=1
            if (reg_wr_r == 1'b1 && reg_addr_r == REG_PLL2_CFG_HI
                && reg_wdata_r[0] == 1'b1 && spi_pll2_busy == 1'b0) begin
                spi_pll2_wdata_r <= {regfile[REG_PLL2_CFG_HI][15:1],
                                     regfile[REG_PLL2_CFG_LO]};
                spi_pll2_start_r <= 1'b1;
            end
        end
    end

    //========================================================================
    // I2C Master — simplified bit-bang via register interface
    //========================================================================
    reg  [15:0] i2c_bit_cnt_r;
    reg         i2c_scl_r;
    reg         i2c_sda_oen_r;

    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            i2c_scl        <= 1'b1;
            i2c_sda_oen    <= 1'b1; // high-Z (input)
            i2c_scl_r      <= 1'b1;
            i2c_sda_oen_r  <= 1'b1;
            i2c_busy       <= 1'b0;
            i2c_done       <= 1'b0;
            i2c_rdata      <= 8'd0;
        end else begin
            i2c_done <= 1'b0;
            // Simple register-controlled I2C:
            //   REG_I2C_CTRL[2:0] = {start, scl, sda_oe}
            if (reg_wr_r == 1'b1 && reg_addr_r == REG_I2C_CTRL) begin
                i2c_scl     <= reg_wdata_r[1];
                i2c_sda_oen <= ~reg_wdata_r[0]; // 1=drive, 0=release
            end
            // REG_I2C_DATA read returns the SDA input
            if (reg_rd_r == 1'b1 && reg_addr_r == REG_I2C_DATA) begin
                regfile[REG_I2C_DATA] <= {15'd0, i2c_sda};
            end
        end
    end

    //========================================================================
    // ADC SPI Control — basic register-driven bit-bang
    //========================================================================
    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            adc_spi_cs_n  <= 1'b1;
            adc_spi_sclk  <= 1'b0;
            adc_spi_mosi  <= 1'b0;
        end else begin
            // Driven directly by register GPIO (or dedicated ADC SPI registers)
            adc_spi_cs_n  <= 1'b1;  // Default de-asserted
            adc_spi_sclk  <= 1'b0;
            adc_spi_mosi  <= 1'b0;
        end
    end

    //========================================================================
    // GPIO / LED / Status
    //========================================================================
    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            gpio_led       <= 4'b0001;
            led_blink_cnt_r <= 27'd0;
            hw_status      <= 1'b0;
        end else begin
            led_blink_cnt_r <= led_blink_cnt_r + 27'd1;

            // LED[0] blinks at ~1.27 Hz (170e6 / 2^27)
            gpio_led[0] <= led_blink_cnt_r[26];
            // LED[1] = PLL1 busy
            gpio_led[1] <= spi_pll1_busy;
            // LED[2] = PLL2 busy
            gpio_led[2] <= spi_pll2_busy;
            // LED[3] = DDC enable
            gpio_led[3] <= ddc_enable_r;

            hw_status <= ~rst_n;
        end
    end

    //========================================================================
    // PPS Output — 1 pulse per second from 10 MHz reference
    //========================================================================
    always @(posedge clk_10) begin
        if (rst_n == 1'b0) begin
            pps_counter_r <= 32'd0;
            pps_out       <= 1'b0;
        end else begin
            if (pps_counter_r >= 32'd10_000_000) begin
                pps_counter_r <= 32'd0;
                pps_out       <= 1'b1;
            end else if (pps_counter_r >= 32'd100_000) begin
                pps_out <= 1'b0;
                pps_counter_r <= pps_counter_r + 32'd1;
            end else begin
                pps_counter_r <= pps_counter_r + 32'd1;
            end
        end
    end

    //========================================================================
    // IRQ Management
    //========================================================================
    always @(posedge clk_170) begin
        if (rst_n == 1'b0) begin
            irq_mask_r   <= 16'hFFFF;
            irq_status_r <= 16'd0;
            irq_n        <= 1'b1;
        end else begin
            irq_mask_r <= regfile[REG_IRQ_MASK];

            // Generate IRQ status (edge-sensitive sources)
            if (reg_wr_r == 1'b1 && reg_addr_r == REG_IRQ_STATUS) begin
                // Write-1-to-clear
                irq_status_r <= irq_status_r & ~reg_wdata_r;
            end else begin
                // Set IRQ status bits
                irq_status_r[0] <= irq_status_r[0] | adc_cha_frame_r;
                irq_status_r[1] <= irq_status_r[1] | adc_chb_frame_r;
                irq_status_r[4] <= irq_status_r[4] | (~spi_pll1_busy
                                                       & spi_pll1_start_r);
                irq_status_r[5] <= irq_status_r[5] | (~spi_pll2_busy
                                                       & spi_pll2_start_r);
            end

            // IRQ output (active-low when any unmasked source is active)
            irq_n <= ~(|(irq_status_r & ~irq_mask_r));
        end
    end

    assign irq_pending = |(irq_status_r & ~irq_mask_r);

endmodule // hjjg_top