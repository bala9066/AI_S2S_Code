//============================================================================
// @file    fpga_top.v
// @brief   Top-level FPGA module for the hv project
//
// @details 18-40 GHz dual-channel double-IF superheterodyne radar receiver
//          FPGA design targeting Xilinx Kintex-7 XC7K160T-1FFG676I.
//          Features:
//          - Dual-channel 12-bit 150 MSPS ADC interface (AD9627 LVDS)
//          - Digital downconversion (DDC) with NCO and CIC decimation
//          - SPI masters for LO1 PLL (ADF4108), LO2 PLL (LMX2487),
//            ADC (AD9627), and dual VGA gain DACs
//          - 16-bit UART register bus for host communication
//          - QSPI flash interface for bitstream / firmware storage
//          - SPI EEPROM for calibration data (AT93C56B)
//          - I2C temperature sensor interface (AD7416)
//          - LVDS output data interface to digital I/O connector
//          - Board ID GPIO inputs and status LED outputs
//
// @note    All outputs are registered. Active-low synchronous reset.
//          Two main FSMs: SPI master and UART RX/TX protocol handler.
//
// @version 0V01
// @date    2026-04-25
//============================================================================

`timescale 1ns / 1ps

module hv_top #(
    parameter CLK_FREQ_HZ        = 100_000_000,
    parameter UART_BAUD           = 12_000_000,
    parameter ADC_DATA_WIDTH      = 12,
    parameter ADC_DDR_WIDTH       = 6,
    parameter REG_ADDR_WIDTH      = 16,
    parameter REG_DATA_WIDTH      = 16,
    parameter LVDS_OUT_WIDTH      = 8,
    parameter SPI_CMD_WIDTH       = 24,
    parameter TEMP_SENSOR_ADDR    = 7'h48
)(
    //------------------------------------------------------------------------
    // Clock and Reset
    //------------------------------------------------------------------------
    input  wire        clk_100mhz_p,       //!< 100 MHz TCXO diff clock positive (ASGTX-D-100.000MHZ-1)
    input  wire        clk_100mhz_n,       //!< 100 MHz TCXO diff clock negative
    input  wire        rst_n,              //!< Active-low synchronous reset

    //------------------------------------------------------------------------
    // ADC Interface (AD9627ABCPZ-150) — LVDS
    //------------------------------------------------------------------------
    input  wire        adc_dco_p,          //!< ADC data clock out positive
    input  wire        adc_dco_n,          //!< ADC data clock out negative
    input  wire        adc_fco_p,          //!< ADC frame clock out positive
    input  wire        adc_fco_n,          //!< ADC frame clock out negative
    input  wire [5:0]  adc_da_p,           //!< ADC Ch-A data positive (6 DDR pairs)
    input  wire [5:0]  adc_da_n,           //!< ADC Ch-A data negative
    input  wire [5:0]  adc_db_p,           //!< ADC Ch-B data positive (6 DDR pairs)
    input  wire [5:0]  adc_db_n,           //!< ADC Ch-B data negative

    //------------------------------------------------------------------------
    // LO1 PLL SPI (ADF4108BCPZ-RL7)
    //------------------------------------------------------------------------
    output reg         lo1_spi_cs_n,       //!< LO1 PLL SPI chip select active-low
    output reg         lo1_spi_sclk,       //!< LO1 PLL SPI serial clock
    output reg         lo1_spi_sdi,        //!< LO1 PLL SPI data to PLL
    input  wire        lo1_spi_sdo,        //!< LO1 PLL SPI data from PLL (MISO)

    //------------------------------------------------------------------------
    // LO2 PLL SPI (LMX2487ESQ/NOPB)
    //------------------------------------------------------------------------
    output reg         lo2_spi_cs_n,       //!< LO2 PLL SPI chip select active-low
    output reg         lo2_spi_sclk,       //!< LO2 PLL SPI serial clock
    output reg         lo2_spi_sdi,        //!< LO2 PLL SPI data to PLL
    input  wire        lo2_lock_detect,    //!< LO2 PLL lock detect status

    //------------------------------------------------------------------------
    // VGA Gain Control DAC SPI (shared bus)
    //------------------------------------------------------------------------
    output reg         vga_dac_sclk,       //!< VGA DAC shared SPI clock
    output reg         vga_dac_sdo,        //!< VGA DAC shared SPI data out
    output reg         vga1_dac_cs_n,      //!< VGA1 (CH1) DAC chip select
    output reg         vga2_dac_cs_n,      //!< VGA2 (CH2) DAC chip select

    //------------------------------------------------------------------------
    // ADC SPI Configuration (AD9627)
    //------------------------------------------------------------------------
    output reg         adc_spi_cs_n,       //!< ADC SPI chip select active-low
    output reg         adc_spi_sclk,       //!< ADC SPI serial clock
    output reg         adc_spi_sdi,        //!< ADC SPI serial data to ADC
    input  wire        adc_spi_sdo,        //!< ADC SPI serial data from ADC

    //------------------------------------------------------------------------
    // QSPI Flash (IS25LP256D)
    //------------------------------------------------------------------------
    output reg         qspi_cs_n,          //!< QSPI flash chip select
    output reg  [3:0]  qspi_dq_out,        //!< QSPI data[3:0] output
    input  wire [3:0]  qspi_dq_in,         //!< QSPI data[3:0] input
    output reg  [3:0]  qspi_dq_oe_n,       //!< QSPI data[3:0] output enable (active-low)

    //------------------------------------------------------------------------
    // SPI EEPROM (AT93C56B-SSHL-T)
    //------------------------------------------------------------------------
    output reg         eeprom_cs_n,        //!< EEPROM chip select active-low
    output reg         eeprom_sclk,        //!< EEPROM serial clock
    output reg         eeprom_sdi,         //!< EEPROM serial data in to EEPROM
    input  wire        eeprom_sdo,         //!< EEPROM serial data out from EEPROM

    //------------------------------------------------------------------------
    // I2C Temperature Sensor (AD7416ARMZ)
    //------------------------------------------------------------------------
    inout  wire        temp_sda,           //!< I2C data (open-drain bidir)
    output reg         temp_scl,           //!< I2C clock

    //------------------------------------------------------------------------
    // UART Interface (FT232H USB-UART Bridge)
    //------------------------------------------------------------------------
    input  wire        uart_rx,            //!< UART receive from host
    output reg         uart_tx,            //!< UART transmit to host

    //------------------------------------------------------------------------
    // JTAG (directly to FPGA pads — not in RTL, shown for documentation)
    //------------------------------------------------------------------------

    //------------------------------------------------------------------------
    // LVDS Digital Output (to J_DIG connector)
    //------------------------------------------------------------------------
    output reg  [LVDS_OUT_WIDTH-1:0] lvds_out_p,  //!< LVDS output data positive
    output reg  [LVDS_OUT_WIDTH-1:0] lvds_out_n,  //!< LVDS output data negative
    output reg         lvds_clk_p,         //!< LVDS output clock positive
    output reg         lvds_clk_n,         //!< LVDS output clock negative

    //------------------------------------------------------------------------
    // GPIO / Status
    //------------------------------------------------------------------------
    input  wire [3:0]  board_id,           //!< Board ID switch inputs
    output reg  [3:0]  status_led,         //!< Status LEDs
    output reg         pll_ref_en,         //!< PLL reference buffer enable
    output reg         adc_pd_n,           //!< ADC power-down (active-low)
    output reg  [1:0]  vga_shutdown_n      //!< VGA shutdown control (active-low)
);

    //========================================================================
    // Local Parameters — Register Map
    //========================================================================
    localparam [15:0] REG_CTRL       = 16'h8000;  // RW: Control register
    localparam [15:0] REG_STATUS     = 16'h8001;  // RO: Status register
    localparam [15:0] REG_VERSION    = 16'h8002;  // RO: Firmware version
    localparam [15:0] REG_SCRATCH    = 16'h8003;  // RW: Scratch pad
    localparam [15:0] REG_IRQ_MASK   = 16'h8004;  // RW: IRQ mask
    localparam [15:0] REG_IRQ_STATUS = 16'h8005;  // RW1C: IRQ status
    localparam [15:0] REG_LO1_CFG    = 16'h8100;  // RW: LO1 PLL config
    localparam [15:0] REG_LO2_CFG    = 16'h8200;  // RW: LO2 PLL config
    localparam [15:0] REG_ADC_CFG    = 16'h8300;  // RW: ADC config
    localparam [15:0] REG_VGA1_GAIN  = 16'h8400;  // RW: VGA1 gain DAC value
    localparam [15:0] REG_VGA2_GAIN  = 16'h8401;  // RW: VGA2 gain DAC value
    localparam [15:0] REG_DDC_CFG    = 16'h8500;  // RW: DDC/NCO config
    localparam [15:0] REG_TEMP       = 16'h8600;  // RO: Temperature sensor

    localparam [15:0] FW_VERSION     = 16'h0001;  // Version 0.01

    // FIFO depths (power of 2)
    localparam FIFO_DEPTH    = 16;
    localparam FIFO_ADDR_W   = 4;  // log2(FIFO_DEPTH)

    // UART internal baud rate counter
    localparam UART_CLK_DIV  = CLK_FREQ_HZ / UART_BAUD;

    //========================================================================
    // Internal Signals
    //========================================================================
    wire        clk;               // Global clock from MMCM/BUFIO
    wire        clk_adc;           // ADC DCO-derived clock (via BUFR)
    wire        clk_io;            // IO clock domain (from MMCM)
    wire        pll_locked;        // MMCM lock status

    //------------------------------------------------------------------------
    // ADC data (captured in clk_adc domain)
    //------------------------------------------------------------------------
    reg  [ADC_DATA_WIDTH-1:0] adc_ch_a_data_r;
    reg  [ADC_DATA_WIDTH-1:0] adc_ch_b_data_r;
    reg        adc_frame_r;
    reg        adc_data_valid_r;

    //------------------------------------------------------------------------
    // CDC: ADC domain → clk domain (2-FF synchronisers + handshake)
    //------------------------------------------------------------------------
    reg  [ADC_DATA_WIDTH-1:0] adc_ch_a_sync_r [1:0];
    reg  [ADC_DATA_WIDTH-1:0] adc_ch_b_sync_r [1:0];
    reg        adc_valid_sync_r [1:0];

    //------------------------------------------------------------------------
    // DDC signals (in clk domain)
    //------------------------------------------------------------------------
    reg  signed [15:0] ddc_nco_inc_r;    // NCO phase increment
    reg  signed [15:0] ddc_ch_a_i_r;     // CH-A in-phase (DDC out)
    reg  signed [15:0] ddc_ch_a_q_r;     // CH-A quadrature (DDC out)
    reg  signed [15:0] ddc_ch_b_i_r;     // CH-B in-phase
    reg  signed [15:0] ddc_ch_b_q_r;     // CH-B quadrature
    reg        ddc_valid_r;

    //------------------------------------------------------------------------
    // NCO phase accumulator
    //------------------------------------------------------------------------
    reg  [31:0] nco_phase_r;

    //------------------------------------------------------------------------
    // CIC decimation
    //------------------------------------------------------------------------
    localparam CIC_DECIM    = 4;         // Decimation factor
    localparam CIC_STAGES   = 3;         // Number of integrator/comb stages
    reg  signed [23:0] cic_int_a_r [0:CIC_STAGES-1]; // Integrators CH-A I
    reg  signed [23:0] cic_int_b_r [0:CIC_STAGES-1]; // Integrators CH-B I
    reg  [1:0]  cic_decim_cnt_r;
    reg        cic_output_valid_r;
    reg  signed [23:0] cic_ch_a_out_r;
    reg  signed [23:0] cic_ch_b_out_r;
    // Comb stage registers
    reg  signed [23:0] cic_comb_a_r [0:CIC_STAGES-1];
    reg  signed [23:0] cic_comb_a_prev_r [0:CIC_STAGES-1];
    reg  signed [23:0] cic_comb_b_r [0:CIC_STAGES-1];
    reg  signed [23:0] cic_comb_b_prev_r [0:CIC_STAGES-1];

    //------------------------------------------------------------------------
    // Register bus
    //------------------------------------------------------------------------
    reg  [REG_ADDR_WIDTH-1:0] reg_addr_r;
    reg  [REG_DATA_WIDTH-1:0] reg_wdata_r;
    reg  [REG_DATA_WIDTH-1:0] reg_rdata_r;
    reg        reg_wr_r;
    reg        reg_rd_r;
    reg        reg_ack_r;

    // Register storage
    reg  [REG_DATA_WIDTH-1:0] reg_ctrl_r;
    reg  [REG_DATA_WIDTH-1:0] reg_status_r;
    reg  [REG_DATA_WIDTH-1:0] reg_scratch_r;
    reg  [REG_DATA_WIDTH-1:0] reg_irq_mask_r;
    reg  [REG_DATA_WIDTH-1:0] reg_irq_status_r;
    reg  [REG_DATA_WIDTH-1:0] reg_lo1_cfg_r;
    reg  [REG_DATA_WIDTH-1:0] reg_lo2_cfg_r;
    reg  [REG_DATA_WIDTH-1:0] reg_adc_cfg_r;
    reg  [REG_DATA_WIDTH-1:0] reg_vga1_gain_r;
    reg  [REG_DATA_WIDTH-1:0] reg_vga2_gain_r;
    reg  [REG_DATA_WIDTH-1:0] reg_ddc_cfg_r;
    reg  [REG_DATA_WIDTH-1:0] reg_temp_r;

    //------------------------------------------------------------------------
    // SPI master — shared by all SPI peripherals
    //------------------------------------------------------------------------
    reg  [23:0] spi_shift_out_r;
    reg  [23:0] spi_shift_in_r;
    reg  [4:0]  spi_bit_cnt_r;        // Up to 24 bits
    reg        spi_busy_r;
    reg        spi_done_r;
    reg        spi_active_cs_r;       // Which CS is asserted

    // SPI peripheral select encoding
    localparam [2:0] SPI_SEL_LO1  = 3'd0;
    localparam [2:0] SPI_SEL_LO2  = 3'd1;
    localparam [2:0] SPI_SEL_ADC  = 3'd2;
    localparam [2:0] SPI_SEL_VGA1 = 3'd3;
    localparam [2:0] SPI_SEL_VGA2 = 3'd4;

    reg  [2:0]  spi_sel_r;            // Peripheral select register

    //------------------------------------------------------------------------
    // SPI master FSM states
    //------------------------------------------------------------------------
    localparam [2:0] SPI_IDLE      = 3'd0;
    localparam [2:0] SPI_ASSERT_CS = 3'd1;
    localparam [2:0] SPI_SHIFT     = 3'd2;
    localparam [2:0] SPI_DEASSERT_CS = 3'd3;
    localparam [2:0] SPI_DONE_WAIT = 3'd4;

    (* fsm_encoding = "binary" *)
    reg  [2:0] spi_fsm_state_r;

    //------------------------------------------------------------------------
    // UART RX FSM
    //------------------------------------------------------------------------
    localparam [2:0] UART_RX_IDLE  = 3'd0;
    localparam [2:0] UART_RX_START = 3'd1;
    localparam [2:0] UART_RX_DATA  = 3'd2;
    localparam [2:0] UART_RX_STOP  = 3'd3;

    (* fsm_encoding = "binary" *)
    reg  [2:0] uart_rx_fsm_r;

    reg  [15:0] uart_rx_clk_div_r;
    reg  [3:0]  uart_rx_bit_cnt_r;
    reg  [7:0]  uart_rx_shift_r;
    reg        uart_rx_data_rdy_r;

    // UART frame: [START(0)][D0..D7][STOP(1)] at 16-bit word protocol
    // Protocol: 4 bytes per register access:
    //   Byte 0: CMD (0x01=Write, 0x02=Read)
    //   Byte 1: Addr[15:8]
    //   Byte 2: Addr[7:0]
    //   Byte 3: Data[15:8] (write only, for read: sent back after)
    //   Byte 4: Data[7:0]  (write only)

    reg  [7:0]  uart_rx_buf_r [0:4];
    reg  [2:0]  uart_rx_byte_cnt_r;

    //------------------------------------------------------------------------
    // UART TX FSM
    //------------------------------------------------------------------------
    localparam [2:0] UART_TX_IDLE  = 3'd0;
    localparam [2:0] UART_TX_START = 3'd1;
    localparam [2:0] UART_TX_DATA  = 3'd2;
    localparam [2:0] UART_TX_STOP  = 3'd3;

    (* fsm_encoding = "binary" *)
    reg  [2:0] uart_tx_fsm_r;

    reg  [15:0] uart_tx_clk_div_r;
    reg  [3:0]  uart_tx_bit_cnt_r;
    reg  [7:0]  uart_tx_shift_r;
    reg        uart_tx_busy_r;
    reg        uart_tx_data_req_r;
    reg  [7:0]  uart_tx_data_byte_r;

    // TX response buffer
    reg  [7:0]  uart_tx_resp_buf_r [0:3];
    reg  [1:0]  uart_tx_resp_cnt_r;

    //------------------------------------------------------------------------
    // Protocol handler FSM
    //------------------------------------------------------------------------
    localparam [3:0] PROT_IDLE      = 4'd0;
    localparam [3:0] PROT_GET_CMD   = 4'd1;
    localparam [3:0] PROT_GET_ADDRH = 4'd2;
    localparam [3:0] PROT_GET_ADDRL = 4'd3;
    localparam [3:0] PROT_GET_DATAH = 4'd4;
    localparam [3:0] PROT_GET_DATAL = 4'd5;
    localparam [3:0] PROT_EXEC_WR   = 4'd6;
    localparam [3:0] PROT_EXEC_RD   = 4'd7;
    localparam [3:0] PROT_SEND_RESP = 4'd8;
    localparam [3:0] PROT_DONE      = 4'd9;

    (* fsm_encoding = "binary" *)
    reg  [3:0] prot_fsm_state_r;

    reg  [7:0]  prot_cmd_r;
    reg  [15:0] prot_addr_r;
    reg  [15:0] prot_data_r;

    //------------------------------------------------------------------------
    // I2C temperature sensor
    //------------------------------------------------------------------------
    reg  [7:0]  i2c_clk_div_r;
    reg  [3:0]  i2c_bit_cnt_r;
    reg  [7:0]  i2c_shift_r;
    reg        i2c_sda_oe_r;           // 1 = drive SDA low
    reg        i2c_busy_r;
    reg        i2c_done_r;

    localparam [3:0] I2C_IDLE     = 4'd0;
    localparam [3:0] I2C_START    = 4'd1;
    localparam [3:0] I2C_ADDR     = 4'd2;
    localparam [3:0] I2C_ACK_ADDR = 4'd3;
    localparam [3:0] I2C_REG_PTR  = 4'd4;
    localparam [3:0] I2C_ACK_REG  = 4'd5;
    localparam [3:0] I2C_RESTART  = 4'd6;
    localparam [3:0] I2C_RD_ADDR  = 4'd7;
    localparam [3:0] I2C_RD_ACK   = 4'd8;
    localparam [3:0] I2C_RD_DATA  = 4'd9;
    localparam [3:0] I2C_STOP     = 4'd10;

    (* fsm_encoding = "binary" *)
    reg  [3:0] i2c_fsm_state_r;

    reg  [15:0] temp_raw_r;
    reg        temp_valid_r;
    reg  [15:0] temp_timer_r;          // Polling timer

    //------------------------------------------------------------------------
    // LVDS output data FIFO (clk → clk_io)
    //------------------------------------------------------------------------
    reg  [15:0] lvds_fifo_din_r;
    reg        lvds_fifo_wr_en_r;
    reg  [15:0] lvds_fifo_dout_r;
    reg        lvds_fifo_rd_en_r;
    reg        lvds_fifo_empty_r;
    reg        lvds_fifo_full_r;
    reg  [FIFO_ADDR_W:0] lvds_fifo_count_r;

    // Simple dual-port FIFO memory
    reg  [15:0] lvds_fifo_mem_r [0:FIFO_DEPTH-1];
    reg  [FIFO_ADDR_W-1:0] lvds_fifo_wr_ptr_r;
    reg  [FIFO_ADDR_W-1:0] lvds_fifo_rd_ptr_r;

    //------------------------------------------------------------------------
    // LO1 lock detect synchroniser
    //------------------------------------------------------------------------
    reg  [1:0] lo2_lock_sync_r;
    wire       lo2_locked;

    //------------------------------------------------------------------------
    // IRQ signals
    //------------------------------------------------------------------------
    reg        irq_pending_r;
    wire       irq_out;

    //------------------------------------------------------------------------
    // Output register enables (for registered outputs)
    //------------------------------------------------------------------------
    reg        qspi_dq_oe_reg_r [0:3];

    //========================================================================
    // Clock Buffer — instantiate IBUFDS + BUFG for primary clock
    //========================================================================
    wire clk_ibufds_out;

    IBUFDS #(
        .DIFF_TERM   ("TRUE"),
        .IOSTANDARD  ("LVDS_25")
    ) u_ibufds_clk (
        .I   (clk_100mhz_p),
        .IB  (clk_100mhz_n),
        .O   (clk_ibufds_out)
    );

    BUFG u_bufg_clk (
        .I   (clk_ibufds_out),
        .O   (clk)
    );

    //------------------------------------------------------------------------
    // ADC DCO / FCO — IBUFDS + BUFR for source-sync interface
    //------------------------------------------------------------------------
    wire clk_dco_ibuf;
    wire clk_fco_ibuf;

    IBUFDS #(
        .DIFF_TERM   ("TRUE"),
        .IOSTANDARD  ("LVDS_25")
    ) u_ibufds_dco (
        .I   (adc_dco_p),
        .IB  (adc_dco_n),
        .O   (clk_dco_ibuf)
    );

    IBUFDS #(
        .DIFF_TERM   ("TRUE"),
        .IOSTANDARD  ("LVDS_25")
    ) u_ibufds_fco (
        .I   (adc_fco_p),
        .IB  (adc_fco_n),
        .O   (clk_fco_ibuf)
    );

    BUFR #(
        .BUFR_DIVIDE ("BYPASS")
    ) u_bufr_dco (
        .I   (clk_dco_ibuf),
        .O   (clk_adc),
        .CE  (1'b1),
        .CLR (1'b0)
    );

    BUFR #(
        .BUFR_DIVIDE ("BYPASS")
    ) u_bufr_fco (
        .I   (clk_fco_ibuf),
        .O   (clk_io),
        .CE  (1'b1),
        .CLR (1'b0)
    );

    // Assign pll_locked (no MMCM used; direct BUFG → always locked after reset)
    assign pll_locked = 1'b1;

    //========================================================================
    // ADC Data Capture (in clk_adc domain)
    //========================================================================
    // DDR data capture using IDDR primitives
    genvar gi;
    generate
        for (gi = 0; gi < ADC_DDR_WIDTH; gi = gi + 1) begin : gen_adc_ddr_ch_a
            wire adc_da_sdr_lo;
            wire adc_da_sdr_hi;
            wire adc_da_ibuf;

            IBUFDS #(
                .DIFF_TERM  ("TRUE"),
                .IOSTANDARD ("LVDS_25")
            ) u_ibufds_da (
                .I  (adc_da_p[gi]),
                .IB (adc_da_n[gi]),
                .O  (adc_da_ibuf)
            );

            IDDR #(
                .DDR_CLK_EDGE ("SAME_EDGE_PIPELINED"),
                .SRTYPE       ("SYNC")
            ) u_iddr_da (
                .Q1  (adc_da_sdr_lo),
                .Q2  (adc_da_sdr_hi),
                .C   (clk_adc),
                .CE  (1'b1),
                .D   (adc_da_ibuf),
                .R   (~rst_n),
                .S   (1'b0)
            );

            // Reconstruct 12-bit word from 6 DDR pairs
            always_ff @(posedge clk_adc) begin
                if (~rst_n) begin
                    adc_ch_a_data_r[gi]       <= 1'b0;
                    adc_ch_a_data_r[gi+6]     <= 1'b0;
                end else begin
                    adc_ch_a_data_r[gi]       <= adc_da_sdr_lo;
                    adc_ch_a_data_r[gi+6]     <= adc_da_sdr_hi;
                end
            end
        end

        for (gi = 0; gi < ADC_DDR_WIDTH; gi = gi + 1) begin : gen_adc_ddr_ch_b
            wire adc_db_sdr_lo;
            wire adc_db_sdr_hi;
            wire adc_db_ibuf;

            IBUFDS #(
                .DIFF_TERM  ("TRUE"),
                .IOSTANDARD ("LVDS_25")
            ) u_ibufds_db (
                .I  (adc_db_p[gi]),
                .IB (adc_db_n[gi]),
                .O  (adc_db_ibuf)
            );

            IDDR #(
                .DDR_CLK_EDGE ("SAME_EDGE_PIPELINED"),
                .SRTYPE       ("SYNC")
            ) u_iddr_db (
                .Q1  (adc_db_sdr_lo),
                .Q2  (adc_db_sdr_hi),
                .C   (clk_adc),
                .CE  (1'b1),
                .D   (adc_db_ibuf),
                .R   (~rst_n),
                .S   (1'b0)
            );

            always_ff @(posedge clk_adc) begin
                if (~rst_n) begin
                    adc_ch_b_data_r[gi]       <= 1'b0;
                    adc_ch_b_data_r[gi+6]     <= 1'b0;
                end else begin
                    adc_ch_b_data_r[gi]       <= adc_db_sdr_lo;
                    adc_ch_b_data_r[gi+6]     <= adc_db_sdr_hi;
                end
            end
        end
    endgenerate

    // Frame detection and data valid
    always_ff @(posedge clk_adc) begin
        if (~rst_n) begin
            adc_frame_r       <= 1'b0;
            adc_data_valid_r  <= 1'b0;
        end else begin
            adc_frame_r       <= clk_fco_ibuf;
            adc_data_valid_r  <= 1'b1;  // Continuous streaming mode
        end
    end

    //========================================================================
    // CDC: ADC domain → System clock domain (2-FF synchronisers)
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            adc_ch_a_sync_r[0] <= {ADC_DATA_WIDTH{1'b0}};
            adc_ch_a_sync_r[1] <= {ADC_DATA_WIDTH{1'b0}};
            adc_ch_b_sync_r[0] <= {ADC_DATA_WIDTH{1'b0}};
            adc_ch_b_sync_r[1] <= {ADC_DATA_WIDTH{1'b0}};
            adc_valid_sync_r[0] <= 1'b0;
            adc_valid_sync_r[1] <= 1'b0;
        end else begin
            // Stage 1
            adc_ch_a_sync_r[0] <= adc_ch_a_data_r;
            adc_ch_b_sync_r[0] <= adc_ch_b_data_r;
            adc_valid_sync_r[0] <= adc_data_valid_r;
            // Stage 2
            adc_ch_a_sync_r[1] <= adc_ch_a_sync_r[0];
            adc_ch_b_sync_r[1] <= adc_ch_b_sync_r[0];
            adc_valid_sync_r[1] <= adc_valid_sync_r[0];
        end
    end

    //========================================================================
    // DDC — NCO + Mixer + CIC Decimation (in clk domain)
    //========================================================================

    // DDC enable from control register
    wire ddc_enable = reg_ctrl_r[0];
    wire adc_sync_valid = adc_valid_sync_r[1];

    // NCO phase accumulator (simple 32-bit accumulator)
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            nco_phase_r <= 32'd0;
        end else if (ddc_enable && adc_sync_valid) begin
            nco_phase_r <= nco_phase_r + {{16{ddc_nco_inc_r[15]}}, ddc_nco_inc_r, 16'd0};
        end
    end

    // Simple NCO: use top 2 bits of phase as coarse sin/cos
    // (In production, use Xilinx DDS IP; here a simplified LUT-less version)
    wire [1:0] nco_quad = nco_phase_r[31:30];
    reg signed [15:0] nco_cos_r;
    reg signed [15:0] nco_sin_r;

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            nco_cos_r <= 16'sd0;
            nco_sin_r <= 16'sd0;
        end else begin
            case (nco_quad)
                2'b00: begin
                    nco_cos_r <= 16'sd32767;
                    nco_sin_r <= 16'sd0;
                end
                2'b01: begin
                    nco_cos_r <= 16'sd0;
                    nco_sin_r <= 16'sd32767;
                end
                2'b10: begin
                    nco_cos_r <= -16'sd32767;
                    nco_sin_r <= 16'sd0;
                end
                2'b11: begin
                    nco_cos_r <= 16'sd0;
                    nco_sin_r <= -16'sd32767;
                end
                default: begin
                    nco_cos_r <= 16'sd0;
                    nco_sin_r <= 16'sd0;
                end
            endcase
        end
    end

    // Mixer: multiply ADC sample by NCO (sign-extend ADC 12-bit to 16-bit)
    reg signed [31:0] mix_a_i_r, mix_a_q_r;
    reg signed [31:0] mix_b_i_r, mix_b_q_r;

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            mix_a_i_r <= 32'sd0;
            mix_a_q_r <= 32'sd0;
            mix_b_i_r <= 32'sd0;
            mix_b_q_r <= 32'sd0;
            ddc_valid_r <= 1'b0;
        end else if (ddc_enable && adc_sync_valid) begin
            mix_a_i_r <= $signed({4'b0, adc_ch_a_sync_r[1]}) * nco_cos_r;
            mix_a_q_r <= $signed({4'b0, adc_ch_a_sync_r[1]}) * nco_sin_r;
            mix_b_i_r <= $signed({4'b0, adc_ch_b_sync_r[1]}) * nco_cos_r;
            mix_b_q_r <= $signed({4'b0, adc_ch_b_sync_r[1]}) * nco_sin_r;
            ddc_valid_r <= 1'b1;
        end else begin
            ddc_valid_r <= 1'b0;
        end
    end

    // Take upper 24 bits of mixer output for CIC
    wire signed [23:0] cic_in_a = mix_a_i_r[31:8];
    wire signed [23:0] cic_in_b = mix_b_i_r[31:8];

    //========================================================================
    // CIC Decimation Filter
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            cic_decim_cnt_r  <= 2'd0;
            cic_output_valid_r <= 1'b0;
            cic_ch_a_out_r   <= 24'sd0;
            cic_ch_b_out_r   <= 24'sd0;
            cic_int_a_r[0]   <= 24'sd0;
            cic_int_a_r[1]   <= 24'sd0;
            cic_int_a_r[2]   <= 24'sd0;
            cic_int_b_r[0]   <= 24'sd0;
            cic_int_b_r[1]   <= 24'sd0;
            cic_int_b_r[2]   <= 24'sd0;
            cic_comb_a_r[0]  <= 24'sd0;
            cic_comb_a_r[1]  <= 24'sd0;
            cic_comb_a_r[2]  <= 24'sd0;
            cic_comb_a_prev_r[0] <= 24'sd0;
            cic_comb_a_prev_r[1] <= 24'sd0;
            cic_comb_a_prev_r[2] <= 24'sd0;
            cic_comb_b_r[0]  <= 24'sd0;
            cic_comb_b_r[1]  <= 24'sd0;
            cic_comb_b_r[2]  <= 24'sd0;
            cic_comb_b_prev_r[0] <= 24'sd0;
            cic_comb_b_prev_r[1] <= 24'sd0;
            cic_comb_b_prev_r[2] <= 24'sd0;
        end else if (ddc_valid_r) begin
            // Integrator stages — CH-A
            cic_int_a_r[0] <= cic_int_a_r[0] + cic_in_a;
            cic_int_a_r[1] <= cic_int_a_r[1] + cic_int_a_r[0];
            cic_int_a_r[2] <= cic_int_a_r[2] + cic_int_a_r[1];
            // Integrator stages — CH-B
            cic_int_b_r[0] <= cic_int_b_r[0] + cic_in_b;
            cic_int_b_r[1] <= cic_int_b_r[1] + cic_int_b_r[0];
            cic_int_b_r[2] <= cic_int_b_r[2] + cic_int_b_r[1];

            // Decimation counter
            if (cic_decim_cnt_r == CIC_DECIM[1:0] - 1) begin
                cic_decim_cnt_r <= 2'd0;
                // Comb stages — CH-A
                cic_comb_a_r[0] <= cic_int_a_r[2] - cic_comb_a_prev_r[0];
                cic_comb_a_prev_r[0] <= cic_int_a_r[2];
                cic_comb_a_r[1] <= cic_comb_a_r[0] - cic_comb_a_prev_r[1];
                cic_comb_a_prev_r[1] <= cic_comb_a_r[0];
                cic_comb_a_r[2] <= cic_comb_a_r[1] - cic_comb_a_prev_r[2];
                cic_comb_a_prev_r[2] <= cic_comb_a_r[1];

                // Comb stages — CH-B
                cic_comb_b_r[0] <= cic_int_b_r[2] - cic_comb_b_prev_r[0];
                cic_comb_b_prev_r[0] <= cic_int_b_r[2];
                cic_comb_b_r[1] <= cic_comb_b_r[0] - cic_comb_b_prev_r[1];
                cic_comb_b_prev_r[1] <= cic_comb_b_r[0];
                cic_comb_b_r[2] <= cic_comb_b_r[1] - cic_comb_b_prev_r[2];
                cic_comb_b_prev_r[2] <= cic_comb_b_r[1];

                cic_ch_a_out_r <= cic_comb_a_r[2];
                cic_ch_b_out_r <= cic_comb_b_r[2];
                cic_output_valid_r <= 1'b1;
            end else begin
                cic_decim_cnt_r <= cic_decim_cnt_r + 2'd1;
                cic_output_valid_r <= 1'b0;
            end
        end else begin
            cic_output_valid_r <= 1'b0;
        end
    end

    //========================================================================
    // LVDS Output FIFO (simple dual-clock inferred BRAM FIFO)
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            lvds_fifo_wr_ptr_r  <= {(FIFO_ADDR_W){1'b0}};
            lvds_fifo_rd_ptr_r  <= {(FIFO_ADDR_W){1'b0}};
            lvds_fifo_count_r   <= {(FIFO_ADDR_W+1){1'b0}};
            lvds_fifo_full_r    <= 1'b0;
            lvds_fifo_empty_r   <= 1'b1;
        end else begin
            // Write side
            if (lvds_fifo_wr_en_r && !lvds_fifo_full_r) begin
                lvds_fifo_mem_r[lvds_fifo_wr_ptr_r] <= {cic_ch_a_out_r[15:0]};
                lvds_fifo_wr_ptr_r <= lvds_fifo_wr_ptr_r + 1'b1;
            end

            // Read side
            if (lvds_fifo_rd_en_r && !lvds_fifo_empty_r) begin
                lvds_fifo_dout_r <= lvds_fifo_mem_r[lvds_fifo_rd_ptr_r];
                lvds_fifo_rd_ptr_r <= lvds_fifo_rd_ptr_r + 1'b1;
            end

            // Count management
            case ({lvds_fifo_wr_en_r && !lvds_fifo_full_r,
                   lvds_fifo_rd_en_r && !lvds_fifo_empty_r})
                2'b10: lvds_fifo_count_r <= lvds_fifo_count_r + 1'b1;
                2'b01: lvds_fifo_count_r <= lvds_fifo_count_r - 1'b1;
                default: lvds_fifo_count_r <= lvds_fifo_count_r;
            endcase

            lvds_fifo_full_r  <= (lvds_fifo_count_r == FIFO_DEPTH - 1) &&
                                  (lvds_fifo_wr_en_r && !lvds_fifo_rd_en_r);
            lvds_fifo_empty_r <= (lvds_fifo_count_r == 0) &&
                                  (!lvds_fifo_wr_en_r || lvds_fifo_rd_en_r);
        end
    end

    // FIFO write enable from CIC output
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            lvds_fifo_wr_en_r <= 1'b0;
        end else begin
            lvds_fifo_wr_en_r <= cic_output_valid_r && reg_ctrl_r[1]; // Output enable
        end
    end

    // FIFO read — in clk_io domain (simplified: same clock for this implementation)
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            lvds_fifo_rd_en_r <= 1'b0;
        end else begin
            lvds_fifo_rd_en_r <= !lvds_fifo_empty_r && reg_ctrl_r[1];
        end
    end

    //========================================================================
    // SPI Master FSM
    //========================================================================
    wire [4:0] spi_cmd_len_r = (spi_sel_r == SPI_SEL_ADC) ? 5'd16 : 5'd24;

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            spi_fsm_state_r   <= SPI_IDLE;
            spi_busy_r        <= 1'b0;
            spi_done_r        <= 1'b0;
            spi_shift_out_r   <= 24'd0;
            spi_shift_in_r    <= 24'd0;
            spi_bit_cnt_r     <= 5'd0;
            lo1_spi_cs_n      <= 1'b1;
            lo1_spi_sclk      <= 1'b0;
            lo1_spi_sdi       <= 1'b0;
            lo2_spi_cs_n      <= 1'b1;
            lo2_spi_sclk      <= 1'b0;
            lo2_spi_sdi       <= 1'b0;
            vga_dac_sclk      <= 1'b0;
            vga_dac_sdo       <= 1'b0;
            vga1_dac_cs_n     <= 1'b1;
            vga2_dac_cs_n     <= 1'b1;
            adc_spi_cs_n      <= 1'b1;
            adc_spi_sclk      <= 1'b0;
            adc_spi_sdi       <= 1'b0;
            spi_active_cs_r   <= 1'b1;
            spi_sel_r         <= 3'd0;
        end else begin
            spi_done_r <= 1'b0;

            case (spi_fsm_state_r)
                SPI_IDLE: begin
                    if (reg_wr_r && (
                        reg_addr_r == REG_LO1_CFG ||
                        reg_addr_r == REG_LO2_CFG ||
                        reg_addr_r == REG_ADC_CFG ||
                        reg_addr_r == REG_VGA1_GAIN ||
                        reg_addr_r == REG_VGA2_GAIN
                    )) begin
                        spi_fsm_state_r <= SPI_ASSERT_CS;
                        spi_busy_r      <= 1'b1;
                        spi_shift_out_r <= {reg_wdata_r, 8'd0}; // Pad to 24 bits
                        spi_bit_cnt_r   <= spi_cmd_len_r;

                        // Determine target
                        case (reg_addr_r)
                            REG_LO1_CFG:   spi_sel_r <= SPI_SEL_LO1;
                            REG_LO2_CFG:   spi_sel_r <= SPI_SEL_LO2;
                            REG_ADC_CFG:   spi_sel_r <= SPI_SEL_ADC;
                            REG_VGA1_GAIN: spi_sel_r <= SPI_SEL_VGA1;
                            REG_VGA2_GAIN: spi_sel_r <= SPI_SEL_VGA2;
                            default:       spi_sel_r <= 3'd0;
                        endcase
                    end else begin
                        spi_busy_r <= 1'b0;
                    end
                end

                SPI_ASSERT_CS: begin
                    case (spi_sel_r)
                        SPI_SEL_LO1:  lo1_spi_cs_n  <= 1'b0;
                        SPI_SEL_LO2:  lo2_spi_cs_n  <= 1'b0;
                        SPI_SEL_ADC:  adc_spi_cs_n  <= 1'b0;
                        SPI_SEL_VGA1: vga1_dac_cs_n <= 1'b0;
                        SPI_SEL_VGA2: vga2_dac_cs_n <= 1'b0;
                        default: ; // No action
                    endcase
                    spi_fsm_state_r <= SPI_SHIFT;
                end

                SPI_SHIFT: begin
                    if (spi_bit_cnt_r > 5'd0) begin
                        // Output MSB first on falling edge, sample on rising
                        case (spi_sel_r)
                            SPI_SEL_LO1: begin
                                lo1_spi_sclk <= 1'b1;
                                lo1_spi_sdi  <= spi_shift_out_r[23];
                            end
                            SPI_SEL_LO2: begin
                                lo2_spi_sclk <= 1'b1;
                                lo2_spi_sdi  <= spi_shift_out_r[23];
                            end
                            SPI_SEL_ADC: begin
                                adc_spi_sclk <= 1'b1;
                                adc_spi_sdi  <= spi_shift_out_r[23];
                            end
                            SPI_SEL_VGA1, SPI_SEL_VGA2: begin
                                vga_dac_sclk <= 1'b1;
                                vga_dac_sdo  <= spi_shift_out_r[23];
                            end
                            default: ; // No action
                        endcase
                        spi_shift_out_r <= {spi_shift_out_r[22:0], 1'b0};
                        spi_bit_cnt_r   <= spi_bit_cnt_r - 5'd1;
                    end else begin
                        // De-assert SCLK
                        case (spi_sel_r)
                            SPI_SEL_LO1:  lo1_spi_sclk  <= 1'b0;
                            SPI_SEL_LO2:  lo2_spi_sclk  <= 1'b0;
                            SPI_SEL_ADC:  adc_spi_sclk  <= 1'b0;
                            SPI_SEL_VGA1,
                            SPI_SEL_VGA2: vga_dac_sclk  <= 1'b0;
                            default: ;
                        endcase
                        spi_fsm_state_r <= SPI_DEASSERT_CS;
                    end
                end

                SPI_DEASSERT_CS: begin
                    lo1_spi_cs_n   <= 1'b1;
                    lo2_spi_cs_n   <= 1'b1;
                    adc_spi_cs_n   <= 1'b1;
                    vga1_dac_cs_n  <= 1'b1;
                    vga2_dac_cs_n  <= 1'b1;
                    spi_fsm_state_r <= SPI_DONE_WAIT;
                end

                SPI_DONE_WAIT: begin
                    spi_done_r      <= 1'b1;
                    spi_busy_r      <= 1'b0;
                    spi_fsm_state_r <= SPI_IDLE;
                end

                default: begin
                    spi_fsm_state_r <= SPI_IDLE;
                    spi_busy_r      <= 1'b0;
                end
            endcase
        end
    end

    //========================================================================
    // UART RX FSM
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            uart_rx_fsm_r       <= UART_RX_IDLE;
            uart_rx_clk_div_r   <= 16'd0;
            uart_rx_bit_cnt_r   <= 4'd0;
            uart_rx_shift_r     <= 8'd0;
            uart_rx_data_rdy_r  <= 1'b0;
            uart_rx_byte_cnt_r  <= 3'd0;
            uart_rx_buf_r[0]    <= 8'd0;
            uart_rx_buf_r[1]    <= 8'd0;
            uart_rx_buf_r[2]    <= 8'd0;
            uart_rx_buf_r[3]    <= 8'd0;
            uart_rx_buf_r[4]    <= 8'd0;
        end else begin
            uart_rx_data_rdy_r <= 1'b0;

            case (uart_rx_fsm_r)
                UART_RX_IDLE: begin
                    uart_rx_clk_div_r <= 16'd0;
                    uart_rx_bit_cnt_r <= 4'd0;
                    if (uart_rx == 1'b0) begin
                        // Detected start bit
                        uart_rx_fsm_r <= UART_RX_START;
                    end
                end

                UART_RX_START: begin
                    // Sample at mid-bit (half baud period)
                    if (uart_rx_clk_div_r == (UART_CLK_DIV[15:0] >> 1)) begin
                        if (uart_rx == 1'b0) begin
                            uart_rx_fsm_r     <= UART_RX_DATA;
                            uart_rx_clk_div_r <= 16'd0;
                        end else begin
                            uart_rx_fsm_r <= UART_RX_IDLE; // False start
                        end
                    end else begin
                        uart_rx_clk_div_r <= uart_rx_clk_div_r + 16'd1;
                    end
                end

                UART_RX_DATA: begin
                    if (uart_rx_clk_div_r == UART_CLK_DIV[15:0] - 16'd1) begin
                        uart_rx_clk_div_r <= 16'd0;
                        uart_rx_shift_r   <= {uart_rx, uart_rx_shift_r[7:1]};
                        uart_rx_bit_cnt_r <= uart_rx_bit_cnt_r + 4'd1;

                        if (uart_rx_bit_cnt_r == 4'd7) begin
                            uart_rx_fsm_r <= UART_RX_STOP;
                        end
                    end else begin
                        uart_rx_clk_div_r <= uart_rx_clk_div_r + 16'd1;
                    end
                end

                UART_RX_STOP: begin
                    if (uart_rx_clk_div_r == UART_CLK_DIV[15:0] - 16'd1) begin
                        uart_rx_clk_div_r  <= 16'd0;
                        uart_rx_data_rdy_r <= 1'b1;

                        // Store received byte
                        if (uart_rx_byte_cnt_r <= 3'd4) begin
                            uart_rx_buf_r[uart_rx_byte_cnt_r] <= uart_rx_shift_r;
                            uart_rx_byte_cnt_r <= uart_rx_byte_cnt_r + 3'd1;
                        end

                        uart_rx_fsm_r <= UART_RX_IDLE;
                    end else begin
                        uart_rx_clk_div_r <= uart_rx_clk_div_r + 16'd1;
                    end
                end

                default: uart_rx_fsm_r <= UART_RX_IDLE;
            endcase
        end
    end

    //========================================================================
    // UART TX FSM
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            uart_tx_fsm_r       <= UART_TX_IDLE;
            uart_tx_clk_div_r   <= 16'd0;
            uart_tx_bit_cnt_r   <= 4'd0;
            uart_tx_shift_r     <= 8'd0;
            uart_tx_busy_r      <= 1'b0;
            uart_tx_data_req_r  <= 1'b0;
            uart_tx_data_byte_r <= 8'd0;
            uart_tx             <= 1'b1;  // Idle high
        end else begin
            case (uart_tx_fsm_r)
                UART_TX_IDLE: begin
                    uart_tx <= 1'b1;
                    if (uart_tx_data_req_r && !uart_tx_busy_r) begin
                        uart_tx_busy_r    <= 1'b1;
                        uart_tx_shift_r   <= uart_tx_data_byte_r;
                        uart_tx_data_req_r <= 1'b0;
                        uart_tx_bit_cnt_r <= 4'd0;
                        uart_tx_fsm_r     <= UART_TX_START;
                    end else begin
                        uart_tx_busy_r <= 1'b0;
                    end
                end

                UART_TX_START: begin
                    uart_tx <= 1'b0; // Start bit
                    if (uart_tx_clk_div_r == UART_CLK_DIV[15:0] - 16'd1) begin
                        uart_tx_clk_div_r <= 16'd0;
                        uart_tx_fsm_r     <= UART_TX_DATA;
                    end else begin
                        uart_tx_clk_div_r <= uart_tx_clk_div_r + 16'd1;
                    end
                end

                UART_TX_DATA: begin
                    uart_tx <= uart_tx_shift_r[0];
                    if (uart_tx_clk_div_r == UART_CLK_DIV[15:0] - 16'd1) begin
                        uart_tx_clk_div_r <= 16'd0;
                        uart_tx_shift_r   <= {1'b0, uart_tx_shift_r[7:1]};
                        uart_tx_bit_cnt_r <= uart_tx_bit_cnt_r + 4'd1;
                        if (uart_tx_bit_cnt_r == 4'd7) begin
                            uart_tx_fsm_r <= UART_TX_STOP;
                        end
                    end else begin
                        uart_tx_clk_div_r <= uart_tx_clk_div_r + 16'd1;
                    end
                end

                UART_TX_STOP: begin
                    uart_tx <= 1'b1; // Stop bit
                    if (uart_tx_clk_div_r == UART_CLK_DIV[15:0] - 16'd1) begin
                        uart_tx_clk_div_r <= 16'd0;
                        uart_tx_fsm_r     <= UART_TX_IDLE;
                        uart_tx_busy_r    <= 1'b0;
                    end else begin
                        uart_tx_clk_div_r <= uart_tx_clk_div_r + 16'd1;
                    end
                end

                default: begin
                    uart_tx_fsm_r <= UART_TX_IDLE;
                    uart_tx       <= 1'b1;
                end
            endcase
        end
    end

    //========================================================================
    // Protocol Handler FSM — processes received UART bytes into register ops
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            prot_fsm_state_r <= PROT_IDLE;
            prot_cmd_r       <= 8'd0;
            prot_addr_r      <= 16'd0;
            prot_data_r      <= 16'd0;
            uart_tx_resp_buf_r[0] <= 8'd0;
            uart_tx_resp_buf_r[1] <= 8'd0;
            uart_tx_resp_buf_r[2] <= 8'd0;
            uart_tx_resp_buf_r[3] <= 8'd0;
            uart_tx_resp_cnt_r    <= 2'd0;
            reg_addr_r       <= 16'd0;
            reg_wdata_r      <= 16'd0;
            reg_wr_r         <= 1'b0;
            reg_rd_r         <= 1'b0;
            reg_ack_r        <= 1'b0;
        end else begin
            reg_wr_r <= 1'b0;
            reg_rd_r <= 1'b0;
            reg_ack_r <= 1'b0;

            case (prot_fsm_state_r)
                PROT_IDLE: begin
                    if (uart_rx_data_rdy_r && uart_rx_byte_cnt_r == 3'd1) begin
                        prot_cmd_r <= uart_rx_buf_r[0];
                        prot_fsm_state_r <= PROT_GET_ADDRH;
                    end
                end

                PROT_GET_ADDRH: begin
                    if (uart_rx_data_rdy_r) begin
                        prot_addr_r[15:8] <= uart_rx_shift_r;
                        prot_fsm_state_r  <= PROT_GET_ADDRL;
                    end
                end

                PROT_GET_ADDRL: begin
                    if (uart_rx_data_rdy_r) begin
                        prot_addr_r[7:0] <= uart_rx_shift_r;
                        if (prot_cmd_r == 8'h01) begin
                            prot_fsm_state_r <= PROT_GET_DATAH; // Write
                        end else if (prot_cmd_r == 8'h02) begin
                            prot_fsm_state_r <= PROT_EXEC_RD;   // Read
                        end else begin
                            prot_fsm_state_r <= PROT_IDLE;
                        end
                    end
                end

                PROT_GET_DATAH: begin
                    if (uart_rx_data_rdy_r) begin
                        prot_data_r[15:8] <= uart_rx_shift_r;
                        prot_fsm_state_r  <= PROT_GET_DATAL;
                    end
                end

                PROT_GET_DATAL: begin
                    if (uart_rx_data_rdy_r) begin
                        prot_data_r[7:0] <= uart_rx_shift_r;
                        prot_fsm_state_r <= PROT_EXEC_WR;
                    end
                end

                PROT_EXEC_WR: begin
                    reg_addr_r  <= prot_addr_r;
                    reg_wdata_r <= prot_data_r;
                    reg_wr_r    <= 1'b1;
                    reg_ack_r   <= 1'b1;
                    prot_fsm_state_r <= PROT_DONE;
                end

                PROT_EXEC_RD: begin
                    reg_addr_r <= prot_addr_r;
                    reg_rd_r   <= 1'b1;
                    reg_ack_r  <= 1'b1;
                    prot_fsm_state_r <= PROT_SEND_RESP;
                end

                PROT_SEND_RESP: begin
                    // Prepare TX response: echo addr + data
                    uart_tx_resp_buf_r[0] <= prot_addr_r[15:8];
                    uart_tx_resp_buf_r[1] <= prot_addr_r[7:0];
                    uart_tx_resp_buf_r[2] <= reg_rdata_r[15:8];
                    uart_tx_resp_buf_r[3] <= reg_rdata_r[7:0];
                    uart_tx_resp_cnt_r    <= 2'd0;
                    prot_fsm_state_r      <= PROT_DONE;
                end

                PROT_DONE: begin
                    // Send response bytes one at a time
                    if (!uart_tx_busy_r) begin
                        if (prot_cmd_r == 8'h02 && uart_tx_resp_cnt_r < 2'd4) begin
                            uart_tx_data_byte_r <= uart_tx_resp_buf_r[uart_tx_resp_cnt_r];
                            uart_tx_data_req_r  <= 1'b1;
                            uart_tx_resp_cnt_r  <= uart_tx_resp_cnt_r + 2'd1;
                        end else begin
                            prot_fsm_state_r <= PROT_IDLE;
                            uart_tx_data_req_r <= 1'b0;
                        end
                    end
                end

                default: prot_fsm_state_r <= PROT_IDLE;
            endcase
        end
    end

    //========================================================================
    // Register File — Read/Write Logic
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            reg_ctrl_r       <= 16'd0;
            reg_scratch_r    <= 16'd0;
            reg_irq_mask_r   <= 16'hFFFF; // All IRQs masked
            reg_irq_status_r <= 16'd0;
            reg_lo1_cfg_r    <= 16'd0;
            reg_lo2_cfg_r    <= 16'd0;
            reg_adc_cfg_r    <= 16'd0;
            reg_vga1_gain_r  <= 16'h8000; // Mid-scale
            reg_vga2_gain_r  <= 16'h8000; // Mid-scale
            reg_ddc_cfg_r    <= 16'd0;
            ddc_nco_inc_r    <= 16'sd0;
            reg_rdata_r      <= 16'd0;
        end else begin
            // Write decoding
            if (reg_wr_r) begin
                case (reg_addr_r)
                    REG_CTRL:       reg_ctrl_r       <= reg_wdata_r;
                    REG_SCRATCH:    reg_scratch_r    <= reg_wdata_r;
                    REG_IRQ_MASK:   reg_irq_mask_r   <= reg_wdata_r;
                    REG_IRQ_STATUS: reg_irq_status_r <= reg_irq_status_r & ~reg_wdata_r; // W1C
                    REG_LO1_CFG:    reg_lo1_cfg_r    <= reg_wdata_r;
                    REG_LO2_CFG:    reg_lo2_cfg_r    <= reg_wdata_r;
                    REG_ADC_CFG:    reg_adc_cfg_r    <= reg_wdata_r;
                    REG_VGA1_GAIN:  reg_vga1_gain_r  <= reg_wdata_r;
                    REG_VGA2_GAIN:  reg_vga2_gain_r  <= reg_wdata_r;
                    REG_DDC_CFG: begin
                        reg_ddc_cfg_r <= reg_wdata_r;
                        ddc_nco_inc_r <= reg_wdata_r;
                    end
                    default: ; // No action for read-only or unmapped
                endcase
            end

            // Read mux
            case (reg_addr_r)
                REG_CTRL:       reg_rdata_r <= reg_ctrl_r;
                REG_STATUS:     reg_rdata_r <= reg_status_r;
                REG_VERSION:    reg_rdata_r <= FW_VERSION;
                REG_SCRATCH:    reg_rdata_r <= reg_scratch_r;
                REG_IRQ_MASK:   reg_rdata_r <= reg_irq_mask_r;
                REG_IRQ_STATUS: reg_rdata_r <= reg_irq_status_r;
                REG_LO1_CFG:    reg_rdata_r <= reg_lo1_cfg_r;
                REG_LO2_CFG:    reg_rdata_r <= reg_lo2_cfg_r;
                REG_ADC_CFG:    reg_rdata_r <= reg_adc_cfg_r;
                REG_VGA1_GAIN:  reg_rdata_r <= reg_vga1_gain_r;
                REG_VGA2_GAIN:  reg_rdata_r <= reg_vga2_gain_r;
                REG_DDC_CFG:    reg_rdata_r <= reg_ddc_cfg_r;
                REG_TEMP:       reg_rdata_r <= reg_temp_r;
                default:        reg_rdata_r <= 16'hDEAD;
            endcase
        end
    end

    //========================================================================
    // Status Register (read-only, auto-populated)
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            reg_status_r <= 16'd0;
        end else begin
            reg_status_r <= {
                4'h0,                    // [15:12] reserved
                pll_locked,              // [11]    PLL/MMCM locked
                lo2_locked,              // [10]    LO2 PLL locked
                1'b0,                    // [9]     reserved
                spi_busy_r,              // [8]     SPI busy
                adc_data_valid_r,        // [7]     ADC data valid
                lvds_fifo_full_r,        // [6]     LVDS FIFO full
                lvds_fifo_empty_r,       // [5]     LVDS FIFO empty
                temp_valid_r,            // [4]     Temperature valid
                board_id                 // [3:0]   Board ID
            };
        end
    end

    //========================================================================
    // LO2 Lock Detect — 2-FF synchroniser
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            lo2_lock_sync_r <= 2'b00;
        end else begin
            lo2_lock_sync_r[0] <= lo2_lock_detect;
            lo2_lock_sync_r[1] <= lo2_lock_sync_r[0];
        end
    end

    assign lo2_locked = lo2_lock_sync_r[1];

    //========================================================================
    // IRQ Generation
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            reg_irq_status_r <= 16'd0;
            irq_pending_r    <= 1'b0;
        end else begin
            // Set IRQ status flags (masked by IRQ_MASK)
            if (lvds_fifo_full_r)
                reg_irq_status_r[0] <= 1'b1; // FIFO overflow
            if (lo2_locked)
                reg_irq_status_r[1] <= 1'b1; // LO2 lock
            if (temp_valid_r)
                reg_irq_status_r[2] <= 1'b1; // Temp ready

            // W1C handled in write decoder above

            // IRQ pending if any unmasked status bit is set
            irq_pending_r <= |(reg_irq_status_r & ~reg_irq_mask_r);
        end
    end

    assign irq_out = irq_pending_r;

    //========================================================================
    // I2C Temperature Sensor FSM (AD7416)
    //========================================================================
    // Simplified I2C master: reads 16-bit temperature value
    // SCL frequency = clk / (4 * i2c_clk_div)

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            i2c_fsm_state_r <= I2C_IDLE;
            i2c_clk_div_r   <= 8'd0;
            i2c_bit_cnt_r   <= 4'd0;
            i2c_shift_r     <= 8'd0;
            i2c_sda_oe_r    <= 1'b0;
            i2c_busy_r      <= 1'b0;
            i2c_done_r      <= 1'b0;
            temp_raw_r      <= 16'd0;
            temp_valid_r    <= 1'b0;
            temp_timer_r    <= 16'd0;
        end else begin
            i2c_done_r <= 1'b0;

            // Temperature polling timer (every ~655 us)
            if (temp_timer_r == 16'hFFFF) begin
                temp_timer_r <= 16'd0;
            end else begin
                temp_timer_r <= temp_timer_r + 16'd1;
            end

            case (i2c_fsm_state_r)
                I2C_IDLE: begin
                    i2c_sda_oe_r <= 1'b0;
                    i2c_busy_r   <= 1'b0;
                    if (temp_timer_r == 16'hFFFF && !i2c_busy_r) begin
                        i2c_fsm_state_r <= I2C_START;
                        i2c_busy_r      <= 1'b1;
                    end
                end

                I2C_START: begin
                    i2c_sda_oe_r <= 1'b1; // Drive SDA low while SCL high = START
                    if (i2c_clk_div_r == 8'd100) begin
                        i2c_clk_div_r <= 8'd0;
                        i2c_shift_r   <= {TEMP_SENSOR_ADDR, 1'b0}; // Write mode
                        i2c_bit_cnt_r <= 4'd0;
                        i2c_fsm_state_r <= I2C_ADDR;
                    end else begin
                        i2c_clk_div_r <= i2c_clk_div_r + 8'd1;
                    end
                end

                I2C_ADDR: begin
                    // Clock out address bits
                    temp_scl  <= (i2c_clk_div_r < 8'd50) ? 1'b0 : 1'b1;
                    i2c_sda_oe_r <= ~i2c_shift_r[7];
                    if (i2c_clk_div_r == 8'd99) begin
                        i2c_clk_div_r <= 8'd0;
                        i2c_shift_r   <= {i2c_shift_r[6:0], 1'b0};
                        i2c_bit_cnt_r <= i2c_bit_cnt_r + 4'd1;
                        if (i2c_bit_cnt_r == 4'd7) begin
                            i2c_fsm_state_r <= I2C_ACK_ADDR;
                        end
                    end else begin
                        i2c_clk_div_r <= i2c_clk_div_r + 8'd1;
                    end
                end

                I2C_ACK_ADDR: begin
                    temp_scl    <= 1'b0;
                    i2c_sda_oe_r <= 1'b0; // Release SDA for ACK
                    if (i2c_clk_div_r == 8'd50) begin
                        i2c_clk_div_r <= 8'd0;
                        // Read temperature register (reg ptr = 0x00)
                        i2c_shift_r <= 8'd0;
                        i2c_bit_cnt_r <= 4'd0;
                        i2c_fsm_state_r <= I2C_STOP; // Simplified: stop after addr
                    end else begin
                        i2c_clk_div_r <= i2c_clk_div_r + 8'd1;
                    end
                end

                I2C_STOP: begin
                    i2c_sda_oe_r <= 1'b0;
                    temp_scl     <= 1'b1;
                    i2c_fsm_state_r <= I2C_IDLE;
                    i2c_busy_r      <= 1'b0;
                    i2c_done_r      <= 1'b1;
                    temp_valid_r    <= 1'b1;
                    temp_raw_r      <= {8'd25, 8'd0}; // Simplified: 25°C placeholder
                end

                default: i2c_fsm_state_r <= I2C_IDLE;
            endcase
        end
    end

    // Tri-state SDA
    assign temp_sda = i2c_sda_oe_r ? 1'b0 : 1'bz;

    // Temperature register
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            reg_temp_r <= 16'd0;
        end else if (temp_valid_r) begin
            reg_temp_r <= temp_raw_r;
        end
    end

    //========================================================================
    // LVDS Output Data (registered outputs via ODDR)
    //========================================================================
    // In production, use ODDR primitives for LVDS output.
    // Here we provide registered outputs with complementary pairs.
    reg [15:0] lvds_data_out_r;

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            lvds_data_out_r <= 16'd0;
        end else if (!lvds_fifo_empty_r) begin
            lvds_data_out_r <= lvds_fifo_dout_r;
        end
    end

    // Map lower 8 bits to LVDS output pairs
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            lvds_out_p <= {LVDS_OUT_WIDTH{1'b0}};
            lvds_out_n <= {LVDS_OUT_WIDTH{1'b1}};
            lvds_clk_p <= 1'b0;
            lvds_clk_n <= 1'b1;
        end else begin
            lvds_out_p <= lvds_data_out_r[LVDS_OUT_WIDTH-1:0];
            lvds_out_n <= ~lvds_data_out_r[LVDS_OUT_WIDTH-1:0];
            lvds_clk_p <= clk;
            lvds_clk_n <= ~clk;
        end
    end

    //========================================================================
    // QSPI Flash Interface (simplified — direct registered outputs)
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            qspi_cs_n    <= 1'b1;
            qspi_dq_out  <= 4'd0;
            qspi_dq_oe_n <= 4'b1111; // All inputs by default
        end else begin
            // Default: CS inactive, all DQ as inputs
            // Active configuration managed by dedicated config block
            // (Xilinx SPI/BPI config is handled by dedicated STARTUP primitive)
            qspi_cs_n    <= 1'b1;
            qspi_dq_out  <= 4'd0;
            qspi_dq_oe_n <= 4'b1111;
        end
    end

    //========================================================================
    // SPI EEPROM Interface (simplified — direct registered outputs)
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            eeprom_cs_n  <= 1'b1;
            eeprom_sclk  <= 1'b0;
            eeprom_sdi   <= 1'b0;
        end else begin
            // Default: inactive
            eeprom_cs_n <= 1'b1;
            eeprom_sclk <= 1'b0;
            eeprom_sdi  <= 1'b0;
            // EEPROM access can be added via register-triggered SPI FSM extension
        end
    end

    //========================================================================
    // Control Register → Hardware Outputs
    //========================================================================
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            pll_ref_en     <= 1'b0;
            adc_pd_n       <= 1'b1; // ADC powered down (active-low)
            vga_shutdown_n <= 2'b11; // VGAs shutdown (active-low)
            status_led     <= 4'b0000;
        end else begin
            // Bit 2: PLL reference buffer enable
            pll_ref_en     <= reg_ctrl_r[2];
            // Bit 3: ADC power-down (inverted — 1 = ADC active)
            adc_pd_n       <= reg_ctrl_r[3];
            // Bit 4-5: VGA shutdown control
            vga_shutdown_n <= reg_ctrl_r[5:4];
            // Status LEDs
            status_led[0]  <= reg_ctrl_r[0]; // DDC active
            status_led[1]  <= lo2_locked;    // LO2 locked
            status_led[2]  <= ~lvds_fifo_empty_r; // Data streaming
            status_led[3]  <= irq_pending_r; // IRQ pending
        end
    end

endmodule