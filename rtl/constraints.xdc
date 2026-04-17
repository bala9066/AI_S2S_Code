# ============================================================
# Constraints : jhf
# Target      : xc7a35tcpg236-1 (Artix-7)
# Tool        : Vivado 2023.x
# NOTE        : Re-run Phase 7 for full pin assignments
# ============================================================

# Primary clock (100 MHz — adjust to your board)
create_clock -period 10.000 -name clk [get_ports clk]

# Input / output delays (10 ns default — refine after STA)
set_input_delay  -clock clk -max 4.0 [get_ports {reg_addr reg_wdata reg_wr reg_rd}]
set_input_delay  -clock clk -min 0.5 [get_ports {reg_addr reg_wdata reg_wr reg_rd}]
set_output_delay -clock clk -max 4.0 [get_ports {reg_rdata busy error_flag}]
set_output_delay -clock clk -min 0.5 [get_ports {reg_rdata busy error_flag}]

# False path on async reset
set_false_path -from [get_ports rst_n]

# Pin assignments (example Artix-7 — update for your board)
set_property PACKAGE_PIN W5  [get_ports clk]
set_property IOSTANDARD  LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN V17 [get_ports rst_n]
set_property IOSTANDARD  LVCMOS33 [get_ports rst_n]
