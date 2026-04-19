/**
 * @file constraints.xdc
 * @brief Xilinx Vivado constraints for dgh radar RF front-end receiver FPGA
 * @author DGH Project Team
 * @version 0V01
 * @date 19.04.2026
 * 
 * This file contains all physical constraints for the dgh FPGA implementation,
 * including pin assignments, clock definitions, and timing constraints.
 */

# Create clock for the 125 MHz system clock
create_clock -name clk_125mhz -period 8.0 [get_ports clk_125mhz]

# Set input delays for external signals
set_input_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {uart_rx}]
set_input_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {temp_alert}]
set_input_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {power_fault}]
set_input_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {gpio_in[*]}]
set_input_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {reg_addr[*]}]
set_input_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {reg_wdata[*]}]
set_input_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {reg_wr}]
set_input_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {reg_rd}]
set_input_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {spi_miso}]

# Set output delays for external signals
set_output_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {uart_tx}]
set_output_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {rf_channel_0_enable}]
set_output_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {rf_channel_1_enable}]
set_output_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {rf_channel_2_enable}]
set_output_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {rf_channel_3_enable}]
set_output_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {gpio_out[*]}]
set_output_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {reg_rdata[*]}]
set_output_delay -clock clk_125mhz -add_delay -max 10.0 [get_ports {irq_status[*]}]

# Set false path for asynchronous signals
set_false_path -from [get_ports rst_n] -to [all_outputs]
set_false_path -from [get_ports rst_n] -to [all_inputs]
set_false_path -from [get_ports {temp_alert power_fault}] -to [all_outputs]
set_false_path -from [get_ports {temp_alert power_fault}] -to [all_inputs]

# Set max frequency constraint for internal paths
set_max_delay -from [all_inputs] -to [all_outputs] 8.0

# Set multicycle paths for non-critical operations
set_multicycle_path -setup 2 -from [get_registers] -to [get_registers]
set_multicycle_path -hold 1 -from [get_registers] -to [get_registers]

# Pin assignments for clock and reset (minimum required)
set_property PACKAGE_PIN E3 [get_ports clk_125mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_125mhz]

set_property PACKAGE_PIN D12 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

# Pin assignments for UART interface
set_property PACKAGE_PIN B4 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]

set_property PACKAGE_PIN A4 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]

# Pin assignments for I2C interface
set_property PACKAGE_PIN C4 [get_ports i2c_scl]
set_property IOSTANDARD LVCMOS33 [get_ports i2c_scl]

set_property PACKAGE_PIN C5 [get_ports i2c_sda]
set_property IOSTANDARD LVCMOS33 [get_ports i2c_sda]

# Pin assignments for SPI interface
set_property PACKAGE_PIN D6 [get_ports spi_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sclk]

set_property PACKAGE_PIN E6 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]

set_property PACKAGE_PIN E7 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports spi_miso]

set_property PACKAGE_PIN D7 [get_ports spi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports spi_cs_n]

# Pin assignments for RF channel control
set_property PACKAGE_PIN F6 [get_ports rf_channel_0_enable]
set_property IOSTANDARD LVCMOS33 [get_ports rf_channel_0_enable]

set_property PACKAGE_PIN G6 [get_ports rf_channel_1_enable]
set_property IOSTANDARD LVCMOS33 [get_ports rf_channel_1_enable]

set_property PACKAGE_PIN F7 [get_ports rf_channel_2_enable]
set_property IOSTANDARD LVCMOS33 [get_ports rf_channel_2_enable]

set_property PACKAGE_PIN G7 [get_ports rf_channel_3_enable]
set_property IOSTANDARD LVCMOS33 [get_ports rf_channel_3_enable]

# Pin assignments for GPIO interface
set_property PACKAGE_PIN A5 [get_ports gpio_in[0]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_in[0]]

set_property PACKAGE_PIN A6 [get_ports gpio_in[1]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_in[1]]

set_property PACKAGE_PIN A7 [get_ports gpio_in[2]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_in[2]]

set_property PACKAGE_PIN B7 [get_ports gpio_in[3]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_in[3]]

set_property PACKAGE_PIN B6 [get_ports gpio_in[4]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_in[4]]

set_property PACKAGE_PIN A8 [get_ports gpio_in[5]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_in[5]]

set_property PACKAGE_PIN A9 [get_ports gpio_in[6]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_in[6]]

set_property PACKAGE_PIN B9 [get_ports gpio_in[7]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_in[7]]

set_property PACKAGE_PIN C8 [get_ports gpio_out[0]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_out[0]]

set_property PACKAGE_PIN D8 [get_ports gpio_out[1]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_out[1]]

set_property PACKAGE_PIN E8 [get_ports gpio_out[2]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_out[2]]

set_property PACKAGE_PIN F8 [get_ports gpio_out[3]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_out[3]]

set_property PACKAGE_PIN C9 [get_ports gpio_out[4]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_out[4]]

set_property PACKAGE_PIN D9 [get_ports gpio_out[5]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_out[5]]

set_property PACKAGE_PIN E9 [get_ports gpio_out[6]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_out[6]]

set_property PACKAGE_PIN F9 [get_ports gpio_out[7]]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_out[7]]

# Pin assignments for status inputs
set_property PACKAGE_PIN G8 [get_ports temp_alert]
set_property IOSTANDARD LVCMOS33 [get_ports temp_alert]

set_property PACKAGE_PIN G9 [get_ports power_fault]
set_property IOSTANDARD LVCMOS33 [get_ports power_fault]

# Pin assignments for register interface
set_property PACKAGE_PIN H8 [get_ports reg_addr[0]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_addr[0]]

set_property PACKAGE_PIN H9 [get_ports reg_addr[1]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_addr[1]]

set_property PACKAGE_PIN J8 [get_ports reg_addr[2]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_addr[2]]

set_property PACKAGE_PIN J9 [get_ports reg_addr[3]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_addr[3]]

set_property PACKAGE_PIN K8 [get_ports reg_addr[4]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_addr[4]]

set_property PACKAGE_PIN K9 [get_ports reg_addr[5]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_addr[5]]

set_property PACKAGE_PIN L8 [get_ports reg_addr[6]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_addr[6]]

set_property PACKAGE_PIN L9 [get_ports reg_addr[7]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_addr[7]]

set_property PACKAGE_PIN T8 [get_ports reg_wdata[0]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_wdata[0]]

set_property PACKAGE_PIN T9 [get_ports reg_wdata[1]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_wdata[1]]

set_property PACKAGE_PIN U8 [get_ports reg_wdata[2]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_wdata[2]]

set_property PACKAGE_PIN U9 [get_ports reg_wdata[3]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_wdata[3]]

set_property PACKAGE_PIN V8 [get_ports reg_wdata[4]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_wdata[4]]

set_property PACKAGE_PIN V9 [get_ports reg_wdata[5]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_wdata[5]]

set_property PACKAGE_PIN W8 [get_ports reg_wdata[6]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_wdata[6]]

set_property PACKAGE_PIN W9 [get_ports reg_wdata[7]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_wdata[7]]

set_property PACKAGE_PIN T10 [get_ports reg_rdata[0]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rdata[0]]

set_property PACKAGE_PIN U10 [get_ports reg_rdata[1]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rdata[1]]

set_property PACKAGE_PIN V10 [get_ports reg_rdata[2]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rdata[2]]

set_property PACKAGE_PIN W10 [get_ports reg_rdata[3]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rdata[3]]

set_property PACKAGE_PIN Y8 [get_ports reg_rdata[4]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rdata[4]]

set_property PACKAGE_PIN Y9 [get_ports reg_rdata[5]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rdata[5]]

set_property PACKAGE_PIN Y10 [get_ports reg_rdata[6]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rdata[6]]

set_property PACKAGE_PIN Y11 [get_ports reg_rdata[7]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rdata[7]]

set_property PACKAGE_PIN U11 [get_ports reg_wr]
set_property IOSTANDARD LVCMOS33 [get_ports reg_wr]

set_property PACKAGE_PIN V11 [get_ports reg_rd]
set_property IOSTANDARD LVCMOS33 [get_ports reg_rd]

# Pin assignments for interrupt outputs
set_property PACKAGE_PIN W11 [get_ports irq_status[0]]
set_property IOSTANDARD LVCMOS33 [get_ports irq_status[0]]

set_property PACKAGE_PIN Y12 [get_ports irq_status[1]]
set_property IOSTANDARD LVCMOS33 [get_ports irq_status[1]]

set_property PACKAGE_PIN W12 [get_ports irq_status[2]]
set_property IOSTANDARD LVCMOS33 [get_ports irq_status[2]]

set_property PACKAGE_PIN Y13 [get_ports irq_status[3]]
set_property IOSTANDARD LVCMOS33 [get_ports irq_status[3]]

# Set global settings
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# Disable unused pins
set_property IOTYPE LVCMOS33 [get_unused_pins]

# Set drive strength for high fanout signals
set_property MAX_FANOUT 100 [get_nets {rf_channel_*_enable}]
set_property MAX_FANOUT 50 [get_nets {gpio_out[*]}]

# Set clock uncertainty
set_clock_uncertainty -setup 0.1 [get_clocks clk_125mhz]
set_clock_uncertainty -hold 0.05 [get_clocks clk_125mhz]

# Set voltage levels
set_property IO_BUFFER_TYPE NONE [get_ports {i2c_scl i2c_sda}]