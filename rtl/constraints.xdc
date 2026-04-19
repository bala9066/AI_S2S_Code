# Xilinx Design Constraints (XDC) for gvng FPGA
# Target Device: xc7z020-1clg400c
# Clock: 125 MHz

# Create primary clock
create_clock -name clk -period 8.0 [get_ports {clk}]

# Set I/O delays for all interfaces
set_input_delay -clock clk -max 10.0 [get_ports {uart_rxd}]
set_output_delay -clock clk -max 10.0 [get_ports {uart_txd}]

set_input_delay -clock clk -max 10.0 [get_ports {spi_miso}]
set_output_delay -clock clk -max 10.0 [get_ports {spi_sclk}]
set_output_delay -clock clk -max 10.0 [get_ports {spi_mosi}]
set_output_delay -clock clk -max 10.0 [get_ports {spi_cs_n}]

set_input_delay -clock clk -max 10.0 [get_ports {jtag_tms}]
set_input_delay -clock clk -max 10.0 [get_ports {jtag_tck}]
set_input_delay -clock clk -max 10.0 [get_ports {jtag_tdi}]
set_output_delay -clock clk -max 10.0 [get_ports {jtag_tdo}]

set_input_delay -clock clk -max 10.0 [get_ports {temp_sensor_sda}]
set_input_delay -clock clk -max 10.0 [get_ports {power_mon_sda}]
set_input_delay -clock clk -max 10.0 [get_ports {flash_io0}]
set_input_delay -clock clk -max 10.0 [get_ports {flash_io1}]
set_input_delay -clock clk -max 10.0 [get_ports {flash_io2}]
set_input_delay -clock clk -max 10.0 [get_ports {flash_io3}]

# False paths for asynchronous signals
set_false_path -from [get_ports {rst_n}]
set_false_path -from [get_ports {jtag_tms}]
set_false_path -from [get_ports {jtag_tck}]
set_false_path -from [get_ports {jtag_tdi}]

# Clock groups
set_clock_groups -asynchronous -group {clk}

# Set package pins for critical signals
set_property PACKAGE_PIN E3 [get_ports {clk}]
set_property PACKAGE_PIN D3 [get_ports {rst_n}]
set_property PACKAGE_PIN C4 [get_ports {uart_rxd}]
set_property PACKAGE_PIN C5 [get_ports {uart_txd}]
set_property PACKAGE_PIN D6 [get_ports {spi_sclk}]
set_property PACKAGE_PIN B7 [get_ports {spi_mosi}]
set_property PACKAGE_PIN A7 [get_ports {spi_miso}]
set_property PACKAGE_PIN A6 [get_ports {spi_cs_n}]
set_property PACKAGE_PIN F5 [get_ports {i2c_scl}]
set_property PACKAGE_PIN E5 [get_ports {i2c_sda}]
set_property PACKAGE_PIN F6 [get_ports {temp_sensor_scl}]
set_property PACKAGE_PIN G6 [get_ports {temp_sensor_sda}]
set_property PACKAGE_PIN F7 [get_ports {power_mon_scl}]
set_property PACKAGE_PIN G7 [get_ports {power_mon_sda}]

# Set I/O standards
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst_n}]
set_property IOSTANDARD LVCMOS33 [get_ports {uart_rxd}]
set_property IOSTANDARD LVCMOS33 [get_ports {uart_txd}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_sclk}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_mosi}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_miso}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_cs_n}]
set_property IOSTANDARD LVCMOS33 [get_ports {i2c_scl}]
set_property IOSTANDARD LVCMOS33 [get_ports {i2c_sda}]
set_property IOSTANDARD LVCMOS33 [get_ports {temp_sensor_scl}]
set_property IOSTANDARD LVCMOS33 [get_ports {temp_sensor_sda}]
set_property IOSTANDARD LVCMOS33 [get_ports {power_mon_scl}]
set_property IOSTANDARD LVCMOS33 [get_ports {power_mon_sda}]
set_property IOSTANDARD LVCMOS33 [get_ports {jtag_tms}]
set_property IOSTANDARD LVCMOS33 [get_ports {jtag_tck}]
set_property IOSTANDARD LVCMOS33 [get_ports {jtag_tdi}]
set_property IOSTANDARD LVCMOS33 [get_ports {jtag_tdo}]

# Set multiple I/O standards
set_property IOSTANDARD LVCMOS33 [get_ports {rf_sw_ctl}]
set_property IOSTANDARD LVCMOS33 [get_ports {rf_sw_en}]
set_property IOSTANDARD LVCMOS33 [get_ports {lna_gain_en}]
set_property IOSTANDARD LVCMOS33 [get_ports {lna_gain_sel}]
set_property IOSTANDARD LVCMOS33 [get_ports {status_led}]
set_property IOSTANDARD LVCMOS33 [get_ports {fault_indicator}]

# Set properties for flash interface
set_property IOSTANDARD LVCMOS33 [get_ports {flash_cs_n}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_io0}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_io1}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_io2}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_io3}]

# Set drive strength for output pins
set_property DRIVE 12 [get_ports {uart_txd}]
set_property DRIVE 12 [get_ports {spi_sclk}]
set_property DRIVE 12 [get_ports {spi_mosi}]
set_property DRIVE 12 [get_ports {spi_cs_n}]
set_property DRIVE 12 [get_ports {i2c_scl}]
set_property DRIVE 12 [get_ports {temp_sensor_scl}]
set_property DRIVE 12 [get_ports {power_mon_scl}]
set_property DRIVE 12 [get_ports {rf_sw_ctl}]
set_property DRIVE 12 [get_ports {rf_sw_en}]
set_property DRIVE 12 [get_ports {lna_gain_en}]
set_property DRIVE 12 [get_ports {lna_gain_sel}]
set_property DRIVE 12 [get_ports {status_led}]
set_property DRIVE 12 [get_ports {fault_indicator}]
set_property DRIVE 12 [get_ports {flash_cs_n}]
set_property DRIVE 12 [get_ports {flash_clk}]

# Set input termination for critical pins
set_property IBUF_LVCMOS_IO [get_ports {uart_rxd}]
set_property IBUF_LVCMOS_IO [get_ports {spi_miso}]
set_property IBUF_LVCMOS_IO [get_ports {jtag_tms}]
set_property IBUF_LVCMOS_IO [get_ports {jtag_tck}]
set_property IBUF_LVCMOS_IO [get_ports {jtag_tdi}]
set_property IBUF_LVCMOS_IO [get_ports {temp_sensor_sda}]
set_property IBUF_LVCMOS_IO [get_ports {power_mon_sda}]
set_property IBUF_LVCMOS_IO [get_ports {flash_io0}]
set_property IBUF_LVCMOS_IO [get_ports {flash_io1}]
set_property IBUF_LVCMOS_IO [get_ports {flash_io2}]
set_property IBUF_LVCMOS_IO [get_ports {flash_io3}]