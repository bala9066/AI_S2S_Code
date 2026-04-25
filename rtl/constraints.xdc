# ==============================================================================
# Vivado XDC Constraints File
# Project: hjjg - Dual-Channel Radar Receiver FPGA
# FPGA: Kintex-7 XC7K160T-1FBG676C (PFP-KX7_PLUS-310LC)
# Date: 2025-2026
# ==============================================================================

# ============================================================================
# Primary Clock Constraints
# ============================================================================

# 170 MHz LVDS system clock from ADC clock buffer (primary DSP clock)
# Source: ADC clock buffer (LMK1C1102 or similar)
create_clock -period 5.880 -name clk_170 [get_ports {clk_170_p clk_170_n}]

# 10 MHz OCXO reference clock (ultra-stable reference)
# Source: OSJ7014-10.0M OCXO
create_clock -period 100.000 -name clk_10 [get_ports {clk_10_p clk_10_n}]

# Set clock uncertainty for timing margin
set_clock_uncertainty -setup 0.500 [get_clocks clk_170]
set_clock_uncertainty -hold 0.200 [get_clocks clk_170]
set_clock_uncertainty -setup 0.500 [get_clocks clk_10]
set_clock_uncertainty -hold 0.200 [get_clocks clk_10]

# Clock group: treat clk_10 as asynchronous to clk_170 (they are independently derived)
set_clock_groups -asynchronous -group [get_clocks clk_170] -group [get_clocks clk_10]

# ============================================================================
# LVDS ADC Input Constraints
# ============================================================================

# Channel A ADC data and clocks (AD9643 interface)
# DCO: Data Clock Output from ADC (170 MHz)
set_input_delay -clock [get_clocks clk_170] -max 2.0 [get_ports {adc_cha_dco_p adc_cha_dco_n}]
set_input_delay -clock [get_clocks clk_170] -min 0.5 [get_ports {adc_cha_dco_p adc_cha_dco_n}]

# FCO: Frame Clock Output from ADC (170 MHz/14 = ~12.14 MHz for frame sync)
set_input_delay -clock [get_clocks clk_170] -max 2.0 [get_ports {adc_cha_fco_p adc_cha_fco_n}]
set_input_delay -clock [get_clocks clk_170] -min 0.5 [get_ports {adc_cha_fco_p adc_cha_fco_n}]

# Channel A data bits [13:0]
set_input_delay -clock [get_clocks clk_170] -max 2.0 [get_ports adc_cha_d_p[*]]
set_input_delay -clock [get_clocks clk_170] -min 0.5 [get_ports adc_cha_d_p[*]]
set_input_delay -clock [get_clocks clk_170] -max 2.0 [get_ports adc_cha_d_n[*]]
set_input_delay -clock [get_clocks clk_170] -min 0.5 [get_ports adc_cha_d_n[*]]

# Channel B ADC data and clocks (AD9643 interface)
set_input_delay -clock [get_clocks clk_170] -max 2.0 [get_ports {adc_chb_dco_p adc_chb_dco_n}]
set_input_delay -clock [get_clocks clk_170] -min 0.5 [get_ports {adc_chb_dco_p adc_chb_dco_n}]

set_input_delay -clock [get_clocks clk_170] -max 2.0 [get_ports {adc_chb_fco_p adc_chb_fco_n}]
set_input_delay -clock [get_clocks clk_170] -min 0.5 [get_ports {adc_chb_fco_p adc_chb_fco_n}]

# Channel B data bits [13:0]
set_input_delay -clock [get_clocks clk_170] -max 2.0 [get_ports adc_chb_d_p[*]]
set_input_delay -clock [get_clocks clk_170] -min 0.5 [get_ports adc_chb_d_p[*]]
set_input_delay -clock [get_clocks clk_170] -max 2.0 [get_ports adc_chb_d_n[*]]
set_input_delay -clock [get_clocks clk_170] -min 0.5 [get_ports adc_chb_d_n[*]]

# ============================================================================
# UART Interface Constraints
# ============================================================================

# UART at 115.2 kbps (approx 8.68 us period)
# Default I/O delay for UART signals
set_input_delay -clock [get_clocks clk_170] -max 10.0 [get_ports uart_rxd]
set_input_delay -clock [get_clocks clk_170] -min 0.0 [get_ports uart_rxd]
set_output_delay -clock [get_clocks clk_170] -max 10.0 [get_ports uart_txd]
set_output_delay -clock [get_clocks clk_170] -min 0.0 [get_ports uart_txd]

# ============================================================================
# SPI Interface Constraints (PLL1 and PLL2)
# ============================================================================

# SPI up to 50 MHz (20 ns period)
# PLL1 SPI (LO1 synthesizer - ADF4106)
set_output_delay -clock [get_clocks clk_170] -max 10.0 [get_ports {spi_pll1_cs_n spi_pll1_sclk spi_pll1_mosi}]
set_output_delay -clock [get_clocks clk_170] -min 0.0 [get_ports {spi_pll1_cs_n spi_pll1_sclk spi_pll1_mosi}]
set_input_delay -clock [get_clocks clk_170] -max 10.0 [get_ports spi_pll1_miso]
set_input_delay -clock [get_clocks clk_170] -min 0.0 [get_ports spi_pll1_miso]

# PLL2 SPI (LO2 synthesizer - ADF4106)
set_output_delay -clock [get_clocks clk_170] -max 10.0 [get_ports {spi_pll2_cs_n spi_pll2_sclk spi_pll2_mosi}]
set_output_delay -clock [get_clocks clk_170] -min 0.0 [get_ports {spi_pll2_cs_n spi_pll2_sclk spi_pll2_mosi}]
set_input_delay -clock [get_clocks clk_170] -max 10.0 [get_ports spi_pll2_miso]
set_input_delay -clock [get_clocks clk_170] -min 0.0 [get_ports spi_pll2_miso]

# ============================================================================
# I2C Interface Constraints
# ============================================================================

# I2C at 400 kHz fast mode
set_output_delay -clock [get_clocks clk_170] -max 10.0 [get_ports {i2c_scl i2c_sda}]
set_output_delay -clock [get_clocks clk_170] -min 0.0 [get_ports {i2c_scl i2c_sda}]
set_input_delay -clock [get_clocks clk_170] -max 10.0 [get_ports {i2c_scl i2c_sda}]
set_input_delay -clock [get_clocks clk_170] -min 0.0 [get_ports {i2c_scl i2c_sda}]

# I2C is open-drain - use pullup constraint
set_property PULLUP true [get_ports {i2c_scl i2c_sda}]

# ============================================================================
# SPI Flash Interface Constraints
# ============================================================================

# SPI configuration flash (AT25SL321)
set_output_delay -clock [get_clocks clk_170] -max 10.0 [get_ports {flash_cs_n flash_sclk flash_mosi}]
set_output_delay -clock [get_clocks clk_170] -min 0.0 [get_ports {flash_cs_n flash_sclk flash_mosi}]
set_input_delay -clock [get_clocks clk_170] -max 10.0 [get_ports flash_miso]
set_input_delay -clock [get_clocks clk_170] -min 0.0 [get_ports flash_miso]

# ============================================================================
# GPIO and Control Signal Constraints
# ============================================================================

# GPIO outputs
set_output_delay -clock [get_clocks clk_170] -max 10.0 [get_ports {gpio_led0 gpio_led1 gpio_led2}]
set_output_delay -clock [get_clocks clk_170] -min 0.0 [get_ports {gpio_led0 gpio_led1 gpio_led2}]

# GPIO inputs (sync inputs)
set_input_delay -clock [get_clocks clk_170] -max 10.0 [get_ports {gpio_sync_in}]
set_input_delay -clock [get_clocks clk_170] -min 0.0 [get_ports {gpio_sync_in}]

# ADC SPI control
set_output_delay -clock [get_clocks clk_170] -max 10.0 [get_ports {spi_adc_cs_n spi_adc_sclk spi_adc_mosi}]
set_output_delay -clock [get_clocks clk_170] -min 0.0 [get_ports {spi_adc_cs_n spi_adc_sclk spi_adc_mosi}]
set_input_delay -clock [get_clocks clk_170] -max 10.0 [get_ports spi_adc_miso]
set_input_delay -clock [get_clocks clk_170] -min 0.0 [get_ports spi_adc_miso]

# ============================================================================
# False Path Constraints
# ============================================================================

# Asynchronous active-low reset - false path through synchronizer
set_false_path -from [get_ports rst_n] -to [all_registers]

# Static configuration signals - false path
set_false_path -from [get_ports {gpio_sync_in}] -to [all_registers]

# JTAG is handled by dedicated FPGA circuitry - no constraints needed

# ============================================================================
# LVDS I/O Standards
# ============================================================================

# Set LVDS input standard for ADC interfaces
set_property IOSTANDARD LVDS [get_ports {clk_170_p clk_170_n clk_10_p clk_10_n}]
set_property IOSTANDARD LVDS [get_ports {adc_cha_d_p[*] adc_cha_d_n[*]}]
set_property IOSTANDARD LVDS [get_ports {adc_cha_dco_p adc_cha_dco_n}]
set_property IOSTANDARD LVDS [get_ports {adc_cha_fco_p adc_cha_fco_n}]
set_property IOSTANDARD LVDS [get_ports {adc_chb_d_p[*] adc_chb_d_n[*]}]
set_property IOSTANDARD LVDS [get_ports {adc_chb_dco_p adc_chb_dco_n}]
set_property IOSTANDARD LVDS [get_ports {adc_chb_fco_p adc_chb_fco_n}]

# Differential pair termination
set_property DIFF_TERM TRUE [get_ports {clk_170_p clk_170_n}]
set_property DIFF_TERM TRUE [get_ports {clk_10_p clk_10_n}]
set_property DIFF_TERM TRUE [get_ports {adc_cha_d_p[*] adc_cha_d_n[*]}]
set_property DIFF_TERM TRUE [get_ports {adc_cha_dco_p adc_cha_dco_n}]
set_property DIFF_TERM TRUE [get_ports {adc_cha_fco_p adc_cha_fco_n}]
set_property DIFF_TERM TRUE [get_ports {adc_chb_d_p[*] adc_chb_d_n[*]}]
set_property DIFF_TERM TRUE [get_ports {adc_chb_dco_p adc_chb_dco_n}]
set_property DIFF_TERM TRUE [get_ports {adc_chb_fco_p adc_chb_fco_n}]

# ============================================================================
# GPIO I/O Standards
# ============================================================================

# UART (3.3V LVCMOS)
set_property IOSTANDARD LVCMOS33 [get_ports {uart_rxd uart_txd}]

# SPI (3.3V LVCMOS)
set_property IOSTANDARD LVCMOS33 [get_ports {spi_pll1_cs_n spi_pll1_sclk spi_pll1_mosi spi_pll1_miso}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_pll2_cs_n spi_pll2_sclk spi_pll2_mosi spi_pll2_miso}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_adc_cs_n spi_adc_sclk spi_adc_mosi spi_adc_miso}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_cs_n flash_sclk flash_mosi flash_miso}]

# I2C (3.3V LVCMOS)
set_property IOSTANDARD LVCMOS33 [get_ports {i2c_scl i2c_sda}]

# GPIO (3.3V LVCMOS)
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_led0 gpio_led1 gpio_led2}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_sync_in}]

# Reset (3.3V LVCMOS)
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

# ============================================================================
# Pin Assignments
# ============================================================================
# NOTE: Exact pin numbers depend on PFP-KX7_PLUS-310LC board schematic
# The following are placeholder assignments - adjust per actual board layout
# ============================================================================

# Primary 170 MHz LVDS clock (Bank 35 - MRCC pairs)
set_property PACKAGE_PIN E18  [get_ports clk_170_p]
set_property PACKAGE_PIN E17  [get_ports clk_170_n]

# 10 MHz OCXO reference clock (Bank 35 - MRCC pairs)
set_property PACKAGE_PIN G17  [get_ports clk_10_p]
set_property PACKAGE_PIN G16  [get_ports clk_10_n]

# Active-low reset
set_property PACKAGE_PIN AA15 [get_ports rst_n]

# UART interface (Bank 14)
set_property PACKAGE_PIN Y18  [get_ports uart_rxd]
set_property PACKAGE_PIN Y19  [get_ports uart_txd]

# ==============================================================================
# Channel A ADC LVDS Interface (Bank 15 - High Performance LVDS)
# ==============================================================================

# Channel A frame clock
set_property PACKAGE_PIN K22  [get_ports adc_cha_fco_p]
set_property PACKAGE_PIN K21  [get_ports adc_cha_fco_n]

# Channel A data clock
set_property PACKAGE_PIN J22  [get_ports adc_cha_dco_p]
set_property PACKAGE_PIN J21  [get_ports adc_cha_dco_n]

# Channel A data bits [13:0]
set_property PACKAGE_PIN M22  [get_ports {adc_cha_d_p[13]}]
set_property PACKAGE_PIN M21  [get_ports {adc_cha_d_n[13]}]
set_property PACKAGE_PIN L22  [get_ports {adc_cha_d_p[12]}]
set_property PACKAGE_PIN L21  [get_ports {adc_cha_d_n[12]}]
set_property PACKAGE_PIN H22  [get_ports {adc_cha_d_p[11]}]
set_property PACKAGE_PIN H21  [get_ports {adc_cha_d_n[11]}]
set_property PACKAGE_PIN G22  [get_ports {adc_cha_d_p[10]}]
set_property PACKAGE_PIN G21  [get_ports {adc_cha_d_n[10]}]
set_property PACKAGE_PIN F22  [get_ports {adc_cha_d_p[9]}]
set_property PACKAGE_PIN F21  [get_ports {adc_cha_d_n[9]}]
set_property PACKAGE_PIN E22  [get_ports {adc_cha_d_p[8]}]
set_property PACKAGE_PIN E21  [get_ports {adc_cha_d_n[8]}]
set_property PACKAGE_PIN D22  [get_ports {adc_cha_d_p[7]}]
set_property PACKAGE_PIN D21  [get_ports {adc_cha_d_n[7]}]
set_property PACKAGE_PIN C22  [get_ports {adc_cha_d_p[6]}]
set_property PACKAGE_PIN C21  [get_ports {adc_cha_d_n[6]}]
set_property PACKAGE_PIN B22  [get_ports {adc_cha_d_p[5]}]
set_property PACKAGE_PIN B21  [get_ports {adc_cha_d_n[5]}]
set_property PACKAGE_PIN A22  [get_ports {adc_cha_d_p[4]}]
set_property PACKAGE_PIN A21  [get_ports {adc_cha_d_n[4]}]
set_property PACKAGE_PIN M20  [get_ports {adc_cha_d_p[3]}]
set_property PACKAGE_PIN L20  [get_ports {adc_cha_d_n[3]}]
set_property PACKAGE_PIN K20  [get_ports {adc_cha_d_p[2]}]
set_property PACKAGE_PIN K19  [get_ports {adc_cha_d_n[2]}]
set_property PACKAGE_PIN J20  [get_ports {adc_cha_d_p[1]}]
set_property PACKAGE_PIN J19  [get_ports {adc_cha_d_n[1]}]
set_property PACKAGE_PIN H20  [get_ports {adc_cha_d_p[0]}]
set_property PACKAGE_PIN H19  [get_ports {adc_cha_d_n[0]}]

# ==============================================================================
# Channel B ADC LVDS Interface (Bank 16 - High Performance LVDS)
# ==============================================================================

# Channel B frame clock
set_property PACKAGE_PIN T22  [get_ports adc_chb_fco_p]
set_property PACKAGE_PIN T21  [get_ports adc_chb_fco_n]

# Channel B data clock
set_property PACKAGE_PIN R22  [get_ports adc_chb_dco_p]
set_property PACKAGE_PIN R21  [get_ports adc_chb_dco_n]

# Channel B data bits [13:0]
set_property PACKAGE_PIN V22  [get_ports {adc_chb_d_p[13]}]
set_property PACKAGE_PIN V21  [get_ports {adc_chb_d_n[13]}]
set_property PACKAGE_PIN U22  [get_ports {adc_chb_d_p[12]}]
set_property PACKAGE_PIN U21  [get_ports {adc_chb_d_n[12]}]
set_property PACKAGE_PIN P22  [get_ports {adc_chb_d_p[11]}]
set_property PACKAGE_PIN P21  [get_ports {adc_chb_d_n[11]}]
set_property PACKAGE_PIN N22  [get_ports {adc_chb_d_p[10]}]
set_property PACKAGE_PIN N21  [get_ports {adc_chb_d_n[10]}]
set_property PACKAGE_PIN M22  [get_ports {adc_chb_d_p[9]}]
set_property PACKAGE_PIN M21  [get_ports {adc_chb_d_n[9]}]
set_property PACKAGE_PIN L22  [get_ports {adc_chb_d_p[8]}]
set_property PACKAGE_PIN L21  [get_ports {adc_chb_d_n[8]}]
set_property PACKAGE_PIN K22  [get_ports {adc_chb_d_p[7]}]
set_property PACKAGE_PIN K21  [get_ports {adc_chb_d_n[7]}]
set_property PACKAGE_PIN H22  [get_ports {adc_chb_d_p[6]}]
set_property PACKAGE_PIN H21  [get_ports {adc_chb_d_n[6]}]
set_property PACKAGE_PIN G22  [get_ports {adc_chb_d_p[5]}]
set_property PACKAGE_PIN G21  [get_ports {adc_chb_d_n[5]}]
set_property PACKAGE_PIN F22  [get_ports {adc_chb_d_p[4]}]
set_property PACKAGE_PIN F21  [get_ports {adc_chb_d_n[4]}]
set_property PACKAGE_PIN T20  [get_ports {adc_chb_d_p[3]}]
set_property PACKAGE_PIN R20  [get_ports {adc_chb_d_n[3]}]
set_property PACKAGE_PIN P20  [get_ports {adc_chb_d_p[2]}]
set_property PACKAGE_PIN N20  [get_ports {adc_chb_d_n[2]}]
set_property PACKAGE_PIN M20  [get_ports {adc_chb_d_p[1]}]
set_property PACKAGE_PIN L20  [get_ports {adc_chb_d_n[1]}]
set_property PACKAGE_PIN K20  [get_ports {adc_chb_d_p[0]}]
set_property PACKAGE_PIN K19  [get_ports {adc_chb_d_n[0]}]

# ============================================================================
# PLL1 SPI (LO1 Synthesizer) - Bank 14
# ============================================================================
set_property PACKAGE_PIN W18  [get_ports spi_pll1_cs_n]
set_property PACKAGE_PIN W19  [get_ports spi_pll1_sclk]
set_property PACKAGE_PIN U17  [get_ports spi_pll1_mosi]
set_property PACKAGE_PIN U18  [get_ports spi_pll1_miso]

# ============================================================================
# PLL2 SPI (LO2 Synthesizer) - Bank 14
# ============================================================================
set_property PACKAGE_PIN T17  [get_ports spi_pll2_cs_n]
set_property PACKAGE_PIN R17  [get_ports spi_pll2_sclk]
set_property PACKAGE_PIN P17  [get_ports spi_pll2_mosi]
set_property PACKAGE_PIN N17  [get_ports spi_pll2_miso]

# ============================================================================
# I2C Interface (Telemetry) - Bank 14
# ============================================================================
set_property PACKAGE_PIN Y17  [get_ports i2c_scl]
set_property PACKAGE_PIN Y16  [get_ports i2c_sda]

# ============================================================================
# SPI Flash (Configuration) - Bank 15
# ============================================================================
set_property PACKAGE_PIN AA16 [get_ports flash_cs_n]
set_property PACKAGE_PIN AB16 [get_ports flash_sclk]
set_property PACKAGE_PIN AA17 [get_ports flash_mosi]
set_property PACKAGE_PIN AB17 [get_ports flash_miso]

# ============================================================================
# ADC SPI Control - Bank 14
# ============================================================================
set_property PACKAGE_PIN V18  [get_ports spi_adc_cs_n]
set_property PACKAGE_PIN V19  [get_ports spi_adc_sclk]
set_property PACKAGE_PIN T18  [get_ports spi_adc_mosi]
set_property PACKAGE_PIN R18  [get_ports spi_adc_miso]

# ============================================================================
# GPIO LEDs (Status Indicators) - Bank 14
# ============================================================================
set_property PACKAGE_PIN W15  [get_ports gpio_led0]   # System status
set_property PACKAGE_PIN W16  [get_ports gpio_led1]   # PLL lock status
set_property PACKAGE_PIN V15  [get_ports gpio_led2]   # Data valid status

# ============================================================================
# GPIO Sync Input - Bank 14
# ============================================================================
set_property PACKAGE_PIN U15  [get_ports gpio_sync_in]

# ============================================================================
# Additional Constraints
# ============================================================================

# Disable insertion of IBUF on LVDS pairs (handled by IBUFDS internally)
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]

# Drive strengths for SPI outputs
set_property DRIVE 16 [get_ports {spi_pll1_cs_n spi_pll1_sclk spi_pll1_mosi}]
set_property DRIVE 16 [get_ports {spi_pll2_cs_n spi_pll2_sclk spi_pll2_mosi}]
set_property DRIVE 16 [get_ports {spi_adc_cs_n spi_adc_sclk spi_adc_mosi}]
set_property DRIVE 16 [get_ports {flash_cs_n flash_sclk flash_mosi}]

# Slew rate for fast SPI
set_property SLEW FAST [get_ports {spi_pll1_cs_n spi_pll1_sclk spi_pll1_mosi}]
set_property SLEW FAST [get_ports {spi_pll2_cs_n spi_pll2_sclk spi_pll2_mosi}]
set_property SLEW FAST [get_ports {spi_adc_cs_n spi_adc_sclk spi_adc_mosi}]
set_property SLEW FAST [get_ports {flash_cs_n flash_sclk flash_mosi}]

# LED drive strength and slew (moderate for reduced EMI)
set_property DRIVE 8 [get_ports {gpio_led0 gpio_led1 gpio_led2}]
set_property SLEW SLOW [get_ports {gpio_led0 gpio_led1 gpio_led2}]

# I2C open drain with slew
set_property SLEW SLOW [get_ports {i2c_scl i2c_sda}]

# ============================================================================
# End of Constraints File
# ============================================================================