# Register Description Table (RDT)
## khg

> **Total registers:** 72

khg Wideband RF Receiver FPGA register map and initialization sequence covering board identification, RF front-end control (LNA/attenuator), JESD204B/C ADC interface, LMX2594 PLL clock synthesis, power supply monitoring, temperature sensing, GPIO, flash/EEPROM storage, and communication interfaces.

---
## Register Address Decoding

The 16-bit UART register address is decoded as follows:

| Bit(s) | Field | Description |
|--------|-------|-------------|
| [15] | R/W# | 1 = Read operation, 0 = Write operation |
| [14] | Reserved | Must be 0 |
| [13:12] | Reserved | Must be 0 |
| [11:8] | BASE_ADDR[3:0] | Functional group selector |
| [7:0] | OFFSET[7:0] | Register offset within group |

### Base Address Map

| BASE[3:0] | Address Range | Functional Group |
|-----------|--------------|-----------------|
| 0x0 | 0x0000–0x00FF | Board Information |
| 0x1 | 0x0100–0x01FF | Communication & Interface |
| 0x2 | 0x0200–0x02FF | ADC / Supply Monitoring |
| 0x3 | 0x0300–0x03FF | Temperature & Health |
| 0x4 | 0x0400–0x04FF | PLL / Clock Configuration |
| 0x5 | 0x0500–0x05FF | EEPROM / NV Storage |
| 0x6 | 0x0600–0x06FF | Configuration Flash |
| 0x7 | 0x0700–0x07FF | RF / Phase Control |
| 0x8 | 0x0800–0x08FF | GPIO / Control |
| 0x9 | 0x0900–0x09FF | DAC / Output |

---
## UART Frame Formats

### Single Register Write
```
TX: [0x57 'W'] [ADDR_MSB (bit15=0)] [ADDR_LSB] [DATA_MSB] [DATA_LSB]
RX: [ACK=0x06] or [NAK=0x15]
```

### Single Register Read
```
TX: [0x52 'R'] [ADDR_MSB (bit15=1)] [ADDR_LSB]
RX: [DATA_MSB] [DATA_LSB]
```

### Bulk Write (N consecutive registers)
```
TX: [0x42 'B'] [START_ADDR_MSB] [START_ADDR_LSB] [NUM_REGS (1 byte)]
    [D0_MSB] [D0_LSB] ... [DN-1_MSB] [DN-1_LSB]
RX: [ACK=0x06]
```

### Bulk Read (N consecutive registers)
```
TX: [0x62 'b'] [START_ADDR_MSB|0x80] [START_ADDR_LSB] [NUM_REGS]
RX: [D0_MSB] [D0_LSB] ... [DN-1_MSB] [DN-1_LSB]
```

---
## Register Definitions

| Address | Register Name | Access | Reset | Description |
|---------|--------------|--------|-------|-------------|
| `0x0000` | `BOARD_ID` | — | `0x4B48 0x475F` | Board identification code — ASCII 'KHG_' (0x4B48_475F) uniquely identifies the khg Wideband RF Receiver hardware. |
| `0x0001` | `BOARD_VERSION` | — | `0x01` | Hardware version number — major.minor format for revision tracking and BOM correlation. |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0001` | Board type identifier — maps to product family (0x0001 = khg RF Receiver). |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | Diagnostic read/write test register for RAM integrity verification and communication sanity check. |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x01` | FPGA firmware major version number for build tracking. |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x00` | FPGA firmware minor version number. |
| `0x0012` | `BUILD_DATE` | — | `0x20260416` | Firmware build date in packed BCD format (YYYYMMDD). |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0034` | UART baud rate divisor for 115200 baud @ 100 MHz clock (100e6/115200/16 = 54 = 0x36, default provides safe rate). |
| `0x0101` | `UART_CTRL` | — | `0x00` | UART control register — enables UART, loopback mode, and frame format configuration. |
| `0x0102` | `UART_STATUS` | — | `0x00` | UART status flags — read-clear on read for error conditions. |
| `0x0103` | `UART_TX_COUNT` | — | `0x00` | TX FIFO fill level for flow control. |
| `0x0104` | `UART_RX_COUNT` | — | `0x00` | RX FIFO fill level for flow control. |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Lower 16 bits of Ethernet MAC address (bytes [1:0]). |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Upper 16 bits of Ethernet MAC address (bytes [5:4]). |
| `0x0200` | `ADC_CTRL` | — | `0x00` | ADC12DJ5200RF control — JESD204B/C interface control for the dual-channel 12-bit ADC. |
| `0x0201` | `ADC_STATUS` | — | `0x00` | ADC status flags — monitors data ready, JESD link alignment, and error conditions. |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC raw count — 12-bit ADC, multiply by 5.0/4096 for Volts. |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC raw count from TPS7A4700 monitoring — scale by 3.3/4096. |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC raw count from TPS7A47 LDO — scale by 2.5/4096. |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC raw count from TPS7A47 LDO — scale by 1.8/4096. |
| `0x0214` | `VCC_1V0_RAW` | — | `0x0000` | 1.0V rail ADC raw count from TPS62913 buck converter — scale by 1.0/4096. |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC raw count — scale according to sense gain. |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC raw count. |
| `0x0300` | `TEMP_LOCAL` | — | `0x190` | FPGA die temperature in 0.25°C units (signed) — reset = +100°C (0x190) for testing. |
| `0x0301` | `TEMP_RF_LNA` | — | `0x0C8` | Remote temperature sensor near TQM473552 LNA in 0.25°C units — reset = +50°C. |
| `0x0302` | `TEMP_PLL` | — | `0x0C8` | Remote temperature sensor near LMX2594 PLL in 0.25°C units. |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold — default 100°C (0x190 = 400 * 0.25). |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold — default -25°C (0xFF9C = -100 * 0.25). |
| `0x030F` | `HEALTH_STATUS` | — | `0x00` | System health summary — aggregates temperature, voltage, PLL lock, and overall system status. |
| `0x0400` | `PLL_CTRL` | — | `0x00` | LMX2594 wideband PLL control — 10-20 GHz VCO synthesizer for LO generation. |
| `0x0401` | `PLL_STATUS` | — | `0x00` | PLL status flags — monitors lock state and alarm conditions. |
| `0x0402` | `PLL_N_DIV` | — | `0x0064` | PLL N divider value — integer divider for VCO frequency synthesis (reset=100). |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R divider for reference input — reset=1 (no division). |
| `0x0404` | `PLL_FRAC_MSB` | — | `0x0000` | PLL fractional divider MSW — enables fine frequency resolution for LO. |
| `0x0405` | `PLL_FRAC_LSB` | — | `0x0000` | PLL fractional divider LSW — enables fine frequency resolution for LO. |
| `0x0408` | `RF_OUT_FREQ_MSB` | — | `0x07A0` | RF output frequency control MSW — desired LO frequency in MHz (reset=19520 MHz). |
| `0x0409` | `RF_OUT_FREQ_LSB` | — | `0x0000` | RF output frequency control LSW — desired LO frequency in MHz. |
| `0x0410` | `CLK_ENABLE` | — | `0x00` | Clock output enables — distributes LMX2594 clocks throughout the system. |
| `0x0420` | `JESD_CTRL` | — | `0x02` | JESD204B/C interface control — configures link parameters for ADC12DJ5200RF. |
| `0x0421` | `JESD_STATUS` | — | `0x00` | JESD204B/C link status — monitors lane alignment and synchronization. |
| `0x0500` | `EEPROM_CTRL` | — | `0x00` | EEPROM control register — manages read/write/erase operations for calibration storage. |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address for read/write operations. |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM data register — written data is latched, read data is returned here. |
| `0x0503` | `EEPROM_STATUS` | — | `0x00` | EEPROM operation status — reports completion and errors. |
| `0x0600` | `FLASH_CTRL` | — | `0x00` | Configuration flash control — manages FPGA bitstream and configuration storage. |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address low word — bits [15:0] of byte address. |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address high word — bits [23:16] of byte address. |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash data FIFO — written data is programmed, read data is returned. |
| `0x0604` | `FLASH_STATUS` | — | `0x01` | Flash status flags — reports ready state and errors. |
| `0x0700` | `RFE_CTRL` | — | `0x00` | RF Front-End control — manages LNA enable and overall RF chain power. |
| `0x0701` | `ATTENUATOR_CTRL` | — | `0x3F` | HMC698LP4 6-bit digital attenuator control — 0.5dB steps, 31.5dB range. |
| `0x0702` | `GAIN_CTRL` | — | `0x20` | RF gain control — coarse gain adjustment combining LNA and attenuator settings. |
| `0x0703` | `IQ_MIXER_CTRL` | — | `0x00` | MWC-1440+ IQ mixer control — manages LO interface and mixer bias. |
| `0x0704` | `IF_AMP_CTRL` | — | `0x00` | ADA4817-1 IF amplifier control — manages dual high-gain amps after mixer. |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control — 0=input, 1=output for each of 16 GPIO pins. |
| `0x0801` | `GPIO_DATA_OUT` | — | `0x0000` | GPIO output data — written to pins configured as outputs. |
| `0x0802` | `GPIO_DATA_IN` | — | `0x0000` | GPIO input data — read state of pins configured as inputs. |
| `0x0803` | `GPIO_INT_EN` | — | `0x0000` | GPIO interrupt enable — enables edge detection interrupt for each pin. |
| `0x0804` | `GPIO_INT_TYPE` | — | `0x0000` | GPIO interrupt type — selects rising/falling/both edge detection. |
| `0x0805` | `GPIO_INT_STATUS` | — | `0x0000` | GPIO interrupt status — read to get pending interrupts, write-1 to clear. |
| `0x0900` | `DAC0_DATA` | — | `0x8000` | DAC channel 0 data — 16-bit value for auxiliary DAC output (e.g., bias control). |
| `0x0901` | `DAC1_DATA` | — | `0x8000` | DAC channel 1 data — 16-bit value for auxiliary DAC output. |
| `0x0902` | `DAC_CTRL` | — | `0x00` | DAC control register — enables DAC channels and configures output format. |
| `0x0A00` | `AGC_CONFIG` | — | `0x0001` | Automatic Gain Control configuration — enables AGC algorithm and sets parameters. |
| `0x0A01` | `AGC_STATUS` | — | `0x00` | AGC status — reports current gain state and activity. |
| `0x0B00` | `CALIBRATION_CTRL` | — | `0x00` | Calibration control — initiates factory and runtime calibration routines. |
| `0x0B01` | `CALIBRATION_STATUS` | — | `0x00` | Calibration status — reports calibration completion and results. |
| `0x0C00` | `EVENT_LOG_CTRL` | — | `0x00` | Event log control — configures system event logging for diagnostics. |
| `0x0C01` | `EVENT_LOG_STATUS` | — | `0x00` | Event log status — reports log buffer state and entry count. |
| `0x0C02` | `EVENT_LOG_DATA` | — | `0x0000` | Event log data read — read to fetch next log entry (auto-increments pointer). |
| `0x0D00` | `TEST_CTRL` | — | `0x00` | Manufacturing test control — enables built-in self-test and diagnostic modes. |
| `0x0D01` | `TEST_STATUS` | — | `0x00` | Manufacturing test status — reports BIST results and error codes. |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x4B48 0x475F`  **Access:** see fields below

Board identification code — ASCII 'KHG_' (0x4B48_475F) uniquely identifies the khg Wideband RF Receiver hardware.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ID_SIGNATURE` | `[15:0]` | R | `0x4B48_475F` | ASCII board identifier 'KHG_' |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x01`  **Access:** see fields below

Hardware version number — major.minor format for revision tracking and BOM correlation.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR_VERSION` | `[7:4]` | R | `0x0` | Major version number — updated for PCB or form-factor changes |
| `MINOR_VERSION` | `[3:0]` | R | `0x1` | Minor version number — updated for component BOM changes |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0001`  **Access:** see fields below

Board type identifier — maps to product family (0x0001 = khg RF Receiver).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_CODE` | `[15:0]` | R | `0x0001` | Product family type code |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

Diagnostic read/write test register for RAM integrity verification and communication sanity check.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_PATTERN` | `[15:0]` | R/W | `0x0000` | General-purpose test pattern storage |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x01`  **Access:** see fields below

FPGA firmware major version number for build tracking.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MAJOR` | `[7:0]` | R | `0x01` | Firmware major version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x00`  **Access:** see fields below

FPGA firmware minor version number.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FW_MINOR` | `[7:0]` | R | `0x00` | Firmware minor version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x20260416`  **Access:** see fields below

Firmware build date in packed BCD format (YYYYMMDD).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR_BCD` | `[15:12]` | R | `0x2` | Build year (MS nibble) |
| `BUILD_DATE_BCD` | `[11:0]` | R | `0x026_0416` | MMDD packed BCD |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0034`  **Access:** see fields below

UART baud rate divisor for 115200 baud @ 100 MHz clock (100e6/115200/16 = 54 = 0x36, default provides safe rate).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | R/W | `0x0034` | Baud rate divisor (f_clk / (16 * baud_rate)) |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x00`  **Access:** see fields below

UART control register — enables UART, loopback mode, and frame format configuration.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | R/W | `0` | UART enable (1=enabled) |
| `LOOPBACK` | `[1]` | R/W | `0` | Internal loopback for test |
| `PARITY_EN` | `[2]` | R/W | `0` | Parity enable |
| `FRAME_FORMAT` | `[7:4]` | R/W | `0x0` | Frame format (0000=8N1) |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x00`  **Access:** see fields below

UART status flags — read-clear on read for error conditions.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | R | `0` | Transmitter busy flag |
| `RX_AVAIL` | `[1]` | R | `0` | Data available in RX FIFO |
| `FRAME_ERR` | `[2]` | R/C | `0` | Framing error (clear on read) |
| `PARITY_ERR` | `[3]` | R/C | `0` | Parity error (clear on read) |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x00`  **Access:** see fields below

TX FIFO fill level for flow control.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | Number of bytes in TX FIFO |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x00`  **Access:** see fields below

RX FIFO fill level for flow control.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RX_FIFO_LEVEL` | `[7:0]` | R | `0x00` | Number of bytes in RX FIFO |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Lower 16 bits of Ethernet MAC address (bytes [1:0]).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_BYTES_1_0` | `[15:0]` | R | `0x0000` | MAC address bytes 1 and 0 |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Upper 16 bits of Ethernet MAC address (bytes [5:4]).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_BYTES_5_4` | `[15:0]` | R | `0x0000` | MAC address bytes 5 and 4 |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x00`  **Access:** see fields below

ADC12DJ5200RF control — JESD204B/C interface control for the dual-channel 12-bit ADC.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_EN` | `[0]` | R/W | `0` | ADC enable (1=powered and sampling) |
| `JESD_EN` | `[1]` | R/W | `0` | JESD204B/C link enable |
| `CHANNEL_SEL` | `[3:2]` | R/W | `0x0` | Channel select (00=ch1, 01=ch2, 10=dual) |
| `SYNC_POLARITY` | `[4]` | R/W | `0` | SYNC~ signal polarity (0=active low) |
| `SUBCLASS` | `[6:5]` | R/W | `0x1` | JESD subclass (01=Subclass 1 with SYSREF) |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x00`  **Access:** see fields below

ADC status flags — monitors data ready, JESD link alignment, and error conditions.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | R | `0` | ADC data valid flag |
| `JESD_ALIGNED` | `[1]` | R | `0` | JESD204B/C link aligned (ILAS complete) |
| `OVERRANGE` | `[2]` | R/C | `0` | ADC input overrange detected (clear on read) |
| `DISPERR` | `[3]` | R/C | `0` | JESD disparity error (clear on read) |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC raw count — 12-bit ADC, multiply by 5.0/4096 for Volts.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count (0-4095) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC raw count from TPS7A4700 monitoring — scale by 3.3/4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count (0-4095) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC raw count from TPS7A47 LDO — scale by 2.5/4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count (0-4095) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC raw count from TPS7A47 LDO — scale by 1.8/4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count (0-4095) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `VCC_1V0_RAW` — Address `0x0214`

**Reset value:** `0x0000`  **Access:** see fields below

1.0V rail ADC raw count from TPS62913 buck converter — scale by 1.0/4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count (0-4095) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC raw count — scale according to sense gain.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw current ADC count (0-4095) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC raw count.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw current ADC count (0-4095) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x190`  **Access:** see fields below

FPGA die temperature in 0.25°C units (signed) — reset = +100°C (0x190) for testing.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_CODE` | `[9:0]` | R | `0x190` | Temperature = value * 0.25°C (signed 10-bit) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved |

---
### `TEMP_RF_LNA` — Address `0x0301`

**Reset value:** `0x0C8`  **Access:** see fields below

Remote temperature sensor near TQM473552 LNA in 0.25°C units — reset = +50°C.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_CODE` | `[9:0]` | R | `0x0C8` | LNA temperature = value * 0.25°C (signed) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved |

---
### `TEMP_PLL` — Address `0x0302`

**Reset value:** `0x0C8`  **Access:** see fields below

Remote temperature sensor near LMX2594 PLL in 0.25°C units.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_CODE` | `[9:0]` | R | `0x0C8` | PLL temperature = value * 0.25°C (signed) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold — default 100°C (0x190 = 400 * 0.25).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | R/W | `0x190` | High temp threshold = value * 0.25°C |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold — default -25°C (0xFF9C = -100 * 0.25).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | R/W | `0xFF9C` | Low temp threshold = value * 0.25°C (signed) |
| `RESERVED` | `[15:10]` | R | `0x0` | Reserved |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x00`  **Access:** see fields below

System health summary — aggregates temperature, voltage, PLL lock, and overall system status.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0` | Temperature within limits (1=OK) |
| `VOLT_OK` | `[1]` | R | `0` | All voltage rails within tolerance (1=OK) |
| `PLL_LOCK` | `[2]` | R | `0` | PLL lock detected (1=locked) |
| `JESD_LINK_OK` | `[3]` | R | `0` | JESD204B/C link aligned (1=OK) |
| `CURRENT_OK` | `[4]` | R | `0` | Current sense within limits (1=OK) |
| `RESERVED` | `[6:5]` | R | `0x0` | Reserved |
| `SYSTEM_OK` | `[7]` | R | `0` | Overall system health (all checks pass) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x00`  **Access:** see fields below

LMX2594 wideband PLL control — 10-20 GHz VCO synthesizer for LO generation.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PLL_EN` | `[0]` | R/W | `0` | PLL enable (1=enabled) |
| `PLL_RESET` | `[1]` | R/W | `0` | PLL reset (1=assert reset, self-clearing) |
| `REF_SEL` | `[3:2]` | R/W | `0x0` | Reference clock select (00=XTAL, 01=EXT CLK) |
| `OUTPUT_EN` | `[4]` | R/W | `0` | RF output enable (1=RF out enabled) |
| `MUTE` | `[5]` | R/W | `1` | RF output mute (1=muted) |
| `RESERVED` | `[15:6]` | R | `0x0` | Reserved |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x00`  **Access:** see fields below

PLL status flags — monitors lock state and alarm conditions.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | R | `0` | PLL locked (1=lock detected) |
| `LOSS_OF_LOCK` | `[1]` | R/C | `0` | Loss of lock event (clear on read) |
| `ALARM` | `[2]` | R | `0` | PLL alarm flag (VCO/coil detect) |
| `RESERVED` | `[15:3]` | R | `0x0` | Reserved |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0064`  **Access:** see fields below

PLL N divider value — integer divider for VCO frequency synthesis (reset=100).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_VALUE` | `[15:0]` | R/W | `0x0064` | N divider integer (2-65535) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R divider for reference input — reset=1 (no division).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_VALUE` | `[7:0]` | R/W | `0x01` | R divider (1-128) |
| `RESERVED` | `[15:8]` | R | `0x00` | Reserved |

---
### `PLL_FRAC_MSB` — Address `0x0404`

**Reset value:** `0x0000`  **Access:** see fields below

PLL fractional divider MSW — enables fine frequency resolution for LO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FRAC_MSB` | `[15:0]` | R/W | `0x0000` | Fractional divider bits [31:16] |

---
### `PLL_FRAC_LSB` — Address `0x0405`

**Reset value:** `0x0000`  **Access:** see fields below

PLL fractional divider LSW — enables fine frequency resolution for LO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FRAC_LSB` | `[15:0]` | R/W | `0x0000` | Fractional divider bits [15:0] |

---
### `RF_OUT_FREQ_MSB` — Address `0x0408`

**Reset value:** `0x07A0`  **Access:** see fields below

RF output frequency control MSW — desired LO frequency in MHz (reset=19520 MHz).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_MSB` | `[15:0]` | R/W | `0x07A0` | RF frequency [31:16] in MHz units |

---
### `RF_OUT_FREQ_LSB` — Address `0x0409`

**Reset value:** `0x0000`  **Access:** see fields below

RF output frequency control LSW — desired LO frequency in MHz.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_LSB` | `[15:0]` | R/W | `0x0000` | RF frequency [15:0] in MHz units |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x00`  **Access:** see fields below

Clock output enables — distributes LMX2594 clocks throughout the system.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_ADC_EN` | `[0]` | R/W | `0` | ADC sample clock enable (JESD device clock) |
| `CLK_FPGA_EN` | `[1]` | R/W | `0` | FPGA system clock enable |
| `CLK_SYSREF_EN` | `[2]` | R/W | `0` | SYSREF output enable (JESD Subclass 1) |
| `CLK_LO_DISTRIBUTED_EN` | `[3]` | R/W | `0` | LO distribution to mixer enable |
| `RESERVED` | `[15:4]` | R | `0x0` | Reserved |

---
### `JESD_CTRL` — Address `0x0420`

**Reset value:** `0x02`  **Access:** see fields below

JESD204B/C interface control — configures link parameters for ADC12DJ5200RF.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_EN` | `[0]` | R/W | `0` | JESD link enable |
| `SUBCLASS` | `[2:1]` | R/W | `0x1` | JESD subclass (01=Subclass 1 with SYSREF) |
| `LANES` | `[5:4]` | R/W | `0x0` | Number of lanes (00=1, 01=2, 10=4) |
| `SYSREF_MODE` | `[7:6]` | R/W | `0x0` | SYSREF mode (00=continuous, 01=one-shot) |
| `RESERVED` | `[15:8]` | R | `0x0` | Reserved |

---
### `JESD_STATUS` — Address `0x0421`

**Reset value:** `0x00`  **Access:** see fields below

JESD204B/C link status — monitors lane alignment and synchronization.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_READY` | `[0]` | R | `0` | Link ready (code group sync complete) |
| `ILAS_COMPLETE` | `[1]` | R | `0` | Initial Lane Alignment Sequence complete |
| `SYSREF_DET` | `[2]` | R | `0` | SYSREF detected |
| `DISP_ERR` | `[3]` | R/C | `0` | Disparity error detected (clear on read) |
| `RESERVED` | `[15:4]` | R | `0x0` | Reserved |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM control register — manages read/write/erase operations for calibration storage.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | R/W | `0` | Start read operation |
| `WRITE` | `[1]` | R/W | `0` | Start write operation |
| `ERASE` | `[2]` | R/W | `0` | Start erase operation |
| `UNLOCK` | `[3]` | W | `0` | Write unlock (must be 1 for write/erase) |
| `BUSY` | `[7]` | R | `0` | Operation in progress (1=busy) |
| `RESERVED` | `[15:8]` | R | `0x0` | Reserved |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address for read/write operations.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BYTE_ADDR` | `[15:0]` | R/W | `0x0000` | 16-bit byte address (supports up to 64KB) |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM data register — written data is latched, read data is returned here.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | R/W | `0x0000` | 16-bit data word (two bytes) |

---
### `EEPROM_STATUS` — Address `0x0503`

**Reset value:** `0x00`  **Access:** see fields below

EEPROM operation status — reports completion and errors.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DONE` | `[0]` | R | `0` | Operation complete (1=done) |
| `WRITE_ERR` | `[1]` | R/C | `0` | Write protection error (clear on read) |
| `TIMEOUT` | `[2]` | R/C | `0` | Operation timeout (clear on read) |
| `RESERVED` | `[15:3]` | R | `0x0` | Reserved |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x00`  **Access:** see fields below

Configuration flash control — manages FPGA bitstream and configuration storage.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | R/W | `0` | Flash read enable |
| `WRITE` | `[1]` | R/W | `0` | Flash write enable |
| `ERASE_SECTOR` | `[2]` | R/W | `0` | Erase sector (4KB typical) |
| `ERASE_CHIP` | `[3]` | R/W | `0` | Erase entire chip |
| `UNLOCK` | `[4]` | W | `0` | Write unlock (sequence 0xA5, 0xF1 required) |
| `BUSY` | `[7]` | R | `0` | Flash busy (1=operation in progress) |
| `RESERVED` | `[15:8]` | R | `0x0` | Reserved |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address low word — bits [15:0] of byte address.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | R/W | `0x0000` | Flash address bits [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address high word — bits [23:16] of byte address.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | R/W | `0x00` | Flash address bits [23:16] |
| `RESERVED` | `[15:8]` | R | `0x00` | Reserved |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash data FIFO — written data is programmed, read data is returned.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | R/W | `0x0000` | 16-bit data word |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x01`  **Access:** see fields below

Flash status flags — reports ready state and errors.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `1` | Flash ready (1=idle/ready) |
| `WRITE_ERR` | `[1]` | R/C | `0` | Write error (clear on read) |
| `ERASE_ERR` | `[2]` | R/C | `0` | Erase error (clear on read) |
| `PROTECT_ERR` | `[3]` | R/C | `0` | Protection error (clear on read) |
| `RESERVED` | `[15:4]` | R | `0x0` | Reserved |

---
### `RFE_CTRL` — Address `0x0700`

**Reset value:** `0x00`  **Access:** see fields below

RF Front-End control — manages LNA enable and overall RF chain power.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_EN` | `[0]` | R/W | `0` | LNA TQM473552 enable (1=powered) |
| `RFE_PWR_DWN` | `[1]` | R/W | `0` | RF front-end power down (1=power save mode) |
| `BYPASS_LNA` | `[2]` | R/W | `0` | LNA bypass (direct path, 1=bypass) |
| `RF_INPUT_EN` | `[3]` | R/W | `0` | RF input enable (controls limiter/bypass) |
| `RESERVED` | `[15:4]` | R | `0x0` | Reserved |

---
### `ATTENUATOR_CTRL` — Address `0x0701`

**Reset value:** `0x3F`  **Access:** see fields below

HMC698LP4 6-bit digital attenuator control — 0.5dB steps, 31.5dB range.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ATTENUATION` | `[5:0]` | R/W | `0x3F` | Attenuation code (0-63), step=0.5dB, max=31.5dB |
| `LOAD` | `[6]` | R/W | `0` | Load attenuation value to latch (1=load) |
| `RESERVED` | `[15:7]` | R | `0x0` | Reserved |

---
### `GAIN_CTRL` — Address `0x0702`

**Reset value:** `0x20`  **Access:** see fields below

RF gain control — coarse gain adjustment combining LNA and attenuator settings.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN_CODE` | `[7:0]` | R/W | `0x20` | Gain code (0-255, mapped to gain table) |
| `GAIN_FREEZE` | `[8]` | R/W | `0` | Freeze AGC (1=manual mode) |
| `RESERVED` | `[15:9]` | R | `0x0` | Reserved |

---
### `IQ_MIXER_CTRL` — Address `0x0703`

**Reset value:** `0x00`  **Access:** see fields below

MWC-1440+ IQ mixer control — manages LO interface and mixer bias.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MIXER_EN` | `[0]` | R/W | `0` | Mixer enable (1=powered) |
| `IQ_SWAP` | `[1]` | R/W | `0` | I/Q swap (1=swap I and Q) |
| `LO_BUFFER_EN` | `[2]` | R/W | `0` | LO input buffer enable |
| `DC_OFFSET_TRIM` | `[6:4]` | R/W | `0x4` | DC offset trim (0-7) |
| `RESERVED` | `[15:7]` | R | `0x0` | Reserved |

---
### `IF_AMP_CTRL` — Address `0x0704`

**Reset value:** `0x00`  **Access:** see fields below

ADA4817-1 IF amplifier control — manages dual high-gain amps after mixer.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `AMP1_EN` | `[0]` | R/W | `0` | IF amplifier 1 enable (I-channel) |
| `AMP2_EN` | `[1]` | R/W | `0` | IF amplifier 2 enable (Q-channel) |
| `GAIN_SET` | `[4:2]` | R/W | `0x2` | Gain setting (0-7, maps to feedback resistors) |
| `RESERVED` | `[15:5]` | R | `0x0` | Reserved |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control — 0=input, 1=output for each of 16 GPIO pins.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO15_0_DIR` | `[15:0]` | R/W | `0x0000` | GPIO direction (0=in, 1=out) |

---
### `GPIO_DATA_OUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output data — written to pins configured as outputs.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO15_0_OUT` | `[15:0]` | R/W | `0x0000` | GPIO output data |

---
### `GPIO_DATA_IN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input data — read state of pins configured as inputs.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO15_0_IN` | `[15:0]` | R | `0x0000` | GPIO input data |

---
### `GPIO_INT_EN` — Address `0x0803`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt enable — enables edge detection interrupt for each pin.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO15_0_INT_EN` | `[15:0]` | R/W | `0x0000` | Interrupt enable per pin (1=enabled) |

---
### `GPIO_INT_TYPE` — Address `0x0804`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt type — selects rising/falling/both edge detection.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO15_0_INT_TYPE` | `[15:0]` | R/W | `0x0000` | Interrupt type (0=rising, 1=falling, pairs for both) |

---
### `GPIO_INT_STATUS` — Address `0x0805`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt status — read to get pending interrupts, write-1 to clear.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO15_0_INT_FLAG` | `[15:0]` | R/W1C | `0x0000` | Interrupt flag (1=pending, write 1 to clear) |

---
### `DAC0_DATA` — Address `0x0900`

**Reset value:** `0x8000`  **Access:** see fields below

DAC channel 0 data — 16-bit value for auxiliary DAC output (e.g., bias control).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_VALUE` | `[15:0]` | R/W | `0x8000` | 16-bit DAC value (mid-scale reset) |

---
### `DAC1_DATA` — Address `0x0901`

**Reset value:** `0x8000`  **Access:** see fields below

DAC channel 1 data — 16-bit value for auxiliary DAC output.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_VALUE` | `[15:0]` | R/W | `0x8000` | 16-bit DAC value (mid-scale reset) |

---
### `DAC_CTRL` — Address `0x0902`

**Reset value:** `0x00`  **Access:** see fields below

DAC control register — enables DAC channels and configures output format.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC0_EN` | `[0]` | R/W | `0` | DAC channel 0 enable |
| `DAC1_EN` | `[1]` | R/W | `0` | DAC channel 1 enable |
| `OUTPUT_FORMAT` | `[3:2]` | R/W | `0x0` | Output format (00=straight binary, 01=twos complement) |
| `RESERVED` | `[15:4]` | R | `0x0` | Reserved |

---
### `AGC_CONFIG` — Address `0x0A00`

**Reset value:** `0x0001`  **Access:** see fields below

Automatic Gain Control configuration — enables AGC algorithm and sets parameters.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `AGC_EN` | `[0]` | R/W | `1` | AGC enable (1=auto gain control active) |
| `AGC_MODE` | `[2:1]` | R/W | `0x0` | AGC mode (00=fast, 01=medium, 10=slow) |
| `TARGET_LEVEL` | `[7:4]` | R/W | `0x8` | Target ADC level (0-15 FS code) |
| `HYSTERESIS` | `[11:8]` | R/W | `0x2` | Gain hysteresis (prevents chatter) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `AGC_STATUS` — Address `0x0A01`

**Reset value:** `0x00`  **Access:** see fields below

AGC status — reports current gain state and activity.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `AGC_ACTIVE` | `[0]` | R | `0` | AGC actively adjusting gain |
| `GAIN_INCREASING` | `[1]` | R | `0` | Gain increasing (1=ramping up) |
| `GAIN_DECREASING` | `[2]` | R | `0` | Gain decreasing (1=ramping down) |
| `OVERLOAD` | `[3]` | R | `0` | ADC overload detected |
| `CURRENT_GAIN` | `[11:8]` | R | `0x0` | Current gain index (0-15) |
| `RESERVED` | `[15:12]` | R | `0x0` | Reserved |

---
### `CALIBRATION_CTRL` — Address `0x0B00`

**Reset value:** `0x00`  **Access:** see fields below

Calibration control — initiates factory and runtime calibration routines.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START_CAL` | `[0]` | R/W | `0` | Start calibration sequence |
| `CAL_TYPE` | `[3:1]` | R/W | `0x0` | Calibration type (000=IQ, 001=DC offset, 010=gain) |
| `AUTO_CAL` | `[4]` | R/W | `0` | Automatic calibration at startup |
| `CAL_BUSY` | `[7]` | R | `0` | Calibration in progress |
| `RESERVED` | `[15:8]` | R | `0x0` | Reserved |

---
### `CALIBRATION_STATUS` — Address `0x0B01`

**Reset value:** `0x00`  **Access:** see fields below

Calibration status — reports calibration completion and results.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CAL_DONE` | `[0]` | R | `0` | Calibration complete |
| `CAL_PASS` | `[1]` | R | `0` | Calibration passed |
| `CAL_FAIL` | `[2]` | R | `0` | Calibration failed |
| `IQ_IMBALANCE` | `[7:4]` | R | `0x0` | IQ imbalance error code |
| `RESERVED` | `[15:8]` | R | `0x0` | Reserved |

---
### `EVENT_LOG_CTRL` — Address `0x0C00`

**Reset value:** `0x00`  **Access:** see fields below

Event log control — configures system event logging for diagnostics.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOG_EN` | `[0]` | R/W | `0` | Enable event logging |
| `LOG_LEVEL` | `[2:1]` | R/W | `0x1` | Log level (00=error, 01=warn, 10=info, 11=debug) |
| `WRAP_EN` | `[3]` | R/W | `1` | Wrap log when full |
| `CLR_LOG` | `[4]` | W | `0` | Clear event log (write 1) |
| `RESERVED` | `[15:5]` | R | `0x0` | Reserved |

---
### `EVENT_LOG_STATUS` — Address `0x0C01`

**Reset value:** `0x00`  **Access:** see fields below

Event log status — reports log buffer state and entry count.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOG_FULL` | `[0]` | R | `0` | Log buffer full |
| `LOG_EMPTY` | `[1]` | R | `1` | Log buffer empty |
| `ENTRY_COUNT` | `[10:2]` | R | `0x00` | Number of log entries (0-511) |
| `RESERVED` | `[15:11]` | R | `0x0` | Reserved |

---
### `EVENT_LOG_DATA` — Address `0x0C02`

**Reset value:** `0x0000`  **Access:** see fields below

Event log data read — read to fetch next log entry (auto-increments pointer).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOG_ENTRY` | `[15:0]` | R | `0x0000` | Event log entry data |

---
### `TEST_CTRL` — Address `0x0D00`

**Reset value:** `0x00`  **Access:** see fields below

Manufacturing test control — enables built-in self-test and diagnostic modes.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BIST_EN` | `[0]` | R/W | `0` | Enable BIST (memory, logic) |
| `LOOPBACK_RF` | `[1]` | R/W | `0` | RF loopback mode (for production test) |
| `PRBS_EN` | `[2]` | R/W | `0` | PRBS pattern generator on JESD link |
| `DAC_TEST_MODE` | `[4:3]` | R/W | `0x0` | DAC test pattern (00=normal, 01=ramp, 10=square) |
| `RESERVED` | `[15:5]` | R | `0x0` | Reserved |

---
### `TEST_STATUS` — Address `0x0D01`

**Reset value:** `0x00`  **Access:** see fields below

Manufacturing test status — reports BIST results and error codes.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BIST_PASS` | `[0]` | R | `0` | BIST passed |
| `BIST_FAIL` | `[1]` | R | `0` | BIST failed |
| `PRBS_ERR_COUNT` | `[10:2]` | R | `0x00` | PRBS error count (0-511) |
| `RESERVED` | `[15:11]` | R | `0x0` | Reserved |
