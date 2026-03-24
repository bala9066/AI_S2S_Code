# Register Description Table
## rf4

> **Total registers:** 13

Register map and initialization sequence for rf4 2.4 GHz RF Power Amplifier control. Includes 12 registers across 0x00-0x0F address space covering bias control, thermal management, T/R switching, power sequencing, and status monitoring. Initialization follows safe power-up sequence: supply enable → thermal unlock → bias ramp → RF enable with state verification at each step.

---
### `DEVICE_ID` — Address: `0x00`
**Reset value:** `0x52463400`

Device identification register - reads 'RF4' followed by revision

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SIGNATURE` | `[31:0]` | R | `0x52463400` | ASCII 'RF4' + revision (0x52='R', 0x46='F', 0x34='4', 0x00=rev) |

---
### `CTRL_REG` — Address: `0x01`
**Reset value:** `0x00`

Main control register for PA enable and T/R switching

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RF_ENABLE` | `[7]` | RW | `0` | Main RF output enable (1=enabled, 0=disabled) |
| `TX_RX_SELECT` | `[6]` | RW | `0` | T/R switch state (1=TX mode, 0=RX mode) |
| `BYPASS_ENABLE` | `[5]` | RW | `0` | Bypass PA stage (1=bypass, 0=normal amplification) |
| `STANDBY` | `[4]` | RW | `1` | Low-power standby mode (1=standby, 0=active) |
| `RESERVED` | `[3:0]` | R | `0x0` | Reserved - read as 0 |

---
### `STATUS_REG` — Address: `0x02`
**Reset value:** `0x01`

Status flags for thermal, protection, and RF state

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THERMAL_SHUTDOWN` | `[7]` | RC_W1C | `0` | Thermal shutdown triggered (write-1 to clear) |
| `OVERCURRENT_FAULT` | `[6]` | RC_W1C | `0` | Overcurrent protection triggered (write-1 to clear) |
| `VSWR_FAULT` | `[5]` | RC_W1C | `0` | VSWR protection triggered (write-1 to clear) |
| `RF_OUTPUT_READY` | `[4]` | R | `0` | RF output stable and ready (status flag) |
| `BIAS_STABLE` | `[3]` | R | `1` | Bias voltages in regulation (status flag) |
| `THERMAL_WARNING` | `[2]` | R | `0` | Temperature approaching limit (warning flag) |
| `DEVICE_READY` | `[0]` | R | `1` | Device initialization complete |

---
### `BIAS_DRV_REG` — Address: `0x03`
**Reset value:** `0x40`

Driver MMIC stage bias voltage control (0-3.3V range)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BIAS_DRV_CODE` | `[7:0]` | RW | `0x40` | 8-bit DAC code for driver bias (mid-scale at reset) |

---
### `BIAS_PA_REG` — Address: `0x04`
**Reset value:** `0x00`

Final Power Amplifier stage bias voltage control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BIAS_PA_CODE` | `[7:0]` | RW | `0x00` | 8-bit DAC code for PA bias (0V at reset - must be ramped) |

---
### `VGG_GATE_REG` — Address: `0x05`
**Reset value:** `0x00`

Gate bias control for GaN FET final stage

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VGG_GATE_CODE` | `[7:0]` | RW | `0x00` | Gate voltage control (-2V to 0V range, 0V at reset) |

---
### `THERM_LIMIT_REG` — Address: `0x06`
**Reset value:** `0x78`

Thermal protection threshold settings

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SHUTDOWN_THRESHOLD` | `[7:4]` | RW | `0x7` | Thermal shutdown threshold (120°C at 0x7 = 120°C base + encoding) |
| `WARNING_THRESHOLD` | `[3:0]` | RW | `0x8` | Thermal warning threshold (100°C at 0x8) |

---
### `THERM_READ_REG` — Address: `0x07`
**Reset value:** `0x19`

Temperature sensor readback (on-board and PA die)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEMP_DIE` | `[7:4]` | R | `0x1` | PA die temperature (25°C at reset) |
| `TEMP_BOARD` | `[3:0]` | R | `0x9` | PCB temperature sensor (25°C at reset) |

---
### `VCC_MONITOR_REG` — Address: `0x08`
**Reset value:** `0x00`

Supply voltage monitoring and fault detection

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VCC_12V_OK` | `[7]` | R | `0` | 12V main supply within tolerance (1=OK) |
| `VCC_5V_OK` | `[6]` | R | `0` | 5V logic supply OK (1=OK) |
| `VCC_VGG_OK` | `[5]` | R | `0` | Negative gate bias supply OK (1=OK) |
| `VCC_CODE` | `[4:0]` | R | `0x00` | ADC code for 12V supply voltage |

---
### `PROTECT_MASK_REG` — Address: `0x09`
**Reset value:** `0x07`

Protection enable mask - which faults trigger shutdown

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `THERMAL_ENABLE` | `[7]` | RW | `1` | Enable thermal shutdown protection (1=enabled) |
| `OVERCURRENT_ENABLE` | `[6]` | RW | `1` | Enable overcurrent protection (1=enabled) |
| `VSWR_ENABLE` | `[5]` | RW | `1` | Enable VSWR protection (1=enabled) |
| `UNDERVOLT_ENABLE` | `[4]` | RW | `0` | Enable undervoltage lockout (1=enabled) |
| `RESERVED` | `[3:0]` | RW | `0x7` | Reserved for future protection features |

---
### `RAMP_RATE_REG` — Address: `0x0A`
**Reset value:** `0x05`

Bias ramp rate control for soft-start

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `RAMP_STEP_DELAY` | `[7:4]` | RW | `0x0` | Delay per ramp step in microseconds (0=fast, 15=slow) |
| `RAMP_STEP_SIZE` | `[3:0]` | RW | `0x5` | Bias increment per step (1 LSB per step at reset) |

---
### `LOCK_REG` — Address: `0x0E`
**Reset value:** `0x00`

Register write protection lock

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LOCK_KEY` | `[7:0]` | W | `0x00` | Write 0xA5 to unlock protected registers, 0x00 to lock |

---
### `FAULT_LOG_REG` — Address: `0x0F`
**Reset value:** `0x00`

Non-volatile fault history log

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LAST_FAULT_TYPE` | `[7:4]` | R | `0x0` | Last fault type (0=none, 1=thermal, 2=OC, 3=VSWR) |
| `FAULT_COUNT` | `[3:0]` | RC_W1C | `0x0` | Total fault events count (write-1 to clear) |
