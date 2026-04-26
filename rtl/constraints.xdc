## ===========================================================================
## rx_band_top — Vivado XDC Constraints
## Project : rx band (4-Channel 18-40 GHz Double-IF Superheterodyne Radar Receiver)
## FPGA    : Xilinx Kintex-7 XC7K355T-1FFG901I
## Clock   : 10 MHz OCXO (KOVTL10MDBFBCB) differential
## ===========================================================================

## ---------------------------------------------------------------------------
## FPGA Part
## ---------------------------------------------------------------------------
set_property PART xc7k355tffg901-1 [current_project]

## ---------------------------------------------------------------------------
## Primary Clock — 10 MHz OCXO differential pair
## ---------------------------------------------------------------------------
## Pin assignment (example — update per PCB schematic)
set_property PACKAGE_PIN A9  [get_ports clk_10mhz_p]
set_property PACKAGE_PIN A10 [get_ports clk_10mhz_n]
set_property IOSTANDARD LVDS_25 [get_ports clk_10mhz_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_10mhz_n]

create_clock -period 100.000 -name clk_10mhz [get_ports clk_10mhz_p]

## ---------------------------------------------------------------------------
## Reset — active-low push button
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN B12 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PULLUP true [get_ports rst_n]

set_false_path -from [get_ports rst_n]

## ---------------------------------------------------------------------------
## ADC Channel 0 — LVDS data [15:0] + clock (LTC2107 Ch0)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN C2   [get_ports {adc_ch0_d_p[0]}]
set_property PACKAGE_PIN C3   [get_ports {adc_ch0_d_n[0]}]
set_property PACKAGE_PIN D2   [get_ports {adc_ch0_d_p[1]}]
set_property PACKAGE_PIN D3   [get_ports {adc_ch0_d_n[1]}]
set_property PACKAGE_PIN E2   [get_ports {adc_ch0_d_p[2]}]
set_property PACKAGE_PIN E3   [get_ports {adc_ch0_d_n[2]}]
set_property PACKAGE_PIN F2   [get_ports {adc_ch0_d_p[3]}]
set_property PACKAGE_PIN F3   [get_ports {adc_ch0_d_n[3]}]
set_property PACKAGE_PIN G2   [get_ports {adc_ch0_d_p[4]}]
set_property PACKAGE_PIN G3   [get_ports {adc_ch0_d_n[4]}]
set_property PACKAGE_PIN H2   [get_ports {adc_ch0_d_p[5]}]
set_property PACKAGE_PIN H3   [get_ports {adc_ch0_d_n[5]}]
set_property PACKAGE_PIN J2   [get_ports {adc_ch0_d_p[6]}]
set_property PACKAGE_PIN J3   [get_ports {adc_ch0_d_n[6]}]
set_property PACKAGE_PIN K2   [get_ports {adc_ch0_d_p[7]}]
set_property PACKAGE_PIN K3   [get_ports {adc_ch0_d_n[7]}]
set_property PACKAGE_PIN L2   [get_ports {adc_ch0_d_p[8]}]
set_property PACKAGE_PIN L3   [get_ports {adc_ch0_d_n[8]}]
set_property PACKAGE_PIN M2   [get_ports {adc_ch0_d_p[9]}]
set_property PACKAGE_PIN M3   [get_ports {adc_ch0_d_n[9]}]
set_property PACKAGE_PIN N2   [get_ports {adc_ch0_d_p[10]}]
set_property PACKAGE_PIN N3   [get_ports {adc_ch0_d_n[10]}]
set_property PACKAGE_PIN P2   [get_ports {adc_ch0_d_p[11]}]
set_property PACKAGE_PIN P3   [get_ports {adc_ch0_d_n[11]}]
set_property PACKAGE_PIN R2   [get_ports {adc_ch0_d_p[12]}]
set_property PACKAGE_PIN R3   [get_ports {adc_ch0_d_n[12]}]
set_property PACKAGE_PIN T2   [get_ports {adc_ch0_d_p[13]}]
set_property PACKAGE_PIN T3   [get_ports {adc_ch0_d_n[13]}]
set_property PACKAGE_PIN U2   [get_ports {adc_ch0_d_p[14]}]
set_property PACKAGE_PIN U3   [get_ports {adc_ch0_d_n[14]}]
set_property PACKAGE_PIN V2   [get_ports {adc_ch0_d_p[15]}]
set_property PACKAGE_PIN V3   [get_ports {adc_ch0_d_n[15]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_ch0_d_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_ch0_d_n[*]}]

set_property PACKAGE_PIN B2  [get_ports adc_ch0_clk_p]
set_property PACKAGE_PIN B3  [get_ports adc_ch0_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports adc_ch0_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports adc_ch0_clk_n]

create_clock -period 4.762 -name adc_ch0_clk [get_ports adc_ch0_clk_p]

## ---------------------------------------------------------------------------
## ADC Channel 1 — LVDS data [15:0] + clock (LTC2107 Ch1)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN AA2  [get_ports {adc_ch1_d_p[0]}]
set_property PACKAGE_PIN AA3  [get_ports {adc_ch1_d_n[0]}]
set_property PACKAGE_PIN AB2  [get_ports {adc_ch1_d_p[1]}]
set_property PACKAGE_PIN AB3  [get_ports {adc_ch1_d_n[1]}]
set_property PACKAGE_PIN AC2  [get_ports {adc_ch1_d_p[2]}]
set_property PACKAGE_PIN AC3  [get_ports {adc_ch1_d_n[2]}]
set_property PACKAGE_PIN AD2  [get_ports {adc_ch1_d_p[3]}]
set_property PACKAGE_PIN AD3  [get_ports {adc_ch1_d_n[3]}]
set_property PACKAGE_PIN AE2  [get_ports {adc_ch1_d_p[4]}]
set_property PACKAGE_PIN AE3  [get_ports {adc_ch1_d_n[4]}]
set_property PACKAGE_PIN AF2  [get_ports {adc_ch1_d_p[5]}]
set_property PACKAGE_PIN AF3  [get_ports {adc_ch1_d_n[5]}]
set_property PACKAGE_PIN AG2  [get_ports {adc_ch1_d_p[6]}]
set_property PACKAGE_PIN AG3  [get_ports {adc_ch1_d_n[6]}]
set_property PACKAGE_PIN AH2  [get_ports {adc_ch1_d_p[7]}]
set_property PACKAGE_PIN AH3  [get_ports {adc_ch1_d_n[7]}]
set_property PACKAGE_PIN AJ2  [get_ports {adc_ch1_d_p[8]}]
set_property PACKAGE_PIN AJ3  [get_ports {adc_ch1_d_n[8]}]
set_property PACKAGE_PIN AK2  [get_ports {adc_ch1_d_p[9]}]
set_property PACKAGE_PIN AK3  [get_ports {adc_ch1_d_n[9]}]
set_property PACKAGE_PIN AL2  [get_ports {adc_ch1_d_p[10]}]
set_property PACKAGE_PIN AL3  [get_ports {adc_ch1_d_n[10]}]
set_property PACKAGE_PIN AM2  [get_ports {adc_ch1_d_p[11]}]
set_property PACKAGE_PIN AM3  [get_ports {adc_ch1_d_n[11]}]
set_property PACKAGE_PIN AN2  [get_ports {adc_ch1_d_p[12]}]
set_property PACKAGE_PIN AN3  [get_ports {adc_ch1_d_n[12]}]
set_property PACKAGE_PIN AP2  [get_ports {adc_ch1_d_p[13]}]
set_property PACKAGE_PIN AP3  [get_ports {adc_ch1_d_n[13]}]
set_property PACKAGE_PIN AR2  [get_ports {adc_ch1_d_p[14]}]
set_property PACKAGE_PIN AR3  [get_ports {adc_ch1_d_n[14]}]
set_property PACKAGE_PIN AT2  [get_ports {adc_ch1_d_p[15]}]
set_property PACKAGE_PIN AT3  [get_ports {adc_ch1_d_n[15]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_ch1_d_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_ch1_d_n[*]}]

set_property PACKAGE_PIN Y2  [get_ports adc_ch1_clk_p]
set_property PACKAGE_PIN Y3  [get_ports adc_ch1_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports adc_ch1_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports adc_ch1_clk_n]

create_clock -period 4.762 -name adc_ch1_clk [get_ports adc_ch1_clk_p]

## ---------------------------------------------------------------------------
## ADC Channel 2 — LVDS data [15:0] + clock (LTC2107 Ch2)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN A14  [get_ports {adc_ch2_d_p[0]}]
set_property PACKAGE_PIN A15  [get_ports {adc_ch2_d_n[0]}]
set_property PACKAGE_PIN B14  [get_ports {adc_ch2_d_p[1]}]
set_property PACKAGE_PIN B15  [get_ports {adc_ch2_d_n[1]}]
set_property PACKAGE_PIN C14  [get_ports {adc_ch2_d_p[2]}]
set_property PACKAGE_PIN C15  [get_ports {adc_ch2_d_n[2]}]
set_property PACKAGE_PIN D14  [get_ports {adc_ch2_d_p[3]}]
set_property PACKAGE_PIN D15  [get_ports {adc_ch2_d_n[3]}]
set_property PACKAGE_PIN E14  [get_ports {adc_ch2_d_p[4]}]
set_property PACKAGE_PIN E15  [get_ports {adc_ch2_d_n[4]}]
set_property PACKAGE_PIN F14  [get_ports {adc_ch2_d_p[5]}]
set_property PACKAGE_PIN F15  [get_ports {adc_ch2_d_n[5]}]
set_property PACKAGE_PIN G14  [get_ports {adc_ch2_d_p[6]}]
set_property PACKAGE_PIN G15  [get_ports {adc_ch2_d_n[6]}]
set_property PACKAGE_PIN H14  [get_ports {adc_ch2_d_p[7]}]
set_property PACKAGE_PIN H15  [get_ports {adc_ch2_d_n[7]}]
set_property PACKAGE_PIN J14  [get_ports {adc_ch2_d_p[8]}]
set_property PACKAGE_PIN J15  [get_ports {adc_ch2_d_n[8]}]
set_property PACKAGE_PIN K14  [get_ports {adc_ch2_d_p[9]}]
set_property PACKAGE_PIN K15  [get_ports {adc_ch2_d_n[9]}]
set_property PACKAGE_PIN L14  [get_ports {adc_ch2_d_p[10]}]
set_property PACKAGE_PIN L15  [get_ports {adc_ch2_d_n[10]}]
set_property PACKAGE_PIN M14  [get_ports {adc_ch2_d_p[11]}]
set_property PACKAGE_PIN M15  [get_ports {adc_ch2_d_n[11]}]
set_property PACKAGE_PIN N14  [get_ports {adc_ch2_d_p[12]}]
set_property PACKAGE_PIN N15  [get_ports {adc_ch2_d_n[12]}]
set_property PACKAGE_PIN P14  [get_ports {adc_ch2_d_p[13]}]
set_property PACKAGE_PIN P15  [get_ports {adc_ch2_d_n[13]}]
set_property PACKAGE_PIN R14  [get_ports {adc_ch2_d_p[14]}]
set_property PACKAGE_PIN R15  [get_ports {adc_ch2_d_n[14]}]
set_property PACKAGE_PIN T14  [get_ports {adc_ch2_d_p[15]}]
set_property PACKAGE_PIN T15  [get_ports {adc_ch2_d_n[15]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_ch2_d_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_ch2_d_n[*]}]

set_property PACKAGE_PIN A13  [get_ports adc_ch2_clk_p]
set_property PACKAGE_PIN A16  [get_ports adc_ch2_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports adc_ch2_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports adc_ch2_clk_n]

create_clock -period 4.762 -name adc_ch2_clk [get_ports adc_ch2_clk_p]

## ---------------------------------------------------------------------------
## ADC Channel 3 — LVDS data [15:0] + clock (LTC2107 Ch3)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN AA14 [get_ports {adc_ch3_d_p[0]}]
set_property PACKAGE_PIN AA15 [get_ports {adc_ch3_d_n[0]}]
set_property PACKAGE_PIN AB14 [get_ports {adc_ch3_d_p[1]}]
set_property PACKAGE_PIN AB15 [get_ports {adc_ch3_d_n[1]}]
set_property PACKAGE_PIN AC14 [get_ports {adc_ch3_d_p[2]}]
set_property PACKAGE_PIN AC15 [get_ports {adc_ch3_d_n[2]}]
set_property PACKAGE_PIN AD14 [get_ports {adc_ch3_d_p[3]}]
set_property PACKAGE_PIN AD15 [get_ports {adc_ch3_d_n[3]}]
set_property PACKAGE_PIN AE14 [get_ports {adc_ch3_d_p[4]}]
set_property PACKAGE_PIN AE15 [get_ports {adc_ch3_d_n[4]}]
set_property PACKAGE_PIN AF14 [get_ports {adc_ch3_d_p[5]}]
set_property PACKAGE_PIN AF15 [get_ports {adc_ch3_d_n[5]}]
set_property PACKAGE_PIN AG14 [get_ports {adc_ch3_d_p[6]}]
set_property PACKAGE_PIN AG15 [get_ports {adc_ch3_d_n[6]}]
set_property PACKAGE_PIN AH14 [get_ports {adc_ch3_d_p[7]}]
set_property PACKAGE_PIN AH15 [get_ports {adc_ch3_d_n[7]}]
set_property PACKAGE_PIN AJ14 [get_ports {adc_ch3_d_p[8]}]
set_property PACKAGE_PIN AJ15 [get_ports {adc_ch3_d_n[8]}]
set_property PACKAGE_PIN AK14 [get_ports {adc_ch3_d_p[9]}]
set_property PACKAGE_PIN AK15 [get_ports {adc_ch3_d_n[9]}]
set_property PACKAGE_PIN AL14 [get_ports {adc_ch3_d_p[10]}]
set_property PACKAGE_PIN AL15 [get_ports {adc_ch3_d_n[10]}]
set_property PACKAGE_PIN AM14 [get_ports {adc_ch3_d_p[11]}]
set_property PACKAGE_PIN AM15 [get_ports {adc_ch3_d_n[11]}]
set_property PACKAGE_PIN AN14 [get_ports {adc_ch3_d_p[12]}]
set_property PACKAGE_PIN AN15 [get_ports {adc_ch3_d_n[12]}]
set_property PACKAGE_PIN AP14 [get_ports {adc_ch3_d_p[13]}]
set_property PACKAGE_PIN AP15 [get_ports {adc_ch3_d_n[13]}]
set_property PACKAGE_PIN AR14 [get_ports {adc_ch3_d_p[14]}]
set_property PACKAGE_PIN AR15 [get_ports {adc_ch3_d_n[14]}]
set_property PACKAGE_PIN AT14 [get_ports {adc_ch3_d_p[15]}]
set_property PACKAGE_PIN AT15 [get_ports {adc_ch3_d_n[15]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_ch3_d_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_ch3_d_n[*]}]

set_property PACKAGE_PIN Y14 [get_ports adc_ch3_clk_p]
set_property PACKAGE_PIN Y15 [get_ports adc_ch3_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports adc_ch3_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports adc_ch3_clk_n]

create_clock -period 4.762 -name adc_ch3_clk [get_ports adc_ch3_clk_p]

## ---------------------------------------------------------------------------
## ADC Power Down — active-low, 4-bit bus
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN C11 [get_ports {adc_pd_n[0]}]
set_property PACKAGE_PIN D11 [get_ports {adc_pd_n[1]}]
set_property PACKAGE_PIN E11 [get_ports {adc_pd_n[2]}]
set_property PACKAGE_PIN F11 [get_ports {adc_pd_n[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_pd_n[*]}]

## ---------------------------------------------------------------------------
## LO1 SPI — LMX2820 synthesizer (dedicated SPI bus)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN H9  [get_ports lo1_spi_clk]
set_property PACKAGE_PIN J9  [get_ports lo1_spi_mosi]
set_property PACKAGE_PIN K9  [get_ports lo1_spi_miso]
set_property PACKAGE_PIN L9  [get_ports lo1_spi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports lo1_spi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports lo1_spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports lo1_spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports lo1_spi_cs_n]

set_input_delay  -clock [get_clocks clk_10mhz] -max 10.0 [get_ports lo1_spi_miso]
set_input_delay  -clock [get_clocks clk_10mhz] -min  2.0 [get_ports lo1_spi_miso]
set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports lo1_spi_clk]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports lo1_spi_clk]
set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports lo1_spi_mosi]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports lo1_spi_mosi]
set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports lo1_spi_cs_n]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports lo1_spi_cs_n]

## ---------------------------------------------------------------------------
## LO1 Lock Detect & MUX Out (asynchronous status from LMX2820)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN M9  [get_ports lo1_lock_detect]
set_property PACKAGE_PIN N9  [get_ports lo1_muxout]
set_property IOSTANDARD LVCMOS33 [get_ports lo1_lock_detect]
set_property IOSTANDARD LVCMOS33 [get_ports lo1_muxout]

set_false_path -from [get_ports lo1_lock_detect]
set_false_path -from [get_ports lo1_muxout]

## ---------------------------------------------------------------------------
## LO2 SPI — ADF4383 synthesizer (dedicated SPI bus)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN P9  [get_ports lo2_spi_clk]
set_property PACKAGE_PIN R9  [get_ports lo2_spi_mosi]
set_property PACKAGE_PIN T9  [get_ports lo2_spi_miso]
set_property PACKAGE_PIN U9  [get_ports lo2_spi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports lo2_spi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports lo2_spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports lo2_spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports lo2_spi_cs_n]

set_input_delay  -clock [get_clocks clk_10mhz] -max 10.0 [get_ports lo2_spi_miso]
set_input_delay  -clock [get_clocks clk_10mhz] -min  2.0 [get_ports lo2_spi_miso]
set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports lo2_spi_clk]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports lo2_spi_clk]
set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports lo2_spi_mosi]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports lo2_spi_mosi]
set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports lo2_spi_cs_n]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports lo2_spi_cs_n]

## ---------------------------------------------------------------------------
## LO2 Lock Detect (asynchronous status from ADF4383)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN V9  [get_ports lo2_lock_detect]
set_property IOSTANDARD LVCMOS33 [get_ports lo2_lock_detect]

set_false_path -from [get_ports lo2_lock_detect]

## ---------------------------------------------------------------------------
## UART Host Interface (RS-422 / LVCMOS33)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN W9  [get_ports uart_tx]
set_property PACKAGE_PIN W10 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]

set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports uart_tx]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports uart_tx]
set_input_delay  -clock [get_clocks clk_10mhz] -max 10.0 [get_ports uart_rx]
set_input_delay  -clock [get_clocks clk_10mhz] -min  2.0 [get_ports uart_rx]

## ---------------------------------------------------------------------------
## VGA SPI / Serial DAC — TGL2767 VGA gain control (per-channel SPI DAC)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN AA9  [get_ports vga_spi_clk]
set_property PACKAGE_PIN AB9  [get_ports vga_spi_mosi]
set_property PACKAGE_PIN AC9  [get_ports vga_spi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports vga_spi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports vga_spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports vga_spi_cs_n]

set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports vga_spi_clk]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports vga_spi_clk]
set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports vga_spi_mosi]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports vga_spi_mosi]
set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports vga_spi_cs_n]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports vga_spi_cs_n]

## ---------------------------------------------------------------------------
## YIG Preselector Bias Control (static / slow DAC outputs)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN AD9  [get_ports {yig_bias[0]}]
set_property PACKAGE_PIN AE9  [get_ports {yig_bias[1]}]
set_property PACKAGE_PIN AF9  [get_ports {yig_bias[2]}]
set_property PACKAGE_PIN AG9  [get_ports {yig_bias[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {yig_bias[*]}]

set_false_path -from [get_ports {yig_bias[*]}]

## ---------------------------------------------------------------------------
## System Status LEDs (4)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN AH9  [get_ports {led[0]}]
set_property PACKAGE_PIN AJ9  [get_ports {led[1]}]
set_property PACKAGE_PIN AK9  [get_ports {led[2]}]
set_property PACKAGE_PIN AL9  [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports {led[*]}]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports {led[*]}]

## ---------------------------------------------------------------------------
## Data Output Connector — 60-pin Samtec LSHM (high-speed data link)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN AM9  [get_ports {data_out[0]}]
set_property PACKAGE_PIN AN9  [get_ports {data_out[1]}]
set_property PACKAGE_PIN AP9  [get_ports {data_out[2]}]
set_property PACKAGE_PIN AR9  [get_ports {data_out[3]}]
set_property PACKAGE_PIN AT9  [get_ports {data_out[4]}]
set_property PACKAGE_PIN AU9  [get_ports {data_out[5]}]
set_property PACKAGE_PIN AV9  [get_ports {data_out[6]}]
set_property PACKAGE_PIN AW9  [get_ports {data_out[7]}]
set_property PACKAGE_PIN BA9  [get_ports {data_out[8]}]
set_property PACKAGE_PIN BB9  [get_ports {data_out[9]}]
set_property PACKAGE_PIN BC9  [get_ports {data_out[10]}]
set_property PACKAGE_PIN BD9  [get_ports {data_out[11]}]
set_property PACKAGE_PIN BE9  [get_ports {data_out[12]}]
set_property PACKAGE_PIN BF9  [get_ports {data_out[13]}]
set_property PACKAGE_PIN BG9  [get_ports {data_out[14]}]
set_property PACKAGE_PIN BH9  [get_ports {data_out[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out[*]}]

set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports {data_out[*]}]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports {data_out[*]}]

## ---------------------------------------------------------------------------
## Data Output Clock (source-synchronous strobe)
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN BJ9  [get_ports data_clk_out]
set_property IOSTANDARD LVCMOS33 [get_ports data_clk_out]

set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports data_clk_out]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports data_clk_out]

## ---------------------------------------------------------------------------
## Data Output Frame Sync
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN BK9  [get_ports data_frame_sync]
set_property IOSTANDARD LVCMOS33 [get_ports data_frame_sync]

set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports data_frame_sync]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports data_frame_sync]

## ---------------------------------------------------------------------------
## Data Output Valid
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN BL9  [get_ports data_valid_out]
set_property IOSTANDARD LVCMOS33 [get_ports data_valid_out]

set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports data_valid_out]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports data_valid_out]

## ---------------------------------------------------------------------------
## JTAG — FPGA configuration & debug (10-pin header J6)
## ---------------------------------------------------------------------------
## JTAG pins are dedicated — no IOSTANDARD or PACKAGE_PIN assignment required
## set_property IOSTANDARD LVCMOS33 [get_ports jtag_tck]
## set_property IOSTANDARD LVCMOS33 [get_ports jtag_tms]
## set_property IOSTANDARD LVCMOS33 [get_ports jtag_tdi]
## set_property IOSTANDARD LVCMOS33 [get_ports jtag_tdo]

## ---------------------------------------------------------------------------
## Power Supply Enable Controls
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN BM9  [get_ports {pwr_enable[0]}]
set_property PACKAGE_PIN BN9  [get_ports {pwr_enable[1]}]
set_property PACKAGE_PIN BP9  [get_ports {pwr_enable[2]}]
set_property PACKAGE_PIN BR9  [get_ports {pwr_enable[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwr_enable[*]}]

set_false_path -from [get_ports {pwr_enable[*]}]

## ---------------------------------------------------------------------------
## IRQ Output to Host
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN BS9  [get_ports irq_out]
set_property IOSTANDARD LVCMOS33 [get_ports irq_out]

set_output_delay -clock [get_clocks clk_10mhz] -max 10.0 [get_ports irq_out]
set_output_delay -clock [get_clocks clk_10mhz] -min  2.0 [get_ports irq_out]

## ---------------------------------------------------------------------------
## GPIO Header — General-purpose I/O [7:0]
## ---------------------------------------------------------------------------
set_property PACKAGE_PIN BT9  [get_ports {gpio[0]}]
set_property PACKAGE_PIN BU9  [get_ports {gpio[1]}]
set_property PACKAGE_PIN BV9  [get_ports {gpio[2]}]
set_property PACKAGE_PIN BW9  [get_ports {gpio[3]}]
set_property PACKAGE_PIN BT10 [get_ports {gpio[4]}]
set_property PACKAGE_PIN BU10 [get_ports {gpio[5]}]
set_property PACKAGE_PIN BV10 [get_ports {gpio[6]}]
set_property PACKAGE_PIN BW10 [get_ports {gpio[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[*]}]

set_input_delay  -clock [get_clocks clk_10mhz] -max 10.0 [get_ports {gpio[*]}]
set_input_delay  -clock [get_clocks clk_10mhz] -min  2.0 [get_ports {gpio[*]}]

## ---------------------------------------------------------------------------
## Clock Domain Crossing — False Paths between asynchronous clock domains
## ---------------------------------------------------------------------------
## ADC clocks (210 MHz = ~4.762 ns period) are asynchronous to the 10 MHz OCXO
set_clock_groups -asynchronous \
    -group [get_clocks clk_10mhz] \
    -group [get_clocks adc_ch0_clk] \
    -group [get_clocks adc_ch1_clk] \
    -group [get_clocks adc_ch2_clk] \
    -group [get_clocks adc_ch3_clk]

## ---------------------------------------------------------------------------
## Timing Constraints — Derating for Industrial Grade (-40C to +100C)
## ---------------------------------------------------------------------------
set_operating_conditions -grade industrial

## ---------------------------------------------------------------------------
## Bitstream Configuration Settings
## ---------------------------------------------------------------------------
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLDOWN [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK ENABLE [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## ---------------------------------------------------------------------------
## Drive Strength & Slew for High-Speed Outputs
## ---------------------------------------------------------------------------
set_property DRIVE 12 [get_ports {data_out[*]}]
set_property SLEW FAST [get_ports {data_out[*]}]
set_property DRIVE 12 [get_ports data_clk_out]
set_property SLEW FAST [get_ports data_clk_out]
set_property DRIVE 12 [get_ports data_frame_sync]
set_property SLEW FAST [get_ports data_frame_sync]
set_property DRIVE 12 [get_ports data_valid_out]
set_property SLEW FAST [get_ports data_valid_out]

## SPI outputs — moderate slew
set_property DRIVE 8 [get_ports lo1_spi_clk]
set_property SLEW SLOW [get_ports lo1_spi_clk]
set_property DRIVE 8 [get_ports lo1_spi_mosi]
set_property SLEW SLOW [get_ports lo1_spi_mosi]
set_property DRIVE 8 [get_ports lo1_spi_cs_n]
set_property SLEW SLOW [get_ports lo1_spi_cs_n]
set_property DRIVE 8 [get_ports lo2_spi_clk]
set_property SLEW SLOW [get_ports lo2_spi_clk]
set_property DRIVE 8 [get_ports lo2_spi_mosi]
set_property SLEW SLOW [get_ports lo2_spi_mosi]
set_property DRIVE 8 [get_ports lo2_spi_cs_n]
set_property SLEW SLOW [get_ports lo2_spi_cs_n]
set_property DRIVE 8 [get_ports vga_spi_clk]
set_property SLEW SLOW [get_ports vga_spi_clk]
set_property DRIVE 8 [get_ports vga_spi_mosi]
set_property SLEW SLOW [get_ports vga_spi_mosi]
set_property DRIVE 8 [get_ports vga_spi_cs_n]
set_property SLEW SLOW [get_ports vga_spi_cs_n]

## ---------------------------------------------------------------------------
## End of Constraints File
## ---------------------------------------------------------------------------