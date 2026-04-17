// ============================================================
// Module  : jhf_top
// Project : jhf
// Source  : Hardware Pipeline v2 (skeleton fallback)
// NOTE    : Re-run Phase 7 for AI-generated RTL
// ============================================================
`timescale 1ns / 1ps

module jhf_top (
    input  wire        clk,       // System clock
    input  wire        rst_n,     // Active-low synchronous reset

    // Register bus (16-bit UART interface)
    input  wire [15:0] reg_addr,  // Address (bit15=R/W#)
    input  wire [15:0] reg_wdata, // Write data
    output reg  [15:0] reg_rdata, // Read data
    input  wire        reg_wr,    // Write strobe
    input  wire        reg_rd,    // Read strobe

    // Status
    output reg         busy,
    output reg         error_flag
);

    // ----------------------------------------------------------
    // Parameters
    // ----------------------------------------------------------
    localparam VERSION = 16'h0100;  // v1.0

    // ----------------------------------------------------------
    // Internal registers
    // ----------------------------------------------------------
    reg [15:0] ctrl_r;
    reg [15:0] status_r;
    reg [15:0] scratch_r;
    reg [15:0] irq_mask_r;
    reg [15:0] irq_status_r;

    // ----------------------------------------------------------
    // Register Write
    // ----------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            ctrl_r      <= 16'h0000;
            scratch_r   <= 16'h0000;
            irq_mask_r  <= 16'hFFFF;
            irq_status_r<= 16'h0000;
        end else if (reg_wr) begin
            case (reg_addr[11:0])
                12'h000: ctrl_r       <= reg_wdata;
                12'h003: scratch_r    <= reg_wdata;
                12'hF00: irq_mask_r   <= reg_wdata;
                12'hF01: irq_status_r <= irq_status_r & ~reg_wdata; // W1C
                default: /* read-only */;
            endcase
        end
    end

    // ----------------------------------------------------------
    // Register Read
    // ----------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            reg_rdata <= 16'h0000;
        end else if (reg_rd) begin
            case (reg_addr[11:0])
                12'h000: reg_rdata <= ctrl_r;
                12'h001: reg_rdata <= status_r;
                12'h002: reg_rdata <= VERSION;
                12'h003: reg_rdata <= scratch_r;
                12'hF00: reg_rdata <= irq_mask_r;
                12'hF01: reg_rdata <= irq_status_r;
                default: reg_rdata <= 16'hDEAD;
            endcase
        end
    end

    // ----------------------------------------------------------
    // Status / busy
    // ----------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            busy       <= 1'b0;
            error_flag <= 1'b0;
            status_r   <= 16'h0000;
        end else begin
            busy       <= ctrl_r[0];
            error_flag <= 1'b0;
            status_r   <= {14'b0, error_flag, busy};
        end
    end

endmodule
