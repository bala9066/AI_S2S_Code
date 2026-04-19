# ============================================================================
# XDC CONSTRAINTS FILE FOR HH FPGA TOP MODULE
# ============================================================================
# Project: hh
# Device: Xilinx XC7K70T-1FBG676C
# Clock: 100 MHz
#
# This file contains physical constraints for the HH EW/ELINT front-end receiver
# FPGA implementation including clock definitions, I/O timing, and pin assignments.
# =============================================================================

# Create system clock
create_clock -name clk -period 10.0 -add [get_ports clk]

# Set input delays for asynchronous signals
set_input_delay -clock clk -max 2.0 [get_ports rst_n]
set_input_delay -clock clk -max 2.0 [get_ports uart_rxd]
set_input_delay -clock clk -max 2.0 [get_ports spi_miso]
set_input_delay -clock clk -max 2.0 [get_ports jtag_tdo]
set_input_delay -clock clk -max 2.0 [get_ports temp_alert]
set_input_delay -clock clk -max 2.0 [get_ports rf_status_ch1_1]
set_input_delay -clock clk -max 2.0 [get_ports rf_status_ch2_1]
set_input_delay -clock clk -max 2.0 [get_ports rf_status_ch3_1]
set_input_delay -clock clk -max 2.0 [get_ports rf_status_ch4_1]
set_input_delay -clock clk -max 2.0 [get_ports rf_status_ch1_2]
set_input_delay -clock clk -max 2.0 [get_ports rf_status_ch2_2]
set_input_delay -clock clk -max 2.0 [get_ports rf_status_ch3_2]
set_input_delay -clock clk -max 2.0 [get_ports rf_status_ch4_2]

# Set output delays
set_output_delay -clock clk -max 2.0 [get_ports uart_txd]
set_output_delay -clock clk -max 2.0 [get_ports spi_sclk]
set_output_delay -clock clk -max 2.0 [get_ports spi_mosi]
set_output_delay -clock clk -max 2.0 [get_ports spi_cs_flash]
set_output_delay -clock clk -max 2.0 [get_ports spi_cs_eeprom]
set_output_delay -clock clk -max 2.0 [get_ports i2c_scl]
set_output_delay -clock clk -max 2.0 [get_ports i2c_sda]
set_output_delay -clock clk -max 2.0 [get_ports jtag_tms]
set_output_delay -clock clk -max 2.0 [get_ports jtag_tck]
set_output_delay -clock clk -max 2.0 [get_ports jtag_tdi]
set_output_delay -clock clk -max 2.0 [get_ports lna_bias_en_1]
set_output_delay -clock clk -max 2.0 [get_ports lna_bias_en_2]
set_output_delay -clock clk -max 2.0 [get_ports lna_bias_v1]
set_output_delay -clock clk -max 2.0 [get_ports lna_bias_v2]
set_output_delay -clock clk -max 2.0 [get_ports power_mon_en]
set_output_delay -clock clk -max 2.0 [get_ports bist_active]
set_output_delay -clock clk -max 2.0 [get_ports bist_pass]

# Set false paths for asynchronous resets and static configuration
set_false_path -from [get_ports rst_n] -to [get_registers]
set_false_path -to [get_ports rst_n] -from [get_registers]
set_false_path -from [get_ports temp_alert] -to [get_registers]
set_false_path -from [get_ports rf_status_ch1_1] -to [get_registers]
set_false_path -from [get_ports rf_status_ch2_1] -to [get_registers]
set_false_path -from [get_ports rf_status_ch3_1] -to [get_registers]
set_false_path -from [get_ports rf_status_ch4_1] -to [get_registers]
set_false_path -from [get_ports rf_status_ch1_2] -to [get_registers]
set_false_path -from [get_ports rf_status_ch2_2] -to [get_registers]
set_false_path -from [get_ports rf_status_ch3_2] -to [get_registers]
set_false_path -from [get_ports rf_status_ch4_2] -to [get_registers]

# Pin assignments (package pins for XC7K70T-1FBG676C)
# Clock pin
set_property PACKAGE_PIN E18 [get_ports clk]

# Reset pin
set_property PACKAGE_PIN D18 [get_ports rst_n]

# UART interface pins
set_property PACKAGE_PIN B20 [get_ports uart_txd]
set_property PACKAGE_PIN A20 [get_ports uart_rxd]

# SPI interface pins
set_property PACKAGE_PIN F20 [get_ports spi_sclk]
set_property PACKAGE_PIN E19 [get_ports spi_mosi]
set_property PACKAGE_PIN F19 [get_ports spi_miso]
set_property PACKAGE_PIN G19 [get_ports spi_cs_flash]
set_property PACKAGE_PIN H19 [get_ports spi_cs_eeprom]

# I2C interface pins
set_property PACKAGE_PIN F21 [get_ports i2c_scl]
set_property PACKAGE_PIN G21 [get_ports i2c_sda]

# JTAG interface pins
set_property PACKAGE_PIN K17 [get_ports jtag_tms]
set_property PACKAGE_PIN K18 [get_ports jtag_tck]
set_property PACKAGE_PIN L18 [get_ports jtag_tdi]
set_property PACKAGE_PIN M18 [get_ports jtag_tdo]

# LNA bias control pins
set_property PACKAGE_PIN C20 [get_ports lna_bias_en_1]
set_property PACKAGE_PIN B19 [get_ports lna_bias_en_2]
set_property PACKAGE_PIN C19 [get_ports {lna_bias_v1[7]}]
set_property PACKAGE_PIN D19 [get_ports {lna_bias_v1[6]}]
set_property PACKAGE_PIN E18 [get_ports {lna_bias_v1[5]}]
set_property PACKAGE_PIN F18 [get_ports {lna_bias_v1[4]}]
set_property PACKAGE_PIN G18 [get_ports {lna_bias_v1[3]}]
set_property PACKAGE_PIN H18 [get_ports {lna_bias_v1[2]}]
set_property PACKAGE_PIN J18 [get_ports {lna_bias_v1[1]}]
set_property PACKAGE_PIN J19 [get_ports {lna_bias_v1[0]}]
set_property PACKAGE_PIN C18 [get_ports {lna_bias_v2[7]}]
set_property PACKAGE_PIN D18 [get_ports {lna_bias_v2[6]}]
set_property PACKAGE_PIN E17 [get_ports {lna_bias_v2[5]}]
set_property PACKAGE_PIN F17 [get_ports {lna_bias_v2[4]}]
set_property PACKAGE_PIN G17 [get_ports {lna_bias_v2[3]}]
set_property PACKAGE_PIN H17 [get_ports {lna_bias_v2[2]}]
set_property PACKAGE_PIN K17 [get_ports {lna_bias_v2[1]}]
set_property PACKAGE_PIN L17 [get_ports {lna_bias_v2[0]}]

# Power monitoring pin
set_property PACKAGE_PIN K16 [get_ports power_mon_en]

# Temperature alert pin
set_property PACKAGE_PIN J16 [get_ports temp_alert]

# RF status pins
set_property PACKAGE_PIN A17 [get_ports rf_status_ch1_1]
set_property PACKAGE_PIN B17 [get_ports rf_status_ch2_1]
set_property PACKAGE_PIN C17 [get_ports rf_status_ch3_1]
set_property PACKAGE_PIN D17 [get_ports rf_status_ch4_1]
set_property PACKAGE_PIN A16 [get_ports rf_status_ch1_2]
set_property PACKAGE_PIN B16 [get_ports rf_status_ch2_2]
set_property PACKAGE_PIN C16 [get_ports rf_status_ch3_2]
set_property PACKAGE_PIN D16 [get_ports rf_status_ch4_2]

# BIST interface pins
set_property PACKAGE_PIN E16 [get_ports bist_active]
set_property PACKAGE_PIN F16 [get_ports bist_pass]

# Set I/O standards
set_property IOSTANDARD LVCMOS18 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS18 [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS18 [get_ports spi_sclk]
set_property IOSTANDARD LVCMOS18 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS18 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS18 [get_ports spi_cs_flash]
set_property IOSTANDARD LVCMOS18 [get_ports spi_cs_eeprom]
set_property IOSTANDARD LVCMOS18 [get_ports i2c_scl]
set_property IOSTANDARD LVCMOS18 [get_ports i2c_sda]
set_property IOSTANDARD LVCMOS18 [get_ports jtag_tms]
set_property IOSTANDARD LVCMOS18 [get_ports jtag_tck]
set_property IOSTANDARD LVCMOS18 [get_ports jtag_tdi]
set_property IOSTANDARD LVCMOS18 [get_ports jtag_tdo]
set_property IOSTANDARD LVCMOS18 [get_ports lna_bias_en_1]
set_property IOSTANDARD LVCMOS18 [get_ports lna_bias_en_2]
set_property IOSTANDARD LVCMOS18 [get_ports {lna_bias_v1[7:0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {lna_bias_v2[7:0]}]
set_property IOSTANDARD LVCMOS18 [get_ports power_mon_en]
set_property IOSTANDARD LVCMOS18 [get_ports temp_alert]
set_property IOSTANDARD LVCMOS18 [get_ports {rf_status_ch1_1}]
set_property IOSTANDARD LVCMOS18 [get_ports {rf_status_ch2_1}]
set_property IOSTANDARD LVCMOS18 [get_ports {rf_status_ch3_1}]
set_property IOSTANDARD LVCMOS18 [get_ports {rf_status_ch4_1}]
set_property IOSTANDARD LVCMOS18 [get_ports {rf_status_ch1_2}]
set_property IOSTANDARD LVCMOS18 [get_ports {rf_status_ch2_2}]
set_property IOSTANDARD LVCMOS18 [get_ports {rf_status_ch3_2}]
set_property IOSTANDARD LVCMOS18 [get_ports {rf_status_ch4_2}]
set_property IOSTANDARD LVCMOS18 [get_ports bist_active]
set_property IOSTANDARD LVCMOS18 [get_ports bist_pass]

# Set pull-up resistors for bidirectional pins
set_property PULLUP [get_ports i2c_sda]

# Set clock uncertainty
set_clock_uncertainty -from [get_clocks clk] -to [get_clocks clk] 0.5

# Set output drive strength
set_property DRIVE 12 [get_ports uart_txd]
set_property DRIVE 12 [get_ports spi_sclk]
set_property DRIVE 12 [get_ports spi_mosi]
set_property DRIVE 12 [get_ports spi_cs_flash]
set_property DRIVE 12 [get_ports spi_cs_eeprom]
set_property DRIVE 12 [get_ports i2c_scl]
set_property DRIVE 12 [get_ports jtag_tms]
set_property DRIVE 12 [get_ports jtag_tck]
set_property DRIVE 12 [get_ports jtag_tdi]
set_property DRIVE 12 [get_ports lna_bias_en_1]
set_property DRIVE 12 [get_ports lna_bias_en_2]
set_property DRIVE 12 [get_ports power_mon_en]
set_property DRIVE 12 [get_ports bist_active]
set_property DRIVE 12 [get_ports bist_pass]

# Set input buffer types
set_property IBUF_LVCMOS18 [get_ports rst_n]
set_property IBUF_LVCMOS18 [get_ports uart_rxd]
set_property IBUF_LVCMOS18 [get_ports spi_miso]
set_property IBUF_LVCMOS18 [get_ports jtag_tdo]
set_property IBUF_LVCMOS18 [get_ports temp_alert]
set_property IBUF_LVCMOS18 [get_ports rf_status_ch1_1]
set_property IBUF_LVCMOS18 [get_ports rf_status_ch2_1]
set_property IBUF_LVCMOS18 [get_ports rf_status_ch3_1]
set_property IBUF_LVCMOS18 [get_ports rf_status_ch4_1]
set_property IBUF_LVCMOS18 [get_ports rf_status_ch1_2]
set_property IBUF_LVCMOS18 [get_ports rf_status_ch2_2]
set_property IBUF_LVCMOS18 [get_ports rf_status_ch3_2]
set_property IBUF_LVCMOS18 [get_ports rf_status_ch4_2]