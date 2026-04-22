# Constraints : hfuf
# Target      : xc7a35tcpg236-1 (Artix-7)
# Clock       : 100 MHz

create_clock -period 10.0 -name clk [get_ports clk]

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

# ADC LVDS data — dedicated sample clock from front-end
create_clock -period 10.0 -name adc_sample_clk [get_ports adc_data_valid]
set_input_delay  -clock adc_sample_clk -max 2.0 [get_ports {adc_data adc_data_valid}]
set_clock_groups -asynchronous -group clk -group adc_sample_clk
set_false_path -from [get_clocks adc_sample_clk] -to [get_clocks clk]
set_false_path -from [get_clocks clk] -to [get_clocks adc_sample_clk]

# SPI is a slow interface but its MISO is async relative to clk —
# declare the false path so Vivado doesn't chase setup/hold across it.
set_false_path -from [get_ports spi_miso] -to [get_clocks clk]