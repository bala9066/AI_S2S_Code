// ============================================================
// Module  : yhh_top
// Project : yhh
// Clock   : 100 MHz (10.0 ns period)
// Source  : Hardware Pipeline v2 (auto-generated from GLR)
// ============================================================
`timescale 1ns / 1ps

module yhh_top (
    input  wire              clk,           // System clock
    input  wire              rst_n,         // Active-low synchronous reset

    // Register bus interface
    input  wire [15:0]       reg_addr,      // Address
    input  wire [15:0]       reg_wdata,     // Write data
    output reg  [15:0]       reg_rdata,     // Read data
    input  wire              reg_wr,        // Write strobe
    input  wire              reg_rd,        // Read strobe

    // Interrupt
    output wire              irq_out,       // Active-high interrupt

    // SPI master (to ADC / PLL / DAC)
    output reg              spi_clk,
    output reg              spi_mosi,
    input  wire             spi_miso,
    output reg  [3:0]       spi_cs_n,      // Up to 4 slaves

    // UART debug port
    input  wire             uart_rxd,
    output wire             uart_txd,

    // GPIO
    output reg  [7:0]       gpio_out,
    input  wire [7:0]       gpio_in,

    // Status
    output wire             busy,
    output wire             error_flag
);

    // Parameters
    localparam VERSION_VAL  = 16'h0100;
    localparam DATA_WIDTH   = 16;
    localparam CLK_FREQ_MHZ = 100;

    // ---- Register file ----
    reg [15:0] ctrl_r;  // Control: [0] enable, [1] start, [2] continuous, [3] irq_en
    reg [15:0] scratch_r;  // Scratch register for diagnostics
    reg [15:0] config0_r;  // Configuration 0: sample count / mode
    reg [15:0] config1_r;  // Configuration 1: threshold / gain
    reg [15:0] irq_mask_r;  // Interrupt mask (1=enabled)
    reg [15:0] irq_status_r;  // Interrupt status (write-1-to-clear)
    reg [15:0] spi_ctrl_r;  // SPI control: [2:0] slave_sel, [3] start, [7:4] clk_div
    reg [15:0] spi_txdata_r;  // SPI TX data
    reg [15:0] status_r;

    // ---- FSM: Acquisition Controller ----
    localparam S_IDLE    = 3'd0,
               S_ARM     = 3'd1,
               S_ACQUIRE = 3'd2,
               S_PROCESS = 3'd3,
               S_DONE    = 3'd4,
               S_ERROR   = 3'd5;
    reg [2:0] acq_state_r, acq_next;
    reg [15:0] sample_cnt_r;

    // ---- FSM: SPI Master Controller ----
    localparam SPI_IDLE  = 2'd0,
               SPI_SHIFT = 2'd1,
               SPI_DONE  = 2'd2;
    reg [1:0]  spi_state_r;
    reg [4:0]  spi_bit_cnt_r;
    reg [15:0] spi_shift_r;
    reg [15:0] spi_rxdata_r;
    reg        spi_busy_r;
    reg [7:0]  spi_clk_div_r;

    // ---- Interrupt logic ----
    wire [15:0] irq_pending = irq_status_r & irq_mask_r;
    assign irq_out = |irq_pending;

    assign busy       = (acq_state_r != S_IDLE);
    assign error_flag = (acq_state_r == S_ERROR);

    // ---- Register Write ----
    always @(posedge clk) begin
        if (!rst_n) begin
            ctrl_r <= 16'h0000;
            scratch_r <= 16'h0000;
            config0_r <= 16'h0001;
            config1_r <= 16'h0000;
            irq_mask_r <= 16'hFFFF;
            irq_status_r <= 16'h0000;
            spi_ctrl_r <= 16'h0000;
            spi_txdata_r <= 16'h0000;
        end else if (reg_wr) begin
            case (reg_addr[11:0])
                12'h000: ctrl_r <= reg_wdata;
                12'h003: scratch_r <= reg_wdata;
                12'h004: config0_r <= reg_wdata;
                12'h005: config1_r <= reg_wdata;
                12'hF00: irq_mask_r <= reg_wdata;
                12'hF01: irq_status_r <= irq_status_r & ~reg_wdata; // W1C
                12'h020: spi_ctrl_r <= reg_wdata;
                12'h021: spi_txdata_r <= reg_wdata;
                default: ;
            endcase
        end
    end

    // ---- Register Read ----
    always @(posedge clk) begin
        if (!rst_n)
            reg_rdata <= 16'h0000;
        else if (reg_rd) begin
            case (reg_addr[11:0])
                12'h000: reg_rdata <= ctrl_r;
                12'h001: reg_rdata <= status_r;
                12'h002: reg_rdata <= VERSION_VAL;
                12'h003: reg_rdata <= scratch_r;
                12'h004: reg_rdata <= config0_r;
                12'h005: reg_rdata <= config1_r;
                12'hF00: reg_rdata <= irq_mask_r;
                12'hF01: reg_rdata <= irq_status_r;
                12'h020: reg_rdata <= spi_ctrl_r;
                12'h021: reg_rdata <= spi_txdata_r;
                12'h022: reg_rdata <= spi_rxdata_r;
                12'h023: reg_rdata <= {14'b0, ~spi_busy_r, spi_busy_r};
                default: reg_rdata <= 16'hDEAD;
            endcase
        end
    end

    // ---- Status register ----
    always @(posedge clk) begin
        if (!rst_n)
            status_r <= 16'h0000;
        else
            status_r <= {14'b0, error_flag, busy};
    end

    // ---- Acquisition Controller FSM ----
    always @(posedge clk) begin
        if (!rst_n) begin
            acq_state_r  <= S_IDLE;
            sample_cnt_r <= 16'd0;
        end else begin
            case (acq_state_r)
                S_IDLE: begin
                    sample_cnt_r <= 16'd0;
                    if (ctrl_r[1])  // START bit
                        acq_state_r <= S_ARM;
                end
                S_ARM: begin
                    acq_state_r <= S_ACQUIRE;
                end
                S_ACQUIRE: begin
                    sample_cnt_r <= sample_cnt_r + 1;
                    if (sample_cnt_r >= config0_r)
                        acq_state_r <= S_PROCESS;
                end
                S_PROCESS: begin
                    irq_status_r[0] <= 1'b1;  // Acquisition complete IRQ
                    acq_state_r <= S_DONE;
                end
                S_DONE: begin
                    if (!ctrl_r[1])  // START deasserted
                        acq_state_r <= ctrl_r[2] ? S_ARM : S_IDLE;  // continuous mode
                end
                S_ERROR: begin
                    if (!ctrl_r[0])  // ENABLE deasserted to clear error
                        acq_state_r <= S_IDLE;
                end
                default: acq_state_r <= S_IDLE;
            endcase
        end
    end

    // ---- SPI Master FSM ----
    always @(posedge clk) begin
        if (!rst_n) begin
            spi_state_r   <= SPI_IDLE;
            spi_bit_cnt_r <= 5'd0;
            spi_shift_r   <= 16'd0;
            spi_rxdata_r  <= 16'd0;
            spi_busy_r    <= 1'b0;
            spi_clk       <= 1'b0;
            spi_mosi      <= 1'b0;
            spi_cs_n      <= 4'hF;
        end else begin
            case (spi_state_r)
                SPI_IDLE: begin
                    spi_busy_r <= 1'b0;
                    spi_cs_n   <= 4'hF;
                    spi_clk    <= 1'b0;
                    if (spi_ctrl_r[3]) begin  // SPI start
                        spi_state_r   <= SPI_SHIFT;
                        spi_shift_r   <= spi_txdata_r;
                        spi_bit_cnt_r <= 5'd15;
                        spi_busy_r    <= 1'b1;
                        spi_cs_n[spi_ctrl_r[2:0]] <= 1'b0;
                    end
                end
                SPI_SHIFT: begin
                    spi_clk  <= ~spi_clk;
                    if (spi_clk) begin  // falling edge: shift
                        spi_mosi    <= spi_shift_r[15];
                        spi_shift_r <= {spi_shift_r[14:0], spi_miso};
                        if (spi_bit_cnt_r == 0)
                            spi_state_r <= SPI_DONE;
                        else
                            spi_bit_cnt_r <= spi_bit_cnt_r - 1;
                    end
                end
                SPI_DONE: begin
                    spi_rxdata_r     <= spi_shift_r;
                    spi_cs_n         <= 4'hF;
                    spi_clk          <= 1'b0;
                    irq_status_r[1]  <= 1'b1;  // SPI done IRQ
                    spi_state_r      <= SPI_IDLE;
                end
                default: spi_state_r <= SPI_IDLE;
            endcase
        end
    end

    // ---- GPIO ----
    always @(posedge clk)
        if (!rst_n) gpio_out <= 8'h00;
        else        gpio_out <= config1_r[7:0];

    // ---- UART stub (active low TX idle) ----
    assign uart_txd = 1'b1;  // Idle high — implement TX FIFO in next iteration

endmodule