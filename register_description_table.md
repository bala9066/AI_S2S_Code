# Register Description Table (RDT)
## hm

> **Total registers:** 66

Register map for the hm UHF (300-1000 MHz) pulsed radar receiver module FPGA (XC7S25-1CSGA225). The design implements a superheterodyne receiver chain with 9 functional groups across a 16-bit UART-addressed register space: Board Information (0x0nn), Communication (0x1nn), ADC/Supply Monitoring (0x2nn), Temperature & Health (0x3nn), PLL/Clock (0x4nn), EEPROM (0x5nn), Flash (0x6nn), RF/Phase Control (0x7nn), GPIO (0x8nn), and DAC/Output (0x9nn). Key RF peripherals include ADF4153A fractional-N PLL, ROS-1080+ VCO (370-1070 MHz), HMC253LC4 SPDT sub-band switches, ADL5330 IF VGA with AGC, LTC5596 IQ demodulator, and LTC1569-7 baseband LPF. The programming sequence covers power sequencing (LTM8074 DC-DC → LT3045 LDO → RF bias), PLL lock acquisition, RF chain enablement, UART communication setup, and application-specific radar features (pulse gating, PRF generation, STC). Total: 48 registers, 28-step initialization sequence.

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
| `0x0000` | `BOARD_ID` | — | `0x686D` | Board identification code. Unique identifier for the hm UHF pulsed radar receiver module. |
| `0x0001` | `BOARD_VERSION` | — | `0x0001` | Hardware version register. Encodes PCB revision number. |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0003` | Board type identifier distinguishing this module within a larger radar system. |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose read/write test register for verifying FPGA register interface integrity. |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x0001` | FPGA firmware major version number (BCD encoded). |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x0000` | FPGA firmware minor version number (BCD encoded). |
| `0x0012` | `BUILD_DATE` | — | `0x2604` | FPGA build date in packed BCD format YYYYMMDD. |
| `0x0013` | `BUILD_DAY` | — | `0x0019` | Build day BCD and design checksum. |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0036` | UART baud rate divisor. Baud = fclk / (16 × DIV). For 115200 baud at 100 MHz, DIV = 54 (0x0036). |
| `0x0101` | `UART_CTRL` | — | `0x0001` | UART control register. Configures UART operating mode and frame format. |
| `0x0102` | `UART_STATUS` | — | `0x0000` | UART status register. Read-clears on read for flag bits. |
| `0x0103` | `UART_TX_COUNT` | — | `0x0000` | Number of bytes currently in the TX FIFO. |
| `0x0104` | `UART_RX_COUNT` | — | `0x0000` | Number of bytes currently in the RX FIFO. |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Ethernet MAC address lower 16 bits (read from OTP or EEPROM). |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Ethernet MAC address upper 16 bits. |
| `0x0200` | `ADC_CTRL` | — | `0x0000` | ADC control register for supply voltage and current monitoring. |
| `0x0201` | `ADC_STATUS` | — | `0x0000` | ADC status indicating conversion state and overrange conditions. |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V main rail voltage ADC count. Voltage = count × 5.0 / 4096. |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail voltage ADC count. Voltage = count × 5.0 / 4096. |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V analog rail ADC count. |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V FPGA core rail ADC count. |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current sense ADC count. Current = count × 5.0 / (4096 × Rsense). |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current sense ADC count. |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Local FPGA die junction temperature in 0.25°C units, signed two's complement. |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote temperature sensor 1 (TMP112 near RF chain) in 0.25°C units. |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote temperature sensor 2 (TMP112 near PLL/VCO) in 0.25°C units. |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold. Triggers alert when any sensor exceeds this value. |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold (for cold-start protection). |
| `0x030F` | `HEALTH_STATUS` | — | `0x0000` | System health summary register. Aggregates power, temperature, and PLL status. |
| `0x0400` | `PLL_CTRL` | — | `0x0000` | PLL synthesizer (ADF4153A) control register. Governs LO frequency generation. |
| `0x0401` | `PLL_STATUS` | — | `0x0000` | PLL synthesizer lock status and fault flags. |
| `0x0402` | `PLL_N_DIV_INT` | — | `0x0025` | PLL integer-N divider value. LO_freq = (N_int + N_frac/MOD) × f_ref / R. For 300 MHz RF with 70 MHz IF, LO=370 MHz. |
| `0x0403` | `PLL_N_DIV_FRAC` | — | `0x0000` | PLL fractional-N divider numerator (24-bit value stored in two registers). |
| `0x0404` | `PLL_N_DIV_FRAC_HI` | — | `0x0000` | PLL fractional-N divider numerator upper bits and modulus. |
| `0x0405` | `PLL_MODULUS_HI` | — | `0x0000` | PLL modulus upper bits (ADR4153A MOD register, 24-bit total). |
| `0x0406` | `PLL_R_DIV` | — | `0x0001` | PLL R reference divider value. |
| `0x0410` | `CLK_ENABLE` | — | `0x0000` | Clock output enable register. Individual enables for system clock distribution. |
| `0x0500` | `EEPROM_CTRL` | — | `0x0000` | EEPROM (AT25SF041) control and status register. |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | EEPROM byte address for next read/write operation (19-bit address space). |
| `0x0502` | `EEPROM_ADDR_HI` | — | `0x0000` | EEPROM upper address bits. |
| `0x0503` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data register. Write data before write cmd; read data after read cmd. |
| `0x0504` | `EEPROM_UNLOCK` | — | `0x0000` | Unlock key register for EEPROM erase protection. Must write 0xA5A1 before erase. |
| `0x0600` | `FLASH_CTRL` | — | `0x0000` | Configuration Flash (IS25LP016D QSPI) control and status. |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | Flash address lower 16 bits for read/write/erase operations. |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | Flash address upper bits (24-bit address space for 16-Mbit device). |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO. Sequential reads auto-increment address. |
| `0x0604` | `FLASH_STATUS` | — | `0x0000` | Flash device status and error flags. |
| `0x0605` | `FLASH_ID` | — | `0x0000` | Flash device JEDEC ID (manufacturer + memory type + capacity). |
| `0x0606` | `FLASH_ID_EXT` | — | `0x0000` | Flash capacity byte from JEDEC ID response. |
| `0x0700` | `RF_SPDT_CTRL` | — | `0x0000` | RF SPDT switch (HMC253LC4) control for sub-band filter bank routing. Selects UHF sub-band 300-1000 MHz. |
| `0x0701` | `LO_FREQ_WORD_LOW` | — | `0x0172` | LO frequency tuning word lower 16 bits. Sets 1st mixer LO frequency for UHF sub-band downconversion to 70 MHz IF. |
| `0x0702` | `LO_FREQ_WORD_HIGH` | — | `0x0000` | LO frequency tuning word upper bits. |
| `0x0703` | `IQ_DEMOD_CTRL` | — | `0x0000` | IQ demodulator (LTC5596) control register. Manages quadrature LO and baseband output configuration. |
| `0x0704` | `IF_VGA_CTRL` | — | `0x0080` | IF VGA (ADL5330) gain control register. ~40 dB gain control range for 70 MHz IF AGC. |
| `0x0705` | `BB_LPF_CTRL` | — | `0x0003` | Baseband low-pass filter (LTC1569-7) control. 5 MHz cutoff for I/Q channels, Butterworth/Bessel response. |
| `0x0706` | `LNA_CTRL` | — | `0x0000` | LNA (PMA3-83LN+) control register. Manages LNA bias and protection. |
| `0x0707` | `LO_BUF_CTRL` | — | `0x0000` | LO buffer amplifier (GVA-84+) control. Provides +7 dBm drive to 1st mixer LO port. |
| `0x0708` | `RF_CHAIN_POWER` | — | `0x0000` | RF chain power sequencing register. Controls LTM8074 DC-DC and LT3045 LDO power-up sequence. |
| `0x0800` | `GPIO_CTRL` | — | `0x0000` | GPIO control register for general-purpose digital I/O lines. |
| `0x0801` | `GPIO_INPUT` | — | `0x0000` | GPIO input read register. Reflects current pin states regardless of direction. |
| `0x0802` | `GPIO_IRQ_MASK` | — | `0x0000` | GPIO interrupt mask register. |
| `0x0803` | `SYSTEM_CTRL` | — | `0x0000` | System-level control register for global FPGA operations. |
| `0x0900` | `PULSE_GATE_CTRL` | — | `0x0000` | Pulse gating control for pulsed radar receiver blanking and range gate timing. |
| `0x0901` | `PRF_PERIOD` | — | `0x2710` | Pulse repetition frequency period register for internal PRF generator. |
| `0x0902` | `GATE_DELAY` | — | `0x0000` | Range gate delay from PRF trigger. Controls which range bin the receiver samples. |
| `0x0903` | `STC_DAC_CTRL` | — | `0x0000` | Sensitivity Time Control (STC) DAC register. Reduces receiver gain near range-zero to prevent saturation. |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x686D`  **Access:** see fields below

Board identification code. Unique identifier for the hm UHF pulsed radar receiver module.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x686D` | ASCII 'hm' — identifies this board as the UHF radar receiver module |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x0001`  **Access:** see fields below

Hardware version register. Encodes PCB revision number.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x0` | Major hardware revision |
| `MINOR` | `[3:0]` | R | `0x1` | Minor hardware revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0003`  **Access:** see fields below

Board type identifier distinguishing this module within a larger radar system.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | R | `0x0003` | Type 3 = UHF pulsed radar receiver module |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose read/write test register for verifying FPGA register interface integrity.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Mirrors any written value; used for UART link integrity test |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x0001`  **Access:** see fields below

FPGA firmware major version number (BCD encoded).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:0]` | R | `0x01` | FPGA bitstream major version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA firmware minor version number (BCD encoded).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR` | `[7:0]` | R | `0x00` | FPGA bitstream minor version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x2604`  **Access:** see fields below

FPGA build date in packed BCD format YYYYMMDD.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `YEAR_MONTH` | `[15:0]` | R | `0x2604` | Build date packed BCD (e.g. 0x2026 for April 2026, read two registers for full date) |

---
### `BUILD_DAY` — Address `0x0013`

**Reset value:** `0x0019`  **Access:** see fields below

Build day BCD and design checksum.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAY` | `[7:0]` | R | `0x19` | BCD day of month |
| `CHECKSUM` | `[15:8]` | R | `0x00` | FPGA design checksum byte |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0036`  **Access:** see fields below

UART baud rate divisor. Baud = fclk / (16 × DIV). For 115200 baud at 100 MHz, DIV = 54 (0x0036).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIV` | `[15:0]` | RW | `0x0036` | Baud rate divisor value |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x0001`  **Access:** see fields below

UART control register. Configures UART operating mode and frame format.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | UART enable (1=active, 0=disabled) |
| `LOOPBACK` | `[1]` | RW | `0x0` | Loopback mode for self-test (1=TX tied to RX internally) |
| `FRAME_FORMAT` | `[7:4]` | RW | `0x0` | Frame format: 0=8N1, 1=8E1, 2=8O1, 3=8N2 |
| `TX_IRQ_EN` | `[8]` | RW | `0x0` | TX complete interrupt enable |
| `RX_IRQ_EN` | `[9]` | RW | `0x0` | RX data available interrupt enable |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x0000`  **Access:** see fields below

UART status register. Read-clears on read for flag bits.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0x0` | Transmitter is actively sending data |
| `RX_AVAIL` | `[1]` | RC | `0x0` | At least one byte available in RX FIFO |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Framing error detected on RX |
| `OVERRUN` | `[3]` | RC | `0x0` | RX FIFO overrun — data lost |
| `TX_EMPTY` | `[4]` | R | `0x1` | TX FIFO is empty |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x0000`  **Access:** see fields below

Number of bytes currently in the TX FIFO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | TX FIFO occupancy count |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x0000`  **Access:** see fields below

Number of bytes currently in the RX FIFO.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | RX FIFO occupancy count |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address lower 16 bits (read from OTP or EEPROM).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_LOW` | `[15:0]` | R | `0x0000` | MAC address bits [15:0] |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Ethernet MAC address upper 16 bits.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC_HIGH` | `[15:0]` | R | `0x0000` | MAC address bits [31:16] |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x0000`  **Access:** see fields below

ADC control register for supply voltage and current monitoring.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start single conversion (auto-clears) |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous conversion mode enable |
| `CHANNEL` | `[3:2]` | RW | `0x0` | ADC channel select: 0=5V, 1=3.3V, 2=2.5V, 3=1.8V |
| `REF_SEL` | `[5:4]` | RW | `0x0` | Reference select: 0=internal 2.5V, 1=external ref |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x0000`  **Access:** see fields below

ADC status indicating conversion state and overrange conditions.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0x0` | New ADC conversion result available |
| `OVERRANGE` | `[1]` | RC | `0x0` | ADC input exceeded positive full-scale range |
| `BUSY` | `[2]` | R | `0x0` | ADC conversion in progress |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V main rail voltage ADC count. Voltage = count × 5.0 / 4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC conversion result for 5V rail |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail voltage ADC count. Voltage = count × 5.0 / 4096.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC conversion result for 3.3V rail (LT3045 LDO output) |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V analog rail ADC count.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC conversion result for 2.5V rail |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V FPGA core rail ADC count.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit ADC conversion result for 1.8V rail |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current sense ADC count. Current = count × 5.0 / (4096 × Rsense).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit current-sense ADC result for 5V rail |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current sense ADC count.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | 12-bit current-sense ADC result for 3.3V rail |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Local FPGA die junction temperature in 0.25°C units, signed two's complement.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Die temperature in 0.25°C steps (signed). e.g. 0x064 = 25.0°C |
| `VALID` | `[15]` | R | `0x0` | Temperature reading valid flag |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 1 (TMP112 near RF chain) in 0.25°C units.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Remote sensor 1 temperature (0.25°C/LSB, signed) |
| `VALID` | `[15]` | R | `0x0` | Reading valid flag |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote temperature sensor 2 (TMP112 near PLL/VCO) in 0.25°C units.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Remote sensor 2 temperature (0.25°C/LSB, signed) |
| `VALID` | `[15]` | R | `0x0` | Reading valid flag |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold. Triggers alert when any sensor exceeds this value.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x190` | Over-temperature threshold (0.25°C/LSB). Default 0x190 = 100°C |
| `ENABLE` | `[12]` | RW | `0x0` | Alert enable for over-temperature |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold (for cold-start protection).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESHOLD` | `[9:0]` | RW | `0x19C` | Under-temperature threshold (0.25°C/LSB, signed). Default = -25°C |
| `ENABLE` | `[12]` | RW | `0x0` | Alert enable for under-temperature |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x0000`  **Access:** see fields below

System health summary register. Aggregates power, temperature, and PLL status.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x0` | All temperature sensors within thresholds |
| `VOLT_OK` | `[1]` | R | `0x0` | All supply voltages within ±5% tolerance |
| `PLL_LOCKED` | `[2]` | R | `0x0` | PLL synthesizer is phase-locked |
| `FLASH_RDY` | `[3]` | R | `0x0` | Configuration flash is ready for access |
| `RF_POWER_OK` | `[4]` | R | `0x0` | RF chain power sequencing complete |
| `SYSTEM_OK` | `[7]` | R | `0x0` | All subsystems healthy (logical AND of bits [4:0]) |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x0000`  **Access:** see fields below

PLL synthesizer (ADF4153A) control register. Governs LO frequency generation.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL enable (1=active, powers up ADF4153A) |
| `RESET` | `[1]` | RW | `0x0` | PLL reset (active-high, auto-clears) |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select: 0=internal TCXO, 1=external ref input |
| `MUX_CTRL` | `[5:4]` | RW | `0x0` | ADF4153A MUX output: 0=DIG_LOCK, 1=N_DIV, 2=R_DIV, 3=SD |
| `CP_CURRENT` | `[7:6]` | RW | `0x0` | Charge pump current: 0=0.6mA, 1=1.2mA, 2=1.8mA, 3=2.4mA |
| `LDP` | `[8]` | RW | `0x0` | Lock detect precision: 0=3-cycle, 1=5-cycle |
| `PD_POL` | `[9]` | RW | `0x1` | Phase detector polarity: 0=negative, 1=positive (default for ROS-1080+ VCO) |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x0000`  **Access:** see fields below

PLL synthesizer lock status and fault flags.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RC | `0x0` | PLL is phase-locked to reference |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | PLL has lost lock since last read (sticky) |
| `VCO_OUT_OF_RANGE` | `[2]` | RC | `0x0` | VCO tuning voltage at rail (VCO cannot reach requested frequency) |
| `REF_LOSS` | `[3]` | RC | `0x0` | Reference clock signal loss detected |

---
### `PLL_N_DIV_INT` — Address `0x0402`

**Reset value:** `0x0025`  **Access:** see fields below

PLL integer-N divider value. LO_freq = (N_int + N_frac/MOD) × f_ref / R. For 300 MHz RF with 70 MHz IF, LO=370 MHz.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_INT` | `[15:0]` | RW | `0x0025` | Integer part of N divider (default 37 for 370 MHz LO) |

---
### `PLL_N_DIV_FRAC` — Address `0x0403`

**Reset value:** `0x0000`  **Access:** see fields below

PLL fractional-N divider numerator (24-bit value stored in two registers).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_FRAC_LOW` | `[15:0]` | RW | `0x0000` | Fractional numerator bits [15:0] |

---
### `PLL_N_DIV_FRAC_HI` — Address `0x0404`

**Reset value:** `0x0000`  **Access:** see fields below

PLL fractional-N divider numerator upper bits and modulus.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_FRAC_HIGH` | `[7:0]` | RW | `0x00` | Fractional numerator bits [23:16] |
| `MOD_LOW` | `[15:8]` | RW | `0x00` | Modulus bits [7:0] (fractional denominator) |

---
### `PLL_MODULUS_HI` — Address `0x0405`

**Reset value:** `0x0000`  **Access:** see fields below

PLL modulus upper bits (ADR4153A MOD register, 24-bit total).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MOD_HIGH` | `[15:0]` | RW | `0x0000` | Modulus bits [23:8] |

---
### `PLL_R_DIV` — Address `0x0406`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R reference divider value.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x01` | Reference divider (default 1 for 10 MHz TCXO = 10 MHz PFD rate) |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0000`  **Access:** see fields below

Clock output enable register. Individual enables for system clock distribution.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK0_EN` | `[0]` | RW | `0x0` | System clock enable (100 MHz main FPGA clock) |
| `CLK1_EN` | `[1]` | RW | `0x0` | ADC sample clock enable |
| `CLK2_EN` | `[2]` | RW | `0x0` | SPI peripheral clock enable |
| `CLK3_EN` | `[3]` | RW | `0x0` | Baseband filter clock enable |
| `CLK4_EN` | `[4]` | RW | `0x0` | RF switch control clock enable |
| `CLK_ALL` | `[7]` | RW | `0x0` | Master gate for all clock outputs |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM (AT25SF041) control and status register.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate read (auto-clears) |
| `WRITE` | `[1]` | RW | `0x0` | Initiate page write (auto-clears) |
| `ERASE` | `[2]` | RW | `0x0` | Initiate sector erase (requires unlock key in EEPROM_UNLOCK) |
| `WP` | `[3]` | RW | `0x0` | Write protect override (1=force WP on) |
| `BUSY` | `[7]` | R | `0x0` | EEPROM operation in progress (poll until 0) |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM byte address for next read/write operation (19-bit address space).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Address bits [15:0] |

---
### `EEPROM_ADDR_HI` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM upper address bits.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[2:0]` | RW | `0x0` | Address bits [18:16] |

---
### `EEPROM_DATA` — Address `0x0503`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data register. Write data before write cmd; read data after read cmd.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data for EEPROM read/write operations |

---
### `EEPROM_UNLOCK` — Address `0x0504`

**Reset value:** `0x0000`  **Access:** see fields below

Unlock key register for EEPROM erase protection. Must write 0xA5A1 before erase.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UNLOCK_KEY` | `[15:0]` | W | `0x0000` | Write 0xA5A1 to unlock erase operations. Reads return 0x0000. |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x0000`  **Access:** see fields below

Configuration Flash (IS25LP016D QSPI) control and status.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate flash read (auto-clears) |
| `WRITE` | `[1]` | RW | `0x0` | Initiate flash page program (auto-clears) |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase 4KB sector (requires unlock) |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Full chip erase (requires unlock + double-verify) |
| `QUAD_EN` | `[4]` | RW | `0x0` | Quad SPI mode enable |
| `BUSY` | `[7]` | R | `0x0` | Flash operation in progress (poll until 0) |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address lower 16 bits for read/write/erase operations.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Flash address bits [15:0] |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

Flash address upper bits (24-bit address space for 16-Mbit device).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[7:0]` | RW | `0x00` | Flash address bits [23:16] |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO. Sequential reads auto-increment address.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Read/write data for flash operations (FIFO mode) |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x0000`  **Access:** see fields below

Flash device status and error flags.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x0` | Flash device ready for commands |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Page program error detected |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Erase error detected |
| `WP_STATUS` | `[3]` | R | `0x0` | Write protect pin status |

---
### `FLASH_ID` — Address `0x0605`

**Reset value:** `0x0000`  **Access:** see fields below

Flash device JEDEC ID (manufacturer + memory type + capacity).

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MANUF_ID` | `[7:0]` | R | `0x00` | JEDEC manufacturer ID (ISSI = 0x9D) |
| `MEM_TYPE` | `[15:8]` | R | `0x00` | Memory type ID byte |

---
### `FLASH_ID_EXT` — Address `0x0606`

**Reset value:** `0x0000`  **Access:** see fields below

Flash capacity byte from JEDEC ID response.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CAPACITY` | `[7:0]` | R | `0x00` | Capacity byte (0x15 = 16 Mbit for IS25LP016D) |
| `UID_SNIPPET` | `[15:8]` | R | `0x00` | First byte of unique ID (for traceability) |

---
### `RF_SPDT_CTRL` — Address `0x0700`

**Reset value:** `0x0000`  **Access:** see fields below

RF SPDT switch (HMC253LC4) control for sub-band filter bank routing. Selects UHF sub-band 300-1000 MHz.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SW1` | `[0]` | RW | `0x0` | SPDT switch 1 position: 0=filter path A (300-500 MHz), 1=filter path B (500-750 MHz) |
| `SW2` | `[1]` | RW | `0x0` | SPDT switch 2 position: 0=filter path C (750-1000 MHz), 1=bypass/calibration |
| `SW3` | `[2]` | RW | `0x0` | SPDT switch 3 for limiter bypass: 0=normal, 1=cal/bypass |
| `SW_EN` | `[7]` | RW | `0x0` | Master enable for all RF switches (power savings when 0) |

---
### `LO_FREQ_WORD_LOW` — Address `0x0701`

**Reset value:** `0x0172`  **Access:** see fields below

LO frequency tuning word lower 16 bits. Sets 1st mixer LO frequency for UHF sub-band downconversion to 70 MHz IF.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_WORD_LOW` | `[15:0]` | RW | `0x0172` | Frequency tuning word [15:0] — default 370 MHz LO (0x0172 hex for LO=370MHz) |

---
### `LO_FREQ_WORD_HIGH` — Address `0x0702`

**Reset value:** `0x0000`  **Access:** see fields below

LO frequency tuning word upper bits.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FREQ_WORD_HIGH` | `[7:0]` | RW | `0x00` | Frequency tuning word [23:16] |
| `LOAD` | `[8]` | RW | `0x0` | Load new frequency word into PLL (pulse, auto-clears) |
| `VALID` | `[15]` | R | `0x0` | Frequency word loaded and active in PLL |

---
### `IQ_DEMOD_CTRL` — Address `0x0703`

**Reset value:** `0x0000`  **Access:** see fields below

IQ demodulator (LTC5596) control register. Manages quadrature LO and baseband output configuration.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | IQ demodulator enable (1=active) |
| `LO_MODE` | `[2:1]` | RW | `0x0` | LO source: 0=from PLL divider (70 MHz quadrature), 1=external, 2=internal test tone |
| `BB_BIAS` | `[5:3]` | RW | `0x0` | Baseband DC bias adjustment for I and Q outputs (0-7 scale) |
| `GAIN_MODE` | `[7:6]` | RW | `0x0` | Gain setting: 0=low, 1=medium, 2=high, 3=max |

---
### `IF_VGA_CTRL` — Address `0x0704`

**Reset value:** `0x0080`  **Access:** see fields below

IF VGA (ADL5330) gain control register. ~40 dB gain control range for 70 MHz IF AGC.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GAIN` | `[9:0]` | RW | `0x080` | VGA gain control word (10-bit DAC value). Mid-scale 0x200 = ~0 dB, range ≈ -20 dB to +20 dB |
| `AGC_EN` | `[10]` | RW | `0x0` | Enable automatic gain control loop (1=AGC active, 0=manual gain) |
| `AGC_TARGET` | `[15:12]` | RW | `0x0` | AGC target level (4-bit threshold for feedback loop) |

---
### `BB_LPF_CTRL` — Address `0x0705`

**Reset value:** `0x0003`  **Access:** see fields below

Baseband low-pass filter (LTC1569-7) control. 5 MHz cutoff for I/Q channels, Butterworth/Bessel response.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CUTOFF` | `[3:0]` | RW | `0x3` | Cutoff frequency select: 0=500kHz, 1=1MHz, 2=2.5MHz, 3=5MHz (default), 4=10MHz |
| `RESPONSE` | `[5:4]` | RW | `0x0` | Filter response: 0=Butterworth (max flatness), 1=Bessel (linear phase), 2=Chebyshev |
| `ENABLE` | `[7]` | RW | `0x0` | Filter enable (1=active, 0=bypass for test) |
| `GROUP_DELAY_CAL` | `[15:8]` | RW | `0x00` | Group delay calibration trim value |

---
### `LNA_CTRL` — Address `0x0706`

**Reset value:** `0x0000`  **Access:** see fields below

LNA (PMA3-83LN+) control register. Manages LNA bias and protection.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | LNA bias enable (1=active, sets system NF to 2 dB) |
| `BIAS_TRIM` | `[4:1]` | RW | `0x0` | LNA bias current trim (factory calibrated) |
| `PROTECT` | `[5]` | RW | `0x0` | Overload protection enable (triggers limiter bypass on >+10 dBm detected) |

---
### `LO_BUF_CTRL` — Address `0x0707`

**Reset value:** `0x0000`  **Access:** see fields below

LO buffer amplifier (GVA-84+) control. Provides +7 dBm drive to 1st mixer LO port.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | LO buffer amplifier enable (1=active) |
| `POWER` | `[2:1]` | RW | `0x0` | Output power: 0=low (+4 dBm), 1=medium (+7 dBm), 2=high (+10 dBm) |
| `BIAS_OK` | `[8]` | R | `0x0` | LO buffer bias current within specification |

---
### `RF_CHAIN_POWER` — Address `0x0708`

**Reset value:** `0x0000`  **Access:** see fields below

RF chain power sequencing register. Controls LTM8074 DC-DC and LT3045 LDO power-up sequence.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DCDC_EN` | `[0]` | RW | `0x0` | DC-DC converter (LTM8074) enable: 1=ON, produces +5V rail |
| `LDO_EN` | `[1]` | RW | `0x0` | LDO (LT3045) enable: 1=ON, produces +3.3V low-noise rail for PLL/VCO |
| `RF_EN` | `[2]` | RW | `0x0` | RF chain enable (gates all RF component bias): 1=ON |
| `SEQ_STATE` | `[5:3]` | R | `0x0` | Power sequencer state machine: 0=OFF, 1=DCDC_RAMP, 2=LDO_WAIT, 3=RF_BIAS, 4=READY |
| `SEQ_FAULT` | `[7]` | RC | `0x0` | Power sequencing fault (timed out or voltage out of range) |

---
### `GPIO_CTRL` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO control register for general-purpose digital I/O lines.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_DIR` | `[0]` | RW | `0x0` | GPIO0 direction: 0=input, 1=output |
| `GPIO1_DIR` | `[1]` | RW | `0x0` | GPIO1 direction |
| `GPIO2_DIR` | `[2]` | RW | `0x0` | GPIO2 direction |
| `GPIO3_DIR` | `[3]` | RW | `0x0` | GPIO3 direction |
| `GPIO0_OUT` | `[4]` | RW | `0x0` | GPIO0 output value (when configured as output) |
| `GPIO1_OUT` | `[5]` | RW | `0x0` | GPIO1 output value |
| `GPIO2_OUT` | `[6]` | RW | `0x0` | GPIO2 output value |
| `GPIO3_OUT` | `[7]` | RW | `0x0` | GPIO3 output value |

---
### `GPIO_INPUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input read register. Reflects current pin states regardless of direction.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_IN` | `[0]` | R | `0x0` | GPIO0 current input value |
| `GPIO1_IN` | `[1]` | R | `0x0` | GPIO1 current input value |
| `GPIO2_IN` | `[2]` | R | `0x0` | GPIO2 current input value |
| `GPIO3_IN` | `[3]` | R | `0x0` | GPIO3 current input value |
| `EXT_TRIG` | `[4]` | R | `0x0` | External trigger input (radar PRF sync) |
| `PPS_IN` | `[5]` | R | `0x0` | 1-PPS timing reference input |

---
### `GPIO_IRQ_MASK` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO interrupt mask register.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GPIO0_IRQ_EN` | `[0]` | RW | `0x0` | Enable interrupt on GPIO0 edge |
| `GPIO1_IRQ_EN` | `[1]` | RW | `0x0` | Enable interrupt on GPIO1 edge |
| `EXT_TRIG_IRQ_EN` | `[4]` | RW | `0x0` | Enable interrupt on external trigger edge |
| `PPS_IRQ_EN` | `[5]` | RW | `0x0` | Enable interrupt on 1-PPS edge |

---
### `SYSTEM_CTRL` — Address `0x0803`

**Reset value:** `0x0000`  **Access:** see fields below

System-level control register for global FPGA operations.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SOFT_RESET` | `[0]` | RW | `0x0` | Soft reset (active-high pulse, clears all peripheral state) |
| `INT_EN` | `[1]` | RW | `0x0` | Global interrupt enable |
| `WATCHDOG_EN` | `[2]` | RW | `0x0` | Watchdog timer enable |
| `WATCHDOG_KICK` | `[3]` | RW | `0x0` | Watchdog kick (pulse, auto-clears) |
| `CAL_MODE` | `[4]` | RW | `0x0` | System calibration mode (disables normal signal path) |
| `LED_CTRL` | `[7:5]` | RW | `0x0` | Status LED control: 0=off, 1=green, 2=red, 3=amber, 4=heartbeat blink |

---
### `PULSE_GATE_CTRL` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

Pulse gating control for pulsed radar receiver blanking and range gate timing.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `GATE_ENABLE` | `[0]` | RW | `0x0` | Pulse gate enable (1=active, gates baseband path on/off with PRF) |
| `POLARITY` | `[1]` | RW | `0x0` | Gate polarity: 0=active-high (pass during gate), 1=active-low (blank during gate) |
| `GATE_SRC` | `[3:2]` | RW | `0x0` | Gate source: 0=external trigger, 1=internal timer, 2=SPI command, 3=PRF generator |
| `GATE_WIDTH` | `[11:4]` | RW | `0x00` | Gate width in units of 10 ns (1–255 = 10 ns to 2.55 μs) |

---
### `PRF_PERIOD` — Address `0x0901`

**Reset value:** `0x2710`  **Access:** see fields below

Pulse repetition frequency period register for internal PRF generator.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PERIOD` | `[15:0]` | RW | `0x2710` | PRF period in 10 ns units. Default 0x2710 = 10000 = 100 μs (10 kHz PRF). Range: 0x0064–0xFFFF |

---
### `GATE_DELAY` — Address `0x0902`

**Reset value:** `0x0000`  **Access:** see fields below

Range gate delay from PRF trigger. Controls which range bin the receiver samples.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DELAY` | `[15:0]` | RW | `0x0000` | Gate delay in 10 ns units from trigger. Delay = range × 2/c. 0x03E8=1000×10ns=10μs=1.5 km range |

---
### `STC_DAC_CTRL` — Address `0x0903`

**Reset value:** `0x0000`  **Access:** see fields below

Sensitivity Time Control (STC) DAC register. Reduces receiver gain near range-zero to prevent saturation.

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `STC_ENABLE` | `[0]` | RW | `0x0` | STC function enable |
| `STC_DEPTH` | `[11:1]` | RW | `0x000` | STC attenuation depth (11-bit DAC value, 0=dB, max≈40 dB attenuation at range-zero) |
| `STC_SHAPE` | `[13:12]` | RW | `0x0` | STC decay profile: 0=linear, 1=logarithmic, 2=1/R², 3=1/R³ |
