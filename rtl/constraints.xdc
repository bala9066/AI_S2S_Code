# Constraints : Rf Receiver
# Target      : xc7a35tcpg236-1 (Artix-7)
# Clock       : 50 MHz

create_clock -period 20.0 -name clk [get_ports clk]

set_input_delay  -clock clk -max 4.0 [get_ports {reg_addr reg_wdata reg_wr reg_rd}]
set_input_delay  -clock clk -min 0.5 [get_ports {reg_addr reg_wdata reg_wr reg_rd}]
set_output_delay -clock clk -max 4.0 [get_ports {reg_rdata busy error_flag irq_out}]
set_output_delay -clock clk -min 0.5 [get_ports {reg_rdata busy error_flag irq_out}]
set_false_path -from [get_ports rst_n]

set_property PACKAGE_PIN W5  [get_ports clk]
set_property IOSTANDARD  LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN V17 [get_ports rst_n]
set_property IOSTANDARD  LVCMOS33 [get_ports rst_n]

# SPI pins
set_output_delay -clock clk -max 3.0 [get_ports {spi_clk spi_mosi spi_cs_n}]
set_input_delay  -clock clk -max 4.0 [get_ports spi_miso]

# ADC LVDS data
set_input_delay  -clock clk -max 2.0 [get_ports {adc_data adc_data_valid}]