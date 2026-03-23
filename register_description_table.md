# Register Description Table
## rf1

> **Total registers:** 19

rf1 Multi-Rail DC-DC Converter Register Map: 16 memory-mapped registers for digital control, monitoring, and protection configuration of three synchronous buck outputs (12V/5V/3.3V). Includes voltage monitoring, current sensing, soft-start timing, UVLO thresholds, OCP configuration, output enable control, fault status, and device ID. Default reset values implement safe startup conditions with all outputs disabled and nominal protection thresholds.

---
### `DEVICE_ID` — Address: `0x00`
**Reset value:** `0xA5C1`

Device identification register for silicon validation

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DEV_ID` | `[15:0]` | R | `0xA5C1` | Fixed device ID - reads 0xA5C1 for rf1 silicon |

---
### `REVISION` — Address: `0x01`
**Reset value:** `0x01`

Silicon revision number

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `MINOR_REV` | `[7:0]` | R | `0x01` | Minor revision number |
| `MAJOR_REV` | `[15:8]` | R | `0x01` | Major revision number |

---
### `GLOBAL_CTRL` — Address: `0x02`
**Reset value:** `0x0000`

Global control and enable for all rails

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SOFT_START_EN` | `[0]` | RW | `0` | Enable soft-start sequence on all rails |
| `EN_3V3_RAIL` | `[1]` | RW | `0` | Enable 3.3V output rail (requires EN_5V_RAIL=1) |
| `EN_5V_RAIL` | `[2]` | RW | `0` | Enable 5V output rail (requires EN_12V_RAIL=1) |
| `EN_12V_RAIL` | `[3]` | RW | `0` | Enable 12V output rail (primary) |
| `GLOBAL_RESET` | `[15]` | W | `0` | Write 1 to trigger soft-reset (self-clearing) |
| `RSVD` | `[14:4]` | R | `0x000` | Reserved - read as 0 |

---
### `UVLO_CONFIG` — Address: `0x03`
**Reset value:** `0x0E74`

Under-Voltage Lockout threshold configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UVLO_HYST` | `[7:0]` | RW | `0x74` | UVLO hysteresis in mV (default 2.0V) |
| `UVLO_THRESHOLD` | `[15:8]` | RW | `0x0E` | UVLO threshold - 35V (0x0E * 2.5V) for 48V nominal input |

---
### `RAIL12_TARGET` — Address: `0x04`
**Reset value:** `0x0BB8`

12V rail target output voltage (10mV LSB)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TARGET_12V` | `[11:0]` | RW | `0x0BB8` | Target voltage in 10mV units (0x0BB8 = 3000 = 12.000V) |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `RAIL5_TARGET` — Address: `0x05`
**Reset value:** `0x0320`

5V rail target output voltage (10mV LSB)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TARGET_5V` | `[11:0]` | RW | `0x0320` | Target voltage in 10mV units (0x0320 = 800 = 5.000V) |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `RAIL3V3_TARGET` — Address: `0x06`
**Reset value:** `0x0208`

3.3V rail target output voltage (10mV LSB)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TARGET_3V3` | `[11:0]` | RW | `0x0208` | Target voltage in 10mV units (0x0208 = 528 = 3.300V) |
| `RSVD` | `[15:12]` | R | `0x0` | Reserved |

---
### `RAIL12_OCP_LIMIT` — Address: `0x07`
**Reset value:** `0x0FA0`

12V rail over-current protection threshold (10mA LSB)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OCP_12V` | `[11:0]` | RW | `0x0FA0` | OCP threshold in 10mA units (0x0FA0 = 4000 = 12.0A, +20% margin) |
| `OCP_LATCH_EN` | `[15]` | RW | `1` | Latch-off on OCP (1 = latched, 0 = auto-retry) |
| `RSVD` | `[14:12]` | R | `0x0` | Reserved |

---
### `RAIL5_OCP_LIMIT` — Address: `0x08`
**Reset value:** `0x0BB8`

5V rail over-current protection threshold (10mA LSB)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OCP_5V` | `[11:0]` | RW | `0x0BB8` | OCP threshold in 10mA units (0x0BB8 = 3000 = 9.0A, +12% margin) |
| `OCP_LATCH_EN` | `[15]` | RW | `1` | Latch-off on OCP (1 = latched, 0 = auto-retry) |
| `RSVD` | `[14:12]` | R | `0x0` | Reserved |

---
### `RAIL3V3_OCP_LIMIT` — Address: `0x09`
**Reset value:** `0x0E10`

3.3V rail over-current protection threshold (10mA LSB)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OCP_3V3` | `[11:0]` | RW | `0x0E10` | OCP threshold in 10mA units (0x0E10 = 3600 = 14.4A, +20% margin) |
| `OCP_LATCH_EN` | `[15]` | RW | `1` | Latch-off on OCP (1 = latched, 0 = auto-retry) |
| `RSVD` | `[14:12]` | R | `0x0` | Reserved |

---
### `SOFT_START_CONFIG` — Address: `0x0A`
**Reset value:** `0x012C`

Soft-start timing configuration (all rails)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SS_TIME_MS` | `[11:0]` | RW | `0x012C` | Soft-start duration in 100us units (0x012C = 30.0ms) |
| `SS_RAMP_TYPE` | `[14]` | RW | `0` | Ramp type: 0=linear, 1=exponential |
| `SS_EN` | `[15]` | RW | `1` | Soft-start enable (requires GLOBAL_CTRL.SS_EN=1) |
| `RSVD` | `[13:12]` | R | `0x0` | Reserved |

---
### `RAIL12_VOUT_MON` — Address: `0x0B`
**Reset value:** `0x0000`

12V rail output voltage monitor (10mV LSB, RO)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VOUT_12V` | `[11:0]` | R | `0x000` | Measured output voltage in 10mV units (ADC reading) |
| `VALID` | `[15]` | R | `0` | 1 = measurement valid, 0 = conversion in progress |

---
### `RAIL5_VOUT_MON` — Address: `0x0C`
**Reset value:** `0x0000`

5V rail output voltage monitor (10mV LSB, RO)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VOUT_5V` | `[11:0]` | R | `0x000` | Measured output voltage in 10mV units (ADC reading) |
| `VALID` | `[15]` | R | `0` | 1 = measurement valid, 0 = conversion in progress |

---
### `RAIL3V3_VOUT_MON` — Address: `0x0D`
**Reset value:** `0x0000`

3.3V rail output voltage monitor (10mV LSB, RO)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VOUT_3V3` | `[11:0]` | R | `0x000` | Measured output voltage in 10mV units (ADC reading) |
| `VALID` | `[15]` | R | `0` | 1 = measurement valid, 0 = conversion in progress |

---
### `RAIL12_IOUT_MON` — Address: `0x0E`
**Reset value:** `0x0000`

12V rail output current monitor (10mA LSB, RO)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IOUT_12V` | `[11:0]` | R | `0x000` | Measured output current in 10mA units (ADC reading) |
| `VALID` | `[15]` | R | `0` | 1 = measurement valid, 0 = conversion in progress |

---
### `RAIL5_IOUT_MON` — Address: `0x0F`
**Reset value:** `0x0000`

5V rail output current monitor (10mA LSB, RO)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IOUT_5V` | `[11:0]` | R | `0x000` | Measured output current in 10mA units (ADC reading) |
| `VALID` | `[15]` | R | `0` | 1 = measurement valid, 0 = conversion in progress |

---
### `RAIL3V3_IOUT_MON` — Address: `0x10`
**Reset value:** `0x0000`

3.3V rail output current monitor (10mA LSB, RO)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `IOUT_3V3` | `[11:0]` | R | `0x000` | Measured output current in 10mA units (ADC reading) |
| `VALID` | `[15]` | R | `0` | 1 = measurement valid, 0 = conversion in progress |

---
### `FAULT_STATUS` — Address: `0x11`
**Reset value:** `0x0000`

Fault status flags (write 1 to clear)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `UVLO_TRIP` | `[0]` | RC | `0` | Under-voltage lockout triggered |
| `OCP_12V_TRIP` | `[1]` | RC | `0` | 12V rail over-current trip |
| `OCP_5V_TRIP` | `[2]` | RC | `0` | 5V rail over-current trip |
| `OCP_3V3_TRIP` | `[3]` | RC | `0` | 3.3V rail over-current trip |
| `OVP_12V_TRIP` | `[4]` | RC | `0` | 12V rail over-voltage trip |
| `OVP_5V_TRIP` | `[5]` | RC | `0` | 5V rail over-voltage trip |
| `OVP_3V3_TRIP` | `[6]` | RC | `0` | 3.3V rail over-voltage trip |
| `THERMAL_SHDN` | `[7]` | RC | `0` | Thermal shutdown triggered |
| `FAULT_SUMMARY` | `[15]` | R | `0` | OR of all fault bits |
| `RSVD` | `[14:8]` | R | `0x00` | Reserved |

---
### `INPUT_VIN_MON` — Address: `0x12`
**Reset value:** `0x0000`

Input voltage monitor (48V nominal, 100mV LSB, RO)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VIN_MEAS` | `[11:0]` | R | `0x000` | Measured input voltage in 100mV units |
| `VALID` | `[15]` | R | `0` | 1 = measurement valid, 0 = conversion in progress |
