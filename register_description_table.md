# Register Description Table (RDT)
## hjjg

> **Total registers:** 54

Register Description Table and Programming Sequence for the **hjjg** project — a dual-channel, phase-coherent, double-IF superheterodyne radar receiver (2–6 GHz). The register map spans 10 functional groups (0x000–0x900) covering board identification (0x000), UART/Ethernet communication (0x100), ADC supply monitoring via ADM1177/XADC (0x200), temperature sensing via TMP116/FPGA XADC (0x300), ADF4106 PLL/clock configuration with LMK1C1102 buffer enables (0x400), 24AA025E48 I2C EEPROM calibration storage (0x500), AT25SL321 SPI configuration flash (0x600), RF front-end control (GRF2074 LNA bias, phase alignment, IF1/IF2 gain, LO VCO/splitter, power detectors) (0x700), GPIO for FMC+ interface (0x800), and radar DSP/pulse-compression/CFAR processing with PRI timing (0x900). The 20-step programming sequence follows strict hardware dependency order: UART verification → power-rail stability check → board ID validation → PLL frequency synthesis (LO1/LO2) → clock distribution → LO chain & LNA enable → IF gain configuration → UART setup → EEPROM calibration load → flash verification → ADC start → temperature alert arming → DSP pipeline enable → PRI generator arm, culminating in SYSTEM_OK verification.

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
| `0x0000` | `BOARD_ID` | — | `0x484A` | Board identification code for the hjjg dual-channel 2–6 GHz double-IF superheterodyne radar receiver |
| `0x0001` | `BOARD_VERSION` | — | `0x0001` | Hardware PCB version encoded as BCD major.minor |
| `0x0002` | `BOARD_TYPE_ID` | — | `0x0010` | Numeric board type identifier for inventory and compatibility checks |
| `0x0003` | `SCRATCHPAD` | — | `0x0000` | General-purpose read/write register for UART link integrity verification and debug |
| `0x0010` | `MCS_VERSION_MAJOR` | — | `0x0001` | FPGA firmware (MCS/bitstream) major version number |
| `0x0011` | `MCS_VERSION_MINOR` | — | `0x0000` | FPGA firmware (MCS/bitstream) minor version number |
| `0x0012` | `BUILD_DATE` | — | `0x0426` | FPGA build date in packed BCD format YYYYMMDD [15:0] holds MMDD, upper 16 bits held in BUILD_DATE_HIGH at 0x0013 |
| `0x0013` | `BUILD_DATE_HIGH` | — | `0x2026` | FPGA build date upper 16 bits holding year in packed BCD |
| `0x0100` | `UART_BAUD_DIV` | — | `0x0044` | UART baud rate divisor; divides the 10 MHz OCXO-derived system clock |
| `0x0101` | `UART_CTRL` | — | `0x0001` | UART operating mode control register |
| `0x0102` | `UART_STATUS` | — | `0x0000` | UART operational status flags; read-clears on read |
| `0x0103` | `UART_TX_COUNT` | — | `0x0000` | Number of bytes currently in the TX FIFO |
| `0x0104` | `UART_RX_COUNT` | — | `0x0000` | Number of bytes currently in the RX FIFO |
| `0x0110` | `ETH_MAC_LOW` | — | `0x0000` | Lower 16 bits of the EUI-48 MAC address from 24AA025E48 EEPROM |
| `0x0111` | `ETH_MAC_HIGH` | — | `0x0000` | Upper 16 bits of the EUI-48 MAC address from 24AA025E48 EEPROM |
| `0x0200` | `ADC_CTRL` | — | `0x0000` | AD9643 dual-channel ADC control register for IF2 digitisation |
| `0x0201` | `ADC_STATUS` | — | `0x0000` | AD9643 ADC status flags |
| `0x0210` | `VCC_5V_RAW` | — | `0x0000` | 5V rail ADC count from ADM1177 voltage monitor (12-bit, full-scale = 4095 = 5.0V) |
| `0x0211` | `VCC_3V3_RAW` | — | `0x0000` | 3.3V rail ADC count from supply monitor |
| `0x0212` | `VCC_2V5_RAW` | — | `0x0000` | 2.5V rail ADC count (FPGA VCCAUX / ADC reference) |
| `0x0213` | `VCC_1V8_RAW` | — | `0x0000` | 1.8V rail ADC count (FPGA VCCINT / LVDS bank supply) |
| `0x0218` | `ICC_5V_RAW` | — | `0x0000` | 5V rail current ADC count from ADM1177 current-sense amplifier (sense resistor based) |
| `0x0219` | `ICC_3V3_RAW` | — | `0x0000` | 3.3V rail current ADC count from current-sense monitor |
| `0x0300` | `TEMP_LOCAL` | — | `0x0000` | Kintex-7 FPGA die temperature from internal XADC in 0.25°C units (signed 10-bit) |
| `0x0301` | `TEMP_REMOTE1` | — | `0x0000` | Remote TMP116 sensor 1 temperature (RF section near LNAs) in 0.0625°C steps |
| `0x0302` | `TEMP_REMOTE2` | — | `0x0000` | Remote TMP116 sensor 2 temperature (PLL/VCO section) in 0.0625°C steps |
| `0x0308` | `TEMP_ALERT_HIGH` | — | `0x0190` | Over-temperature alert threshold for safety shutdown — triggers HEALTH_STATUS[0] de-assertion |
| `0x0309` | `TEMP_ALERT_LOW` | — | `0xFF9C` | Under-temperature alert threshold — triggers cold-warning in HEALTH_STATUS |
| `0x030F` | `HEALTH_STATUS` | — | `0x0000` | Aggregated system health flags — all must be 1 for SYSTEM_OK |
| `0x0400` | `PLL_CTRL` | — | `0x0000` | ADF4106 PLL synthesizer control for LO1 (4–8 GHz VCO) and LO2 (1.1 GHz) |
| `0x0401` | `PLL_STATUS` | — | `0x0000` | ADF4106 PLL lock and fault status |
| `0x0402` | `PLL_N_DIV` | — | `0x0088` | PLL N-divider (main divider) value for ADF4106 — determines the LO frequency: f_LO = f_REF × (N / R) |
| `0x0403` | `PLL_R_DIV` | — | `0x0001` | PLL R-divider (reference divider) value for ADF4106 — divides 10 MHz OCXO reference |
| `0x0410` | `CLK_ENABLE` | — | `0x0000` | LMK1C1102 LVCMOS clock buffer output enables — one bit per clock output channel |
| `0x0500` | `EEPROM_CTRL` | — | `0x0000` | 24AA025E48 I2C EEPROM control for calibration data and MAC storage |
| `0x0501` | `EEPROM_ADDR` | — | `0x0000` | 24AA025E48 EEPROM byte address for next read/write operation |
| `0x0502` | `EEPROM_DATA` | — | `0x0000` | EEPROM read/write data register — auto-increments address on sequential access |
| `0x0600` | `FLASH_CTRL` | — | `0x0000` | AT25SL321 32Mb SPI Flash control for FPGA configuration storage |
| `0x0601` | `FLASH_ADDR_LOW` | — | `0x0000` | AT25SL321 Flash address lower 16 bits [15:0] |
| `0x0602` | `FLASH_ADDR_HIGH` | — | `0x0000` | AT25SL321 Flash address upper bits [21:16] — 32Mb = 4MB = 22-bit address space |
| `0x0603` | `FLASH_DATA` | — | `0x0000` | Flash read/write data FIFO — 16-bit wide, auto-increments flash address on each access |
| `0x0604` | `FLASH_STATUS` | — | `0x0001` | AT25SL321 flash device status and error flags |
| `0x0700` | `RF_LNA_CTRL` | — | `0x0000` | GRF2074 LNA bias enable and gain control for both receiver channels |
| `0x0701` | `RF_PHASE_CTRL` | — | `0x0000` | Phase control register for inter-channel phase alignment and calibration |
| `0x0710` | `RF_POWER_DETECT_A` | — | `0x0000` | Channel A RF power detector ADC reading from limiter output (preselector stage) |
| `0x0711` | `RF_POWER_DETECT_B` | — | `0x0000` | Channel B RF power detector ADC reading from limiter output |
| `0x0718` | `IF1_GAIN_CTRL` | — | `0x0000` | 1st IF (1300 MHz) chain gain control for IF driver amplifier HMC788ALP2E and buffer GRF2040 |
| `0x0719` | `IF2_GAIN_CTRL` | — | `0x0000` | 2nd IF (200 MHz) chain gain control and IF filter selection |
| `0x0720` | `LO_POWER_CTRL` | — | `0x0000` | LO power splitter and VCO enable control for EP2K1+ splitter and HMC586LC4B VCO |
| `0x0800` | `GPIO_DIR` | — | `0x0000` | GPIO direction control — one bit per GPIO pin, for FMC+ interface lines and test points |
| `0x0801` | `GPIO_DATA_OUT` | — | `0x0000` | GPIO output data register — writes to pins configured as outputs in GPIO_DIR |
| `0x0802` | `GPIO_DATA_IN` | — | `0x0000` | GPIO input data register — reflects current state of all GPIO pins regardless of direction |
| `0x0900` | `DSP_CTRL` | — | `0x0000` | Radar DSP processing control for pulse compression, CFAR, and data formatting |
| `0x0901` | `PRI_CTRL` | — | `0x0000` | Pulse Repetition Interval timing control for radar synchronisation |

---
### `BOARD_ID` — Address `0x0000`

**Reset value:** `0x484A`  **Access:** see fields below

Board identification code for the hjjg dual-channel 2–6 GHz double-IF superheterodyne radar receiver

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOARD_ID` | `[15:0]` | R | `0x484A` | ASCII 'HJ' — uniquely identifies this board type |

---
### `BOARD_VERSION` — Address `0x0001`

**Reset value:** `0x0001`  **Access:** see fields below

Hardware PCB version encoded as BCD major.minor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:4]` | R | `0x0` | Major hardware revision |
| `MINOR` | `[3:0]` | R | `0x1` | Minor hardware revision |

---
### `BOARD_TYPE_ID` — Address `0x0002`

**Reset value:** `0x0010`  **Access:** see fields below

Numeric board type identifier for inventory and compatibility checks

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TYPE_ID` | `[15:0]` | R | `0x0010` | Board type = 0x0010 for dual-channel radar receiver |

---
### `SCRATCHPAD` — Address `0x0003`

**Reset value:** `0x0000`  **Access:** see fields below

General-purpose read/write register for UART link integrity verification and debug

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | R/W test pattern — write a known value and read back to verify bus integrity |

---
### `MCS_VERSION_MAJOR` — Address `0x0010`

**Reset value:** `0x0001`  **Access:** see fields below

FPGA firmware (MCS/bitstream) major version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAJOR` | `[7:0]` | R | `0x01` | FPGA firmware major version |

---
### `MCS_VERSION_MINOR` — Address `0x0011`

**Reset value:** `0x0000`  **Access:** see fields below

FPGA firmware (MCS/bitstream) minor version number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR` | `[7:0]` | R | `0x00` | FPGA firmware minor version |

---
### `BUILD_DATE` — Address `0x0012`

**Reset value:** `0x0426`  **Access:** see fields below

FPGA build date in packed BCD format YYYYMMDD [15:0] holds MMDD, upper 16 bits held in BUILD_DATE_HIGH at 0x0013

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATE_MMDD` | `[15:0]` | R | `0x0426` | Month and day packed BCD (April 26 = 0x0426) |

---
### `BUILD_DATE_HIGH` — Address `0x0013`

**Reset value:** `0x2026`  **Access:** see fields below

FPGA build date upper 16 bits holding year in packed BCD

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATE_YYYY` | `[15:0]` | R | `0x2026` | Year packed BCD (2026 = 0x2026) |

---
### `UART_BAUD_DIV` — Address `0x0100`

**Reset value:** `0x0044`  **Access:** see fields below

UART baud rate divisor; divides the 10 MHz OCXO-derived system clock

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIVISOR` | `[15:0]` | RW | `0x0044` | Baud rate = system_clock / (16 × DIVISOR). Default 0x0044 = 115200 baud at 100 MHz |

---
### `UART_CTRL` — Address `0x0101`

**Reset value:** `0x0001`  **Access:** see fields below

UART operating mode control register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x1` | UART enable — 1=active, 0=disabled |
| `LOOPBACK` | `[1]` | RW | `0x0` | Internal loopback test mode — 1=TX tied to RX internally |
| `FRAME_FMT` | `[7:4]` | RW | `0x0` | Frame format: 0=8N1, 1=8E1, 2=8O1, 3=8N2 |
| `PARITY_ERR_MASK` | `[8]` | RW | `0x0` | Mask parity error interrupts: 0=enabled, 1=masked |

---
### `UART_STATUS` — Address `0x0102`

**Reset value:** `0x0000`  **Access:** see fields below

UART operational status flags; read-clears on read

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_BUSY` | `[0]` | RC | `0x0` | Transmitter active — 1=TX in progress |
| `RX_AVAIL` | `[1]` | RC | `0x0` | RX FIFO has data — 1=data available |
| `FRAME_ERR` | `[2]` | RC | `0x0` | Framing error detected on RX |
| `OVERRUN` | `[3]` | RC | `0x0` | RX FIFO overrun — data lost |
| `PARITY_ERR` | `[4]` | RC | `0x0` | Parity error detected |

---
### `UART_TX_COUNT` — Address `0x0103`

**Reset value:** `0x0000`  **Access:** see fields below

Number of bytes currently in the TX FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | TX FIFO occupancy (0–255) |

---
### `UART_RX_COUNT` — Address `0x0104`

**Reset value:** `0x0000`  **Access:** see fields below

Number of bytes currently in the RX FIFO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `COUNT` | `[7:0]` | R | `0x00` | RX FIFO occupancy (0–255) |

---
### `ETH_MAC_LOW` — Address `0x0110`

**Reset value:** `0x0000`  **Access:** see fields below

Lower 16 bits of the EUI-48 MAC address from 24AA025E48 EEPROM

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC[15:0]` | `[15:0]` | R | `0x0000` | Loaded from I2C EEPROM at power-up |

---
### `ETH_MAC_HIGH` — Address `0x0111`

**Reset value:** `0x0000`  **Access:** see fields below

Upper 16 bits of the EUI-48 MAC address from 24AA025E48 EEPROM

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MAC[31:16]` | `[15:0]` | R | `0x0000` | Loaded from I2C EEPROM at power-up |

---
### `ADC_CTRL` — Address `0x0200`

**Reset value:** `0x0000`  **Access:** see fields below

AD9643 dual-channel ADC control register for IF2 digitisation

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `START` | `[0]` | RW | `0x0` | Start single conversion burst — auto-clears |
| `CONTINUOUS` | `[1]` | RW | `0x0` | Continuous sampling mode — 1=run continuously at 170 MSPS |
| `CH_SEL` | `[3:2]` | RW | `0x0` | Channel select: 0=Both channels, 1=Channel A only, 2=Channel B only, 3=reserved |
| `DATA_FMT` | `[5:4]` | RW | `0x0` | Output data format: 0=offset binary, 1=twos complement |
| `SPI_RESET` | `[6]` | RW | `0x0` | Soft-reset the ADC SPI interface — write 1 then 0 |
| `PDWN_MODE` | `[7]` | RW | `0x0` | ADC power-down: 0=normal operation, 1=power-down |

---
### `ADC_STATUS` — Address `0x0201`

**Reset value:** `0x0000`  **Access:** see fields below

AD9643 ADC status flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_READY` | `[0]` | RC | `0x0` | ADC conversion data available — read-clears |
| `OVERRANGE` | `[1]` | RC | `0x0` | Input signal exceeded ADC full-scale — indicates clipping |
| `CH_A_ACTIVE` | `[2]` | R | `0x0` | Channel A is actively sampling |
| `CH_B_ACTIVE` | `[3]` | R | `0x0` | Channel B is actively sampling |
| `LVDS_LOCK` | `[4]` | R | `0x0` | LVDS data interface locked — 1=bit-aligned and stable |

---
### `VCC_5V_RAW` — Address `0x0210`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail ADC count from ADM1177 voltage monitor (12-bit, full-scale = 4095 = 5.0V)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count; Volts = count × 5.0 / 4096 |

---
### `VCC_3V3_RAW` — Address `0x0211`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail ADC count from supply monitor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count; Volts = count × 3.3 / 4096 |

---
### `VCC_2V5_RAW` — Address `0x0212`

**Reset value:** `0x0000`  **Access:** see fields below

2.5V rail ADC count (FPGA VCCAUX / ADC reference)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count; Volts = count × 2.5 / 4096 |

---
### `VCC_1V8_RAW` — Address `0x0213`

**Reset value:** `0x0000`  **Access:** see fields below

1.8V rail ADC count (FPGA VCCINT / LVDS bank supply)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count; Volts = count × 1.8 / 4096 |

---
### `ICC_5V_RAW` — Address `0x0218`

**Reset value:** `0x0000`  **Access:** see fields below

5V rail current ADC count from ADM1177 current-sense amplifier (sense resistor based)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count; Amps = count × Imax / 4096 |

---
### `ICC_3V3_RAW` — Address `0x0219`

**Reset value:** `0x0000`  **Access:** see fields below

3.3V rail current ADC count from current-sense monitor

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_COUNT` | `[11:0]` | R | `0x000` | Raw ADC count; Amps = count × Imax / 4096 |

---
### `TEMP_LOCAL` — Address `0x0300`

**Reset value:** `0x0000`  **Access:** see fields below

Kintex-7 FPGA die temperature from internal XADC in 0.25°C units (signed 10-bit)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Signed temperature; °C = value × 0.25 |

---
### `TEMP_REMOTE1` — Address `0x0301`

**Reset value:** `0x0000`  **Access:** see fields below

Remote TMP116 sensor 1 temperature (RF section near LNAs) in 0.0625°C steps

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Signed temperature reading from I2C sensor 1 |

---
### `TEMP_REMOTE2` — Address `0x0302`

**Reset value:** `0x0000`  **Access:** see fields below

Remote TMP116 sensor 2 temperature (PLL/VCO section) in 0.0625°C steps

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP` | `[9:0]` | R | `0x000` | Signed temperature reading from I2C sensor 2 |

---
### `TEMP_ALERT_HIGH` — Address `0x0308`

**Reset value:** `0x0190`  **Access:** see fields below

Over-temperature alert threshold for safety shutdown — triggers HEALTH_STATUS[0] de-assertion

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESH` | `[9:0]` | RW | `0x190` | High threshold; default 0x190 = 100.0°C in 0.25°C units |

---
### `TEMP_ALERT_LOW` — Address `0x0309`

**Reset value:** `0xFF9C`  **Access:** see fields below

Under-temperature alert threshold — triggers cold-warning in HEALTH_STATUS

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THRESH` | `[9:0]` | RW | `0x19C` | Low threshold; default 0xFF9C (signed) = -25.0°C in 0.25°C units |

---
### `HEALTH_STATUS` — Address `0x030F`

**Reset value:** `0x0000`  **Access:** see fields below

Aggregated system health flags — all must be 1 for SYSTEM_OK

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_OK` | `[0]` | R | `0x0` | All temperatures within alert thresholds |
| `VOLT_OK` | `[1]` | R | `0x0` | All supply voltages within ±5% of nominal |
| `PLL_LOCK` | `[2]` | R | `0x0` | ADF4106 PLL is locked to reference |
| `ADC_OK` | `[3]` | R | `0x0` | AD9643 ADC is operational and not in overrange |
| `FLASH_OK` | `[4]` | R | `0x0` | Configuration flash interface is ready |
| `EEPROM_OK` | `[5]` | R | `0x0` | I2C EEPROM communication successful |
| `RF_OK` | `[6]` | R | `0x0` | RF front-end power detectors indicate nominal signal levels |
| `SYSTEM_OK` | `[7]` | R | `0x0` | All health checks pass — system is fully operational |

---
### `PLL_CTRL` — Address `0x0400`

**Reset value:** `0x0000`  **Access:** see fields below

ADF4106 PLL synthesizer control for LO1 (4–8 GHz VCO) and LO2 (1.1 GHz)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ENABLE` | `[0]` | RW | `0x0` | PLL chip enable — 1=active, 0=power-down |
| `RESET` | `[1]` | RW | `0x0` | Soft-reset the ADF4106 — self-clearing |
| `REF_SEL` | `[3:2]` | RW | `0x0` | Reference clock select: 0=10 MHz OCXO (OSJ7014), 1=external ref, 2=reserved, 3=bypass |
| `LO_SEL` | `[5:4]` | RW | `0x0` | LO target select: 0=LO1 (tunable 3.3–7.3 GHz), 1=LO2 (fixed 1.1 GHz), 2=both, 3=reserved |
| `CP_CURRENT` | `[7:6]` | RW | `0x0` | Charge pump current: 0=0.5 mA, 1=1.0 mA, 2=2.5 mA, 3=5.0 mA |
| `SPI_LATCH` | `[8]` | RW | `0x0` | Manual SPI latch — write 1 to latch current SPI register set into ADF4106 |

---
### `PLL_STATUS` — Address `0x0401`

**Reset value:** `0x0000`  **Access:** see fields below

ADF4106 PLL lock and fault status

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCKED` | `[0]` | RC | `0x0` | PLL is phase-locked to the 10 MHz OCXO reference |
| `LOSS_OF_LOCK` | `[1]` | RC | `0x0` | PLL has lost lock since last read — read-clears |
| `LOSS_OF_REF` | `[2]` | RC | `0x0` | 10 MHz reference signal lost or out of tolerance |
| `VCO_OUT_OF_RANGE` | `[3]` | RC | `0x0` | VCO frequency is beyond specified tuning range (4–8 GHz) |

---
### `PLL_N_DIV` — Address `0x0402`

**Reset value:** `0x0088`  **Access:** see fields below

PLL N-divider (main divider) value for ADF4106 — determines the LO frequency: f_LO = f_REF × (N / R)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `N_DIV` | `[15:0]` | RW | `0x0088` | N divider value (1–8191); default 136 = LO at 1360 MHz (tune for LO1 3300–7300) |

---
### `PLL_R_DIV` — Address `0x0403`

**Reset value:** `0x0001`  **Access:** see fields below

PLL R-divider (reference divider) value for ADF4106 — divides 10 MHz OCXO reference

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `R_DIV` | `[7:0]` | RW | `0x01` | R divider value (1–16383); default 1 → f_PFD = 10 MHz |

---
### `CLK_ENABLE` — Address `0x0410`

**Reset value:** `0x0000`  **Access:** see fields below

LMK1C1102 LVCMOS clock buffer output enables — one bit per clock output channel

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLK_OUT0_EN` | `[0]` | RW | `0x0` | ADC sample clock output enable (AD9643 CLK+) — 170 MHz |
| `CLK_OUT1_EN` | `[1]` | RW | `0x0` | FPGA processing clock output enable — derived from PLL |
| `CLK_OUT2_EN` | `[2]` | RW | `0x0` | LO2 reference clock output enable |
| `CLK_OUT3_EN` | `[3]` | RW | `0x0` | System synchronisation / PRI clock output enable |
| `GLOBAL_EN` | `[7]` | RW | `0x0` | Global clock output enable — gates all individual enables |

---
### `EEPROM_CTRL` — Address `0x0500`

**Reset value:** `0x0000`  **Access:** see fields below

24AA025E48 I2C EEPROM control for calibration data and MAC storage

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate EEPROM read — auto-clears |
| `WRITE` | `[1]` | RW | `0x0` | Initiate EEPROM write — auto-clears |
| `ERASE` | `[2]` | RW | `0x0` | Erase 16-byte page — requires UNLOCK key written first |
| `UNLOCK` | `[5:4]` | W | `0x0` | Write 0xA5 to bits [5:4] before erase to unlock protection |
| `BUSY` | `[7]` | R | `0x0` | EEPROM operation in progress — 1=busy (poll until 0) |

---
### `EEPROM_ADDR` — Address `0x0501`

**Reset value:** `0x0000`  **Access:** see fields below

24AA025E48 EEPROM byte address for next read/write operation

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR` | `[11:0]` | RW | `0x000` | 12-bit EEPROM byte address (0–4095) — 24AA025E48 is 2Kbit organized as 256×8 |

---
### `EEPROM_DATA` — Address `0x0502`

**Reset value:** `0x0000`  **Access:** see fields below

EEPROM read/write data register — auto-increments address on sequential access

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data to write or data read back from EEPROM |

---
### `FLASH_CTRL` — Address `0x0600`

**Reset value:** `0x0000`  **Access:** see fields below

AT25SL321 32Mb SPI Flash control for FPGA configuration storage

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READ` | `[0]` | RW | `0x0` | Initiate flash read — auto-clears |
| `WRITE` | `[1]` | RW | `0x0` | Initiate flash page program — auto-clears |
| `ERASE_SECTOR` | `[2]` | RW | `0x0` | Erase 4KB sector — requires UNLOCK sequence |
| `ERASE_CHIP` | `[3]` | RW | `0x0` | Full chip erase — requires extended unlock sequence |
| `WRITE_ENABLE` | `[4]` | RW | `0x0` | Set write-enable latch in flash — must be 1 before any write/erase |
| `UNLOCK_KEY` | `[6:5]` | W | `0x0` | Write 0xA5 to unlock erase operations — protection against accidental erase |
| `BUSY` | `[7]` | R | `0x0` | Flash operation in progress — 1=busy (poll until 0) |

---
### `FLASH_ADDR_LOW` — Address `0x0601`

**Reset value:** `0x0000`  **Access:** see fields below

AT25SL321 Flash address lower 16 bits [15:0]

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_LOW` | `[15:0]` | RW | `0x0000` | Lower 16 bits of 22-bit flash address |

---
### `FLASH_ADDR_HIGH` — Address `0x0602`

**Reset value:** `0x0000`  **Access:** see fields below

AT25SL321 Flash address upper bits [21:16] — 32Mb = 4MB = 22-bit address space

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADDR_HIGH` | `[5:0]` | RW | `0x00` | Upper 6 bits of 22-bit flash address |
| `DUMMY_CYCLES` | `[7:6]` | RW | `0x0` | Dummy clock cycles for high-speed read: 0=0, 1=4, 2=8, 3=16 |

---
### `FLASH_DATA` — Address `0x0603`

**Reset value:** `0x0000`  **Access:** see fields below

Flash read/write data FIFO — 16-bit wide, auto-increments flash address on each access

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA` | `[15:0]` | RW | `0x0000` | Data byte/word for flash read or write operations (lower 8 bits used in byte mode) |

---
### `FLASH_STATUS` — Address `0x0604`

**Reset value:** `0x0001`  **Access:** see fields below

AT25SL321 flash device status and error flags

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `READY` | `[0]` | R | `0x1` | Flash device is ready for commands — 1=idle/ready |
| `WRITE_ERR` | `[1]` | RC | `0x0` | Flash write error — read-clears |
| `ERASE_ERR` | `[2]` | RC | `0x0` | Flash erase error — read-clears |
| `WRITE_ENABLED` | `[3]` | R | `0x0` | Flash write-enable latch is set |
| `SECTOR_PROTECT` | `[4]` | R | `0x0` | Current sector is write-protected |

---
### `RF_LNA_CTRL` — Address `0x0700`

**Reset value:** `0x0000`  **Access:** see fields below

GRF2074 LNA bias enable and gain control for both receiver channels

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LNA_A_EN` | `[0]` | RW | `0x0` | Channel A LNA bias enable — 1=LNA on, 0=LNA powered down |
| `LNA_B_EN` | `[1]` | RW | `0x0` | Channel B LNA bias enable — 1=LNA on, 0=LNA powered down |
| `LNA_A_GAIN` | `[3:2]` | RW | `0x0` | Channel A LNA gain setting: 0=+20 dB, 1=+17 dB, 2=+14 dB, 3=bypass |
| `LNA_B_GAIN` | `[5:4]` | RW | `0x0` | Channel B LNA gain setting: 0=+20 dB, 1=+17 dB, 2=+14 dB, 3=bypass |

---
### `RF_PHASE_CTRL` — Address `0x0701`

**Reset value:** `0x0000`  **Access:** see fields below

Phase control register for inter-channel phase alignment and calibration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CH_A_PHASE` | `[7:0]` | RW | `0x00` | Channel A phase offset in 1.4° steps (0–357°, 256 steps) for phase-coherent calibration |
| `CH_B_PHASE` | `[15:8]` | RW | `0x00` | Channel B phase offset in 1.4° steps (0–357°, 256 steps) |

---
### `RF_POWER_DETECT_A` — Address `0x0710`

**Reset value:** `0x0000`  **Access:** see fields below

Channel A RF power detector ADC reading from limiter output (preselector stage)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `POWER_DBM` | `[11:0]` | R | `0x000` | 12-bit ADC count proportional to RF input power in dBm (detector log slope ~25 mV/dB) |

---
### `RF_POWER_DETECT_B` — Address `0x0711`

**Reset value:** `0x0000`  **Access:** see fields below

Channel B RF power detector ADC reading from limiter output

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `POWER_DBM` | `[11:0]` | R | `0x000` | 12-bit ADC count proportional to RF input power in dBm |

---
### `IF1_GAIN_CTRL` — Address `0x0718`

**Reset value:** `0x0000`  **Access:** see fields below

1st IF (1300 MHz) chain gain control for IF driver amplifier HMC788ALP2E and buffer GRF2040

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IF1_CHA_GAIN` | `[3:0]` | RW | `0x0` | Channel A IF1 gain in 1 dB steps (0–15 dB range, linear step) |
| `IF1_CHB_GAIN` | `[7:4]` | RW | `0x0` | Channel B IF1 gain in 1 dB steps (0–15 dB range, linear step) |
| `IF1_AMP_EN` | `[8]` | RW | `0x0` | IF1 amplifier enable — 1=both IF chains active |

---
### `IF2_GAIN_CTRL` — Address `0x0719`

**Reset value:** `0x0000`  **Access:** see fields below

2nd IF (200 MHz) chain gain control and IF filter selection

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IF2_CHA_GAIN` | `[3:0]` | RW | `0x0` | Channel A IF2 gain in 0.5 dB steps (0–7.5 dB) |
| `IF2_CHB_GAIN` | `[7:4]` | RW | `0x0` | Channel B IF2 gain in 0.5 dB steps (0–7.5 dB) |
| `BPF_SEL` | `[9:8]` | RW | `0x0` | Bandpass filter select: 0=narrow (5 MHz BW), 1=medium (20 MHz BW), 2=wide (50 MHz BW), 3=bypass |

---
### `LO_POWER_CTRL` — Address `0x0720`

**Reset value:** `0x0000`  **Access:** see fields below

LO power splitter and VCO enable control for EP2K1+ splitter and HMC586LC4B VCO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LO1_EN` | `[0]` | RW | `0x0` | LO1 VCO (HMC586LC4B) enable — 1=VCO operating, 0=VCO off |
| `LO2_EN` | `[1]` | RW | `0x0` | LO2 synthesizer enable — 1=LO2 active |
| `SPLITTER_EN` | `[2]` | RW | `0x0` | LO power splitter (EP2K1+) output enable — 1=splitter active |
| `VCO_TUNE_DAC` | `[7:4]` | RW | `0x0` | VCO coarse tune DAC value (4-bit, 0–15) for centering PLL tuning voltage |

---
### `GPIO_DIR` — Address `0x0800`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO direction control — one bit per GPIO pin, for FMC+ interface lines and test points

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DIR` | `[15:0]` | RW | `0x0000` | Per-pin direction: 0=input, 1=output. Default all inputs for safety |

---
### `GPIO_DATA_OUT` — Address `0x0801`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO output data register — writes to pins configured as outputs in GPIO_DIR

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_OUT` | `[15:0]` | RW | `0x0000` | Output data for GPIO[15:0]. Only effective when corresponding DIR bit = 1 |

---
### `GPIO_DATA_IN` — Address `0x0802`

**Reset value:** `0x0000`  **Access:** see fields below

GPIO input data register — reflects current state of all GPIO pins regardless of direction

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DATA_IN` | `[15:0]` | R | `0x0000` | Current state of GPIO[15:0] pins (synchronous to FPGA clock) |

---
### `DSP_CTRL` — Address `0x0900`

**Reset value:** `0x0000`  **Access:** see fields below

Radar DSP processing control for pulse compression, CFAR, and data formatting

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DSP_ENABLE` | `[0]` | RW | `0x0` | Enable DSP processing pipeline — 1=active |
| `CFAR_ENABLE` | `[1]` | RW | `0x0` | Enable CFAR detection algorithm |
| `PULSE_COMP_EN` | `[2]` | RW | `0x0` | Enable pulse compression (matched filtering) |
| `DATA_FMT` | `[4:3]` | RW | `0x0` | Output data format: 0=raw IQ, 1=magnitude, 2=detection flags, 3=compressed pulses |
| `CH_MODE` | `[6:5]` | RW | `0x0` | Channel processing mode: 0=CH_A only, 1=CH_B only, 2=both (interleaved), 3=coherent processing |
| `THRESH_ADJ` | `[7]` | RW | `0x0` | Threshold adjustment source: 0=register value, 1=adaptive from CFAR |

---
### `PRI_CTRL` — Address `0x0901`

**Reset value:** `0x0000`  **Access:** see fields below

Pulse Repetition Interval timing control for radar synchronisation

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PRI_PERIOD` | `[11:0]` | RW | `0x000` | PRI period in units of 10 ns (system clock cycles). Range: 0–4095 × 10 ns = 0–40.95 µs |
| `PRI_SYNC_EN` | `[12]` | RW | `0x0` | PRI synchronisation output enable on FMC+ sync pin |
| `PRI_MODE` | `[14:13]` | RW | `0x0` | PRI mode: 0=continuous, 1=triggered, 2=dwell-switch, 3=reserved |
| `PRI_ARM` | `[15]` | RW | `0x0` | Arm PRI generator — write 1 to start, write 0 to stop |
