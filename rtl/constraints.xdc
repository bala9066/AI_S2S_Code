#######################################################################
# @file    constraints.xdc
# @brief   Vivado XDC constraints for hv_top (XC7K160T-1FFG676)
# @project hv — 18-40 GHz Dual-Channel Double-IF Superheterodyne Radar Receiver
# @version 0V01
# @date    2026-04-25
#
# Target Device : Xilinx Kintex-7 XC7K160T-1FFG676
# Clock Source  : 100 MHz TCXO (ASGTX-D-100.000MHZ-1)
#
# NOTE: Pin assignments below are PLACEHOLDER values for the FFG676
#       package.  The PCB schematic designer MUST update every
#       set_property PACKAGE_PIN line to match the actual board
#       routing before synthesis/PAR.  Pin names are shown in the
#       comment for cross-reference.
#######################################################################

# =====================================================================
# 1. PRIMARY CLOCK — 100 MHz TCXO differential input
# =====================================================================
# Positive/negative pair on HR Bank 33 LVDS-capable pins.
set_property PACKAGE_PIN K3     [get_ports clk_100mhz_p]
set_property PACKAGE_PIN K4     [get_ports clk_100mhz_n]
set_property IOSTANDARD LVDS_25 [get_ports clk_100mhz_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_100mhz_n]

# 100 MHz differential clock constraint (period = 10.000 ns, 50% duty)
create_clock -period 10.000 -name clk_100mhz \
    -waveform {0.000 5.000} \
    [get_ports clk_100mhz_p]

# =====================================================================
# 2. SYSTEM RESET — active-low synchronous reset
# =====================================================================
set_property PACKAGE_PIN G6      [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PULLUP  true        [get_ports rst_n]

set_false_path -from [get_ports rst_n]

# =====================================================================
# 3. ADC CLOCK / FRAME — AD9627ABCPZ-150 LVDS interface
# =====================================================================
# ADC data clock output (DCO) — differential LVDS
set_property PACKAGE_PIN AB5     [get_ports adc_dco_p]
set_property PACKAGE_PIN AB6     [get_ports adc_dco_n]
set_property IOSTANDARD LVDS_25 [get_ports adc_dco_p]
set_property IOSTANDARD LVDS_25 [get_ports adc_dco_n]

# ADC frame clock output (FCO) — differential LVDS
set_property PACKAGE_PIN Y4      [get_ports adc_fco_p]
set_property PACKAGE_PIN Y5      [get_ports adc_fco_n]
set_property IOSTANDARD LVDS_25 [get_ports adc_fco_p]
set_property IOSTANDARD LVDS_25 [get_ports adc_fco_n]

# ADC DCO is treated as a source-synchronous clock from the AD9627
# Typical rate = 150 MHz DDR = 150 MHz clock (period 6.667 ns)
create_clock -period 6.667 -name adc_dco \
    -waveform {0.000 3.333} \
    [get_ports adc_dco_p]

# Input delay constraints on ADC data/frame relative to DCO
# Using 10 ns default window (adjust after timing simulation)
set_input_delay  -clock adc_dco -max 2.000 [get_ports {adc_da_p[*]}]
set_input_delay  -clock adc_dco -min 0.500 [get_ports {adc_da_p[*]}]
set_input_delay  -clock adc_dco -max 2.000 [get_ports {adc_da_n[*]}]
set_input_delay  -clock adc_dco -min 0.500 [get_ports {adc_da_n[*]}]
set_input_delay  -clock adc_dco -max 2.000 [get_ports {adc_db_p[*]}]
set_input_delay  -clock adc_dco -min 0.500 [get_ports {adc_db_p[*]}]
set_input_delay  -clock adc_dco -max 2.000 [get_ports {adc_db_n[*]}]
set_input_delay  -clock adc_dco -min 0.500 [get_ports {adc_db_n[*]}]
set_input_delay  -clock adc_dco -max 2.000 [get_ports adc_fco_p]
set_input_delay  -clock adc_dco -min 0.500 [get_ports adc_fco_p]
set_input_delay  -clock adc_dco -max 2.000 [get_ports adc_fco_n]
set_input_delay  -clock adc_dco -min 0.500 [get_ports adc_fco_n]

# ADC data pins — differential LVDS (6 pairs per channel)
# Channel A
set_property PACKAGE_PIN AA5     [get_ports {adc_da_p[0]}]
set_property PACKAGE_PIN AA6     [get_ports {adc_da_n[0]}]
set_property PACKAGE_PIN V5      [get_ports {adc_da_p[1]}]
set_property PACKAGE_PIN V6      [get_ports {adc_da_n[1]}]
set_property PACKAGE_PIN U5      [get_ports {adc_da_p[2]}]
set_property PACKAGE_PIN U6      [get_ports {adc_da_n[2]}]
set_property PACKAGE_PIN R5      [get_ports {adc_da_p[3]}]
set_property PACKAGE_PIN R6      [get_ports {adc_da_n[3]}]
set_property PACKAGE_PIN P5      [get_ports {adc_da_p[4]}]
set_property PACKAGE_PIN P6      [get_ports {adc_da_n[4]}]
set_property PACKAGE_PIN N5      [get_ports {adc_da_p[5]}]
set_property PACKAGE_PIN N6      [get_ports {adc_da_n[5]}]

set_property IOSTANDARD LVDS_25 [get_ports {adc_da_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_da_n[*]}]

# Channel B
set_property PACKAGE_PIN M5      [get_ports {adc_db_p[0]}]
set_property PACKAGE_PIN M6      [get_ports {adc_db_n[0]}]
set_property PACKAGE_PIN L5      [get_ports {adc_db_p[1]}]
set_property PACKAGE_PIN L6      [get_ports {adc_db_n[1]}]
set_property PACKAGE_PIN K5      [get_ports {adc_db_p[2]}]
set_property PACKAGE_PIN K6      [get_ports {adc_db_n[2]}]
set_property PACKAGE_PIN J5      [get_ports {adc_db_p[3]}]
set_property PACKAGE_PIN J6      [get_ports {adc_db_n[3]}]
set_property PACKAGE_PIN H5      [get_ports {adc_db_p[4]}]
set_property PACKAGE_PIN H6      [get_ports {adc_db_n[4]}]
set_property PACKAGE_PIN G5      [get_ports {adc_db_p[5]}]
set_property PACKAGE_PIN G6_rep  [get_ports {adc_db_n[5]}]

set_property IOSTANDARD LVDS_25 [get_ports {adc_db_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_db_n[*]}]

# =====================================================================
# 4. LO1 PLL SPI — ADF4108BCPZ-RL7
# =====================================================================
set_property PACKAGE_PIN H11     [get_ports lo1_spi_cs_n]
set_property PACKAGE_PIN J11     [get_ports lo1_spi_sclk]
set_property PACKAGE_PIN K11     [get_ports lo1_spi_sdi]
set_property PACKAGE_PIN L11     [get_ports lo1_spi_sdo]

set_property IOSTANDARD LVCMOS33 [get_ports lo1_spi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports lo1_spi_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports lo1_spi_sdi]
set_property IOSTANDARD LVCMOS33 [get_ports lo1_spi_sdo]

set_output_delay -clock clk_100mhz -max 10.000 [get_ports lo1_spi_cs_n]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports lo1_spi_cs_n]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports lo1_spi_sclk]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports lo1_spi_sclk]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports lo1_spi_sdi]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports lo1_spi_sdi]
set_input_delay  -clock clk_100mhz -max 10.000 [get_ports lo1_spi_sdo]
set_input_delay  -clock clk_100mhz -min 0.000  [get_ports lo1_spi_sdo]

# =====================================================================
# 5. LO2 PLL SPI — LMX2487ESQ/NOPB
# =====================================================================
set_property PACKAGE_PIN M11     [get_ports lo2_spi_cs_n]
set_property PACKAGE_PIN N11     [get_ports lo2_spi_sclk]
set_property PACKAGE_PIN P11     [get_ports lo2_spi_sdi]
set_property PACKAGE_PIN R11     [get_ports lo2_lock_detect]

set_property IOSTANDARD LVCMOS33 [get_ports lo2_spi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports lo2_spi_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports lo2_spi_sdi]
set_property IOSTANDARD LVCMOS33 [get_ports lo2_lock_detect]

set_output_delay -clock clk_100mhz -max 10.000 [get_ports lo2_spi_cs_n]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports lo2_spi_cs_n]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports lo2_spi_sclk]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports lo2_spi_sclk]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports lo2_spi_sdi]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports lo2_spi_sdi]
set_input_delay  -clock clk_100mhz -max 10.000 [get_ports lo2_lock_detect]
set_input_delay  -clock clk_100mhz -min 0.000  [get_ports lo2_lock_detect]

# =====================================================================
# 6. VGA GAIN CONTROL DAC SPI — shared bus
# =====================================================================
set_property PACKAGE_PIN T11     [get_ports vga_dac_sclk]
set_property PACKAGE_PIN U11     [get_ports vga_dac_sdo]
set_property PACKAGE_PIN V11     [get_ports vga1_dac_cs_n]
set_property PACKAGE_PIN W11     [get_ports vga2_dac_cs_n]

set_property IOSTANDARD LVCMOS33 [get_ports vga_dac_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports vga_dac_sdo]
set_property IOSTANDARD LVCMOS33 [get_ports vga1_dac_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports vga2_dac_cs_n]

set_output_delay -clock clk_100mhz -max 10.000 [get_ports vga_dac_sclk]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports vga_dac_sclk]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports vga_dac_sdo]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports vga_dac_sdo]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports vga1_dac_cs_n]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports vga1_dac_cs_n]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports vga2_dac_cs_n]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports vga2_dac_cs_n]

# =====================================================================
# 7. ADC SPI — AD9627ABCPZ-150 configuration port
# =====================================================================
set_property PACKAGE_PIN Y11     [get_ports adc_spi_cs_n]
set_property PACKAGE_PIN AA11    [get_ports adc_spi_sclk]
set_property PACKAGE_PIN AB11    [get_ports adc_spi_sdi]

set_property IOSTANDARD LVCMOS33 [get_ports adc_spi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports adc_spi_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports adc_spi_sdi]

set_output_delay -clock clk_100mhz -max 10.000 [get_ports adc_spi_cs_n]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports adc_spi_cs_n]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports adc_spi_sclk]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports adc_spi_sclk]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports adc_spi_sdi]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports adc_spi_sdi]

# =====================================================================
# 8. UART — USB-UART bridge (FT232H)
# =====================================================================
set_property PACKAGE_PIN D7      [get_ports uart_rxd]
set_property PACKAGE_PIN C7      [get_ports uart_txd]

set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]

set_input_delay  -clock clk_100mhz -max 10.000 [get_ports uart_rxd]
set_input_delay  -clock clk_100mhz -min 0.000  [get_ports uart_rxd]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports uart_txd]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports uart_txd]

# =====================================================================
# 9. EEPROM SPI — AT93C56B-SSHL-T
# =====================================================================
set_property PACKAGE_PIN E7      [get_ports eeprom_cs_n]
set_property PACKAGE_PIN F7      [get_ports eeprom_sclk]
set_property PACKAGE_PIN E8      [get_ports eeprom_sdi]
set_property PACKAGE_PIN F8      [get_ports eeprom_sdo]

set_property IOSTANDARD LVCMOS33 [get_ports eeprom_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports eeprom_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports eeprom_sdi]
set_property IOSTANDARD LVCMOS33 [get_ports eeprom_sdo]

set_output_delay -clock clk_100mhz -max 10.000 [get_ports eeprom_cs_n]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports eeprom_cs_n]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports eeprom_sclk]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports eeprom_sclk]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports eeprom_sdi]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports eeprom_sdi]
set_input_delay  -clock clk_100mhz -max 10.000 [get_ports eeprom_sdo]
set_input_delay  -clock clk_100mhz -min 0.000  [get_ports eeprom_sdo]

# =====================================================================
# 10. QSPI FLASH — IS25LP256D (configuration + firmware storage)
# =====================================================================
set_property PACKAGE_PIN L3      [get_ports qspi_cs_n]
set_property PACKAGE_PIN M3      [get_ports qspi_sclk]
set_property PACKAGE_PIN N3      [get_ports qspi_io0]
set_property PACKAGE_PIN P3      [get_ports qspi_io1]
set_property PACKAGE_PIN R3      [get_ports qspi_io2]
set_property PACKAGE_PIN T3      [get_ports qspi_io3]

set_property IOSTANDARD LVCMOS33 [get_ports qspi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports qspi_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports qspi_io0]
set_property IOSTANDARD LVCMOS33 [get_ports qspi_io1]
set_property IOSTANDARD LVCMOS33 [get_ports qspi_io2]
set_property IOSTANDARD LVCMOS33 [get_ports qspi_io3]

set_output_delay -clock clk_100mhz -max 10.000 [get_ports qspi_cs_n]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports qspi_cs_n]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports qspi_sclk]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports qspi_sclk]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports qspi_io0]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports qspi_io0]
set_input_delay  -clock clk_100mhz -max 10.000 [get_ports qspi_io1]
set_input_delay  -clock clk_100mhz -min 0.000  [get_ports qspi_io1]

# =====================================================================
# 11. I2C TEMPERATURE SENSOR — AD7416ARMZ
# =====================================================================
set_property PACKAGE_PIN D8      [get_ports temp_scl]
set_property PACKAGE_PIN E9      [get_ports temp_sda]

set_property IOSTANDARD LVCMOS33 [get_ports temp_scl]
set_property IOSTANDARD LVCMOS33 [get_ports temp_sda]

# SDA is bidirectional — enable both input and output delay
set_output_delay -clock clk_100mhz -max 10.000 [get_ports temp_scl]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports temp_scl]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports temp_sda]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports temp_sda]
set_input_delay  -clock clk_100mhz -max 10.000 [get_ports temp_sda]
set_input_delay  -clock clk_100mhz -min 0.000  [get_ports temp_sda]

# =====================================================================
# 12. LVDS DATA OUTPUT — Digital I/O Connector (J_DIG Samtec 80-pin)
# =====================================================================
set_property PACKAGE_PIN C12     [get_ports {lvds_tx_p[0]}]
set_property PACKAGE_PIN C13     [get_ports {lvds_tx_n[0]}]
set_property PACKAGE_PIN D12     [get_ports {lvds_tx_p[1]}]
set_property PACKAGE_PIN D13     [get_ports {lvds_tx_n[1]}]
set_property PACKAGE_PIN E12     [get_ports {lvds_tx_p[2]}]
set_property PACKAGE_PIN E13     [get_ports {lvds_tx_n[2]}]
set_property PACKAGE_PIN F12     [get_ports {lvds_tx_p[3]}]
set_property PACKAGE_PIN F13     [get_ports {lvds_tx_n[3]}]
set_property PACKAGE_PIN G12     [get_ports {lvds_tx_p[4]}]
set_property PACKAGE_PIN G13     [get_ports {lvds_tx_n[4]}]
set_property PACKAGE_PIN H12     [get_ports {lvds_tx_p[5]}]
set_property PACKAGE_PIN H13     [get_ports {lvds_tx_n[5]}]
set_property PACKAGE_PIN J12     [get_ports {lvds_tx_p[6]}]
set_property PACKAGE_PIN J13     [get_ports {lvds_tx_n[6]}]
set_property PACKAGE_PIN K12     [get_ports {lvds_tx_p[7]}]
set_property PACKAGE_PIN K13     [get_ports {lvds_tx_n[7]}]

set_property IOSTANDARD LVDS_25 [get_ports {lvds_tx_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {lvds_tx_n[*]}]

set_output_delay -clock clk_100mhz -max 10.000 [get_ports {lvds_tx_p[*]}]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports {lvds_tx_p[*]}]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports {lvds_tx_n[*]}]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports {lvds_tx_n[*]}]

# LVDS output clock (TX_CLK)
set_property PACKAGE_PIN B11     [get_ports lvds_tx_clk_p]
set_property PACKAGE_PIN A11     [get_ports lvds_tx_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports lvds_tx_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports lvds_tx_clk_n]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports lvds_tx_clk_p]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports lvds_tx_clk_p]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports lvds_tx_clk_n]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports lvds_tx_clk_n]

# =====================================================================
# 13. JTAG — 4-wire debug / configuration interface
# =====================================================================
# JTAG pins are typically connected to the dedicated config pins.
# Vivado handles JTAG pin locations automatically via CFI.
# Explicit constraints are NOT required for TCK/TMS/TDI/TDO on Kintex-7.

# =====================================================================
# 14. STATUS LEDs
# =====================================================================
set_property PACKAGE_PIN B7      [get_ports led_status]
set_property PACKAGE_PIN A7      [get_ports led_error]
set_property PACKAGE_PIN B8      [get_ports led_link]

set_property IOSTANDARD LVCMOS33 [get_ports led_status]
set_property IOSTANDARD LVCMOS33 [get_ports led_error]
set_property IOSTANDARD LVCMOS33 [get_ports led_link]

set_output_delay -clock clk_100mhz -max 10.000 [get_ports led_status]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports led_status]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports led_error]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports led_error]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports led_link]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports led_link]

# =====================================================================
# 15. GENERAL-PURPOSE I/O — Digital I/O connector misc
# =====================================================================
set_property PACKAGE_PIN A8      [get_ports gpio_dig_io0]
set_property PACKAGE_PIN B9      [get_ports gpio_dig_io1]
set_property PACKAGE_PIN A9      [get_ports gpio_dig_io2]
set_property PACKAGE_PIN B10     [get_ports gpio_dig_io3]
set_property PACKAGE_PIN A10     [get_ports gpio_dig_io4]
set_property PACKAGE_PIN C10     [get_ports gpio_dig_io5]
set_property PACKAGE_PIN D10     [get_ports gpio_dig_io6]
set_property PACKAGE_PIN E10     [get_ports gpio_dig_io7]

set_property IOSTANDARD LVCMOS33 [get_ports gpio_dig_io0]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_dig_io1]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_dig_io2]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_dig_io3]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_dig_io4]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_dig_io5]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_dig_io6]
set_property IOSTANDARD LVCMOS33 [get_ports gpio_dig_io7]

set_output_delay -clock clk_100mhz -max 10.000 [get_ports gpio_dig_io0]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports gpio_dig_io0]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports gpio_dig_io1]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports gpio_dig_io1]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports gpio_dig_io2]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports gpio_dig_io2]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports gpio_dig_io3]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports gpio_dig_io3]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports gpio_dig_io4]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports gpio_dig_io4]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports gpio_dig_io5]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports gpio_dig_io5]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports gpio_dig_io6]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports gpio_dig_io6]
set_output_delay -clock clk_100mhz -max 10.000 [get_ports gpio_dig_io7]
set_output_delay -clock clk_100mhz -min 0.000  [get_ports gpio_dig_io7]

# =====================================================================
# 16. FALSE PATHS — asynchronous control / status signals
# =====================================================================
# LO2 lock detect is asynchronous to the main clock
set_false_path -from [get_ports lo2_lock_detect]
set_false_path -from [get_ports lo1_spi_sdo]

# UART RXD is asynchronous (derived from FT232H clock domain)
set_false_path -from [get_ports uart_rxd]

# Temperature sensor I2C is slow asynchronous domain
set_false_path -through [get_ports temp_scl]
set_false_path -through [get_ports temp_sda]

# LED outputs are static / slow — no timing requirement
set_false_path -to [get_ports led_status]
set_false_path -to [get_ports led_error]
set_false_path -to [get_ports led_link]

# EEPROM SPI is slow — treated as static config for timing
set_false_path -to   [get_ports eeprom_cs_n]
set_false_path -to   [get_ports eeprom_sclk]
set_false_path -to   [get_ports eeprom_sdi]
set_false_path -from [get_ports eeprom_sdo]

# =====================================================================
# 17. CLOCK DOMAIN CROSSING CONSTRAINTS
# =====================================================================
# ADC DCO clock domain to system clock domain crossing
set_max_delay -datapath_only 15.000 \
    -from [get_clocks adc_dco] \
    -to   [get_clocks clk_100mhz]

# System clock to ADC DCO domain
set_max_delay -datapath_only 15.000 \
    -from [get_clocks clk_100mhz] \
    -to   [get_clocks adc_dco]

# =====================================================================
# 18. CLOCK UNCERTAINTY / JITTER
# =====================================================================
set_clock_uncertainty -setup 0.200 [get_clocks clk_100mhz]
set_clock_uncertainty -hold  0.100 [get_clocks clk_100mhz]
set_clock_uncertainty -setup 0.300 [get_clocks adc_dco]
set_clock_uncertainty -hold  0.150 [get_clocks adc_dco]

# TCXO phase noise contribution (~-110 dBc/Hz @ 10 kHz)
set_input_jitter [get_clocks clk_100mhz] 0.050

# =====================================================================
# 19. GLOBAL SETTINGS
# =====================================================================
# Enable internal Vref for LVDS_25 inputs if not externally provided
set_property VCCAUX 3.3 [current_design]

# Multi-thread PAR for faster builds
set_param general.maxThreads 8

# Enable incremental builds for iterative design flow
set_property incremental_checkpoint {} [current_design]

# Configuration settings (QSPI flash boot)
set_property CONFIG_VOLTAGE 3.3        [current_design]
set_property CFGBVS         VCCO       [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK ENABLE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE  33       [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4       [current_design]
set_property BITSTREAM.GENERAL.COMPRESS  TRUE      [current_design]
set_property BITSTREAM.STARTUP.MATCH_CYCLE NO_WAIT  [current_design]

# =====================================================================
# 20. PULL-UP / PULL-DOWN on critical control pins
# =====================================================================
# SPI chip selects should be pulled high when FPGA is in reset/config
set_property PULLUP true [get_ports lo1_spi_cs_n]
set_property PULLUP true [get_ports lo2_spi_cs_n]
set_property PULLUP true [get_ports vga1_dac_cs_n]
set_property PULLUP true [get_ports vga2_dac_cs_n]
set_property PULLUP true [get_ports adc_spi_cs_n]
set_property PULLUP true [get_ports eeprom_cs_n]
set_property PULLUP true [get_ports qspi_cs_n]

# =====================================================================
# END OF constraints.xdc
# =====================================================================