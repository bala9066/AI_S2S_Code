# Register Description Table
## rfgg

> **Total registers:** 8

NOTICE: The rfgg design is a pure analog RF PA with no memory-mapped registers. The following RDT/PSQ represents a PROPOSED digital control interface (I2C/SPI) that could be added for bias control, power sequencing, and telemetry monitoring. Actual implementation requires adding a microcontroller or CPLD.

---
### `PA_CTRL_REG` — Address: `0x0000`
**Reset value:** `0x00`

Main PA Enable and Mode Control Register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_ENABLE` | `[0]` | RW | `0` | Primary TX Enable control (overrides discrete input when digital mode active) |
| `PA1_ENABLE` | `[1]` | RW | `0` | Driver stage (QPA9226) enable - must precede PA2 by >10us |
| `PA2_ENABLE` | `[2]` | RW | `0` | Final stage (QPA9426) enable - requires PA1 already enabled |
| `BYPASS_SEQ` | `[3]` | RW | `0` | Bypass hardware sequencer (LM555) - use only if qualified |
| `RF_DET_EN` | `[4]` | RW | `1` | Enable AD8318 RF power detector output buffer |
| `DIG_MODE_EN` | `[7]` | RW | `0` | Enable digital control mode (1=digital I2C/SPI, 0=discrete pin) |

---
### `PA_BIAS_REG` — Address: `0x0001`
**Reset value:** `0x00`

PA Gate Bias Voltage Control (via DAC or digital pot)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PA1_BIAS_TRIM` | `[5:0]` | RW | `0x20` | QPA9226 gate bias trim (6-bit DAC, maps to 0-5V range) |
| `PA2_BIAS_TRIM` | `[13:8]` | RW | `0x20` | QPA9426 gate bias trim (6-bit DAC, maps to 0-5V range) |
| `BIAS_OVERRIDE_EN` | `[14]` | RW | `0` | Enable digital bias override (requires qualification) |
| `BIAS_RESET` | `[15]` | W | `0` | Reset bias DACs to midcode (self-clearing) |

---
### `BOOST_CTRL_REG` — Address: `0x0002`
**Reset value:** `0x00`

LTC3780 Boost Converter Control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BOOST_ENABLE` | `[0]` | RW | `0` | Enable 12V→28V boost converter output |
| `SOFT_START_SEL` | `[2:1]` | RW | `0` | Soft-start time selection: 00=1ms, 01=5ms, 10=10ms, 11=20ms |
| `OV_THR` | `[5:3]` | RW | `5` | Overvoltage threshold trim (adjusts FB divider via DAC) |
| `CURR_LIMIT` | `[7:6]` | RW | `1` | Current limit setting: 00=5A, 01=7A, 10=9A, 11=10A |

---
### `STATUS_REG` — Address: `0x0003`
**Reset value:** `0x00`

Hardware Status Flags (Read-Only)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_EN_PIN` | `[0]` | R | `0` | State of discrete TX_ENABLE input pin |
| `BOOST_PG` | `[1]` | R | `0` | Power good flag from LTC3780 (28V ready) |
| `OVERTEMP` | `[2]` | R | `0` | Thermal shutdown detected (if sensor added) |
| `OVERCURRENT` | `[3]` | R | `0` | Overcurrent fault latch (requires reset to clear) |
| `DET_FAULT` | `[4]` | R | `0` | RF detector fault (open/short detected) |
| `SEQ_FAULT` | `[5]` | R | `0` | Bias sequencing violation detected |

---
### `RF_DET_ADC_LSB` — Address: `0x0004`
**Reset value:** `0x00`

AD8318 RF Power Detector ADC Reading (Lower Byte)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_LSB` | `[7:0]` | R | `0` | Lower 8 bits of 12-bit ADC reading from VDET_OUT |

---
### `RF_DET_ADC_MSB` — Address: `0x0005`
**Reset value:** `0x00`

AD8318 RF Power Detector ADC Reading (Upper Bits)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `ADC_MSB` | `[3:0]` | R | `0` | Upper 4 bits of 12-bit ADC reading |
| `ADC_VALID` | `[7]` | R | `0` | New sample ready flag (cleared on read) |
| `ADC_OVERRUN` | `[6]` | R | `0` | Sample overrun (previous unread data lost) |

---
### `FAULT_CLEAR_REG` — Address: `0x0006`
**Reset value:** `0x00`

Fault Clear Register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `CLR_OC_FAULT` | `[0]` | W | `0` | Clear overcurrent fault latch (write 1) |

---
### `CONFIG_REG` — Address: `0x0007`
**Reset value:** `0x00`

Configuration and Timing Parameters

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SEQ_DELAY` | `[7:0]` | RW | `10` | Bias sequencer delay in 10us increments (default = 100us) |
| `DET_RANGE` | `[9:8]` | RW | `1` | AD8318 range: 00=60dB, 01=55dB, 10=45dB, 11=35dB |
