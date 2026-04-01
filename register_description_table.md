# Register Description Table
## rf78

> **Total registers:** 9

**rf78 2.4 GHz 10W RF Power Amplifier - Register Map and Programming Sequence**

### Overview
The rf78 is a high-power Bluetooth RF PA module using a GaN final stage (CGRM2812) with +40 dBm output at 28 V. The digital control interface provides safe bias sequencing, fault protection, and power monitoring for the RF chain.

### Register Map Summary (0x0000 - 0x000F)
| Address | Register | Function |
|---------|----------|----------|
| 0x0000 | CTRL_TX_ENABLE | TX enable trigger (initiates bias sequencer) |
| 0x0001 | STATUS_FAULT_FLAGS | Read-clear fault flags (FWD_PWR, REV_PWR, THERMAL) |
| 0x0002 | CFG_COMP_THRESHOLDS | Comparator reference voltages for fault thresholds |
| 0x0003 | CFG_TIMING_SEQ | Bias sequencer delay (default 50ms) |
| 0x0004 | READ_PWR_DETECTOR_FWD | Forward power ADC (0-2.2V → 8-bit) |
| 0x0005 | READ_PWR_DETECTOR_REV | Reverse power ADC (VSWR monitoring) |
| 0x0006 | READ_TEMP_SENSOR | PA temperature ADC (-40°C to +125°C) |
| 0x0007 | CFG_BIAS_CONTROL | Direct bias override (factory use only) |
| 0x000F | DEVICE_ID | Fixed ID 0x78 for module identification |

### Critical Safety Features
1. **Bias Sequencing:** LM555 ensures driver (MGA-43016) biases before PA 28V rail (50ms default delay)
2. **Fault Protection:** Three independent comparators monitor forward power, VSWR (reverse power), and temperature
3. **Safe Shutdown:** Reverse sequencing on disable protects GaN device during power-down
4. **Read-Clear Faults:** RC-type fault bits retain error history until read

### Programming Sequence Highlights
- **Phase 1:** Device identification and safe defaults load
- **Phase 2:** Fault threshold configuration (user-adjustable)
- **Phase 3:** Bias sequencer initiation with automatic driver→PA timing
- **Phase 4:** Continuous fault/power/thermal monitoring during operation
- **Phase 5:** Safe shutdown with reverse sequencing

### Analog Monitoring (via 8-bit ADCs)
- **AD8318 Forward Detector:** ~25 mV/dB slope; usable range ~-60 to 0 dBm at detector input
- **AD8318 Reverse Detector:** VSWR calculation from forward/reverse ratio
- **TMP235 Temperature:** 10 mV/°C with 500 mV offset at -40°C

### Hardware-Specific Notes
- **GaN PA Requirements:** Never enable 28V rail before driver gate bias is stable
- **Comparator Outputs:** LM393 open-drain outputs require external pullup (implemented on-module)
- **Timing Resistor R3:** Sets LM555 monostable period; do not modify without re-characterizing bias timing

---
### `CTRL_TX_ENABLE` — Address: `0x0000`
**Reset value:** `0x00`

TX Enable control register - triggers bias sequencing when set

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TX_EN` | `[0]` | RW | `0` | TX Enable bit - Writing 1 initiates PA bias sequence through LM555 timer. Writing 0 disables PA (safe shutdown sequence initiated). |

---
### `STATUS_FAULT_FLAGS` — Address: `0x0001`
**Reset value:** `0x00`

Read-only fault status register from LM393 comparator outputs

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `FWD_PWR_FAULT` | `[0]` | RC | `0` | Forward power overdrive fault - Set when AD8318 forward detector exceeds threshold (V_FWD_DET > VREF). Indicates output power exceeds safe limits. |
| `REV_PWR_FAULT` | `[1]` | RC | `0` | Reverse power/VSWR fault - Set when AD8318 reverse detector exceeds threshold (V_REV_DET > VREF). Indicates high VSWR or antenna mismatch condition. |
| `THERMAL_FAULT` | `[2]` | RC | `0` | Thermal shutdown fault - Set when TMP235 temperature sensor output exceeds comparator reference (indicates PA die temperature > +85°C). |
| `FAULT_PENDING` | `[7]` | R | `0` | OR combination of all fault bits - Set if any fault condition is currently active. Used for fast polling. |

---
### `CFG_COMP_THRESHOLDS` — Address: `0x0002`
**Reset value:** `0x80`

Comparator reference voltage configuration - sets fault detection thresholds

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VREF_PWR_FWD` | `[2:0]` | RW | `4` | Forward power comparator reference voltage - Sets VREF for forward power detector comparator. Values 0-7 map to 0.4V-2.8V in 0.4V steps. Default 4 = 2.0V (approx +35 dBm threshold). |
| `VREF_PWR_REV` | `[5:3]` | RW | `2` | Reverse power comparator reference voltage - Sets VREF for reverse power/VSWR detector comparator. Values 0-7 map to 0.4V-2.8V in 0.4V steps. Default 2 = 1.2V (approx +10 dBm reverse threshold). |
| `VREF_THERM` | `[7:6]` | RW | `2` | Thermal comparator reference voltage - Sets temperature fault threshold. Values: 0=+70°C, 1=+75°C, 2=+85°C (default), 3=+95°C. |

---
### `CFG_TIMING_SEQ` — Address: `0x0003`
**Reset value:** `0x32`

Bias sequencer timing configuration - controls LM555 monostable timing

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SEQ_DELAY_MS` | `[7:0]` | RW | `0x32` | Bias sequencer delay in milliseconds (50 = 0x32). Controls time between driver enable (DRV_ENABLE) and PA 28V enable (PA_ENABLE_5V). Range: 1-255ms. Factory set to 50ms for safe GaN PA bias sequencing. |

---
### `READ_PWR_DETECTOR_FWD` — Address: `0x0004`
**Reset value:** `0x00`

Forward power detector ADC reading (8-bit approximation of AD8318 output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `V_FWD_ADC` | `[7:0]` | R | `0` | Forward RF power detector voltage (8-bit ADC). 0-255 maps to 0-2.2V input range. AD8318 provides ~25 mV/dB slope. Can be converted to dBm: P(dBm) ≈ (ADC * 0.0863) - 90. Use for power monitoring and calibration. |

---
### `READ_PWR_DETECTOR_REV` — Address: `0x0005`
**Reset value:** `0x00`

Reverse power detector ADC reading (8-bit approximation of AD8318 output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `V_REV_ADC` | `[7:0]` | R | `0` | Reverse RF power detector voltage (8-bit ADC). 0-255 maps to 0-2.2V input range. Used for VSWR calculation and fault detection. Higher values indicate reflected power due to antenna mismatch. |

---
### `READ_TEMP_SENSOR` — Address: `0x0006`
**Reset value:** `0x00`

Temperature sensor ADC reading (8-bit approximation of TMP235 output)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `V_TEMP_ADC` | `[7:0]` | R | `0` | PA temperature sensor voltage (8-bit ADC). 0-255 maps to 0-2.2V. TMP235 slope: 10 mV/°C with 500 mV offset at -40°C. Formula: Temp(°C) = (ADC * 0.00862) - 40. Range: -40°C to +125°C. |

---
### `CFG_BIAS_CONTROL` — Address: `0x0007`
**Reset value:** `0x00`

Direct bias control override - use with caution, bypasses sequencer

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `OVERRIDE_EN` | `[7]` | RW | `0` | Override enable - When set to 1, allows direct control of DRV_EN and PA_EN bits bypassing LM555 sequencer. WARNING: Incorrect bias sequencing can damage GaN PA. |
| `DRV_EN_DIRECT` | `[1]` | RW | `0` | Driver enable direct control - Only active when OVERRIDE_EN=1. Controls Q1 gate directly. 1=Driver enabled (5V bias applied). |
| `PA_EN_DIRECT` | `[0]` | RW | `0` | PA 28V enable direct control - Only active when OVERRIDE_EN=1. Controls Q2/Q3 switching. 1=PA 28V rail enabled. NOTE: Never set PA_EN before DRV_EN - can cause thermal runaway. |

---
### `DEVICE_ID` — Address: `0x000F`
**Reset value:** `0x78`

Device identification register - returns project ID code

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DEVICE_ID` | `[7:0]` | R | `0x78` | Fixed device ID code (0x78 = 'rf78' project identifier). Use for firmware detection and validation. |
