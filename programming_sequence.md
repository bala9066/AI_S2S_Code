# Programming Sequence (PSQ)
## rffff

> **Total steps:** 13

| # | Phase | Register | Address | Value | Condition | Rationale |
|---|-------|----------|---------|-------|-----------|-----------|
| 1 | Power-On Reset | `FPGA_SYS_CTRL` | `0x0000` | `0x00000001` | Wait 10ms | Assert soft reset to initialize all FPGA logic to known state |
| 2 | Power Rail Verification | `FPGA_PWR_STATUS` | `0x0004` | `0x00000000` | Poll ALL_RAILS_OK=1 (timeout 500ms) | Verify all DC-DC converters have reached power-good status before proceeding |
| 3 | Clock Init | `FPGA_SYS_CTRL` | `0x0000` | `0x00000000` | Wait 5ms for clock stabilization | Release soft reset - 125MHz oscillator U14 and clock buffer U15 now provide stable REF_CLK |
| 4 | DAC Init | `DAC_SPI_CFG_REG` | `0x0100` | `0x00000008` | Wait 1ms | Enable DAC clocks and power up DAC core while keeping outputs disabled |
| 5 | DAC Config | `DAC_JESD_CFG_REG` | `0x0104` | `0x000000A3` | Wait 1ms | Configure JESD204B: enable both lanes, subclass 1, scrambler on |
| 6 | JESD Link Reset | `FPGA_JESD_CTRL` | `0x0008` | `0x00000001` | Wait 100us |  |
| 7 | JESD Link Enable | `FPGA_JESD_CTRL` | `0x0008` | `0x00000025` | Poll LINK_READY=1 (timeout 100ms) | Enable JESD204B with 2 lanes, scrambler, subclass 1; wait for code group sync |
| 8 | VCO Init | `VCO_SPI_CFG_REG` | `0x0200` | `0x00000001` | Wait 1ms | Enable VCO core with default div4 setting |
| 9 | VCO Frequency Tune | `VCO_FREQ_REG` | `0x0204` | `0x00008000` | Poll FREQ_LOCK=1 (timeout 50ms) | Set VTUNE to mid-scale and verify lock; adjust BAND_SEL/VTUNE for target frequency |
| 10 | System Enable | `FPGA_SYS_CTRL` | `0x0000` | `0x0000000C` | None | Enable DAC and VCO outputs - JESD now streaming, LO active |
| 11 | RF Power Enable | `DAC_SPI_CFG_REG` | `0x0100` | `0x00000038` | Wait 500us for PA bias to settle | Enable DAC TX output drivers and set 4x interpolation mode |
| 12 | Final Enable | `FPGA_RF_POWER` | `0x0014` | `0x01000000` | None | Set RF_OUTPUT_EN=1 - PA now active and RF signal on output connector J2 |
| 13 | Operational | `FPGA_RF_POWER` | `0x0014` | `0x01000204` | Continuous monitor of FPGA_JESD_STATUS for errors | Set default DAC gain (mid-scale) and zero attenuation for max output |

---

## Detailed Steps

### Step 1 — Power-On Reset
- **Register:** `FPGA_SYS_CTRL` at `0x0000`
- **Write value:** `0x00000001`
- **Wait/Poll:** Wait 10ms
- **Rationale:** Assert soft reset to initialize all FPGA logic to known state

### Step 2 — Power Rail Verification
- **Register:** `FPGA_PWR_STATUS` at `0x0004`
- **Write value:** `0x00000000`
- **Wait/Poll:** Poll ALL_RAILS_OK=1 (timeout 500ms)
- **Rationale:** Verify all DC-DC converters have reached power-good status before proceeding

### Step 3 — Clock Init
- **Register:** `FPGA_SYS_CTRL` at `0x0000`
- **Write value:** `0x00000000`
- **Wait/Poll:** Wait 5ms for clock stabilization
- **Rationale:** Release soft reset - 125MHz oscillator U14 and clock buffer U15 now provide stable REF_CLK

### Step 4 — DAC Init
- **Register:** `DAC_SPI_CFG_REG` at `0x0100`
- **Write value:** `0x00000008`
- **Wait/Poll:** Wait 1ms
- **Rationale:** Enable DAC clocks and power up DAC core while keeping outputs disabled

### Step 5 — DAC Config
- **Register:** `DAC_JESD_CFG_REG` at `0x0104`
- **Write value:** `0x000000A3`
- **Wait/Poll:** Wait 1ms
- **Rationale:** Configure JESD204B: enable both lanes, subclass 1, scrambler on

### Step 6 — JESD Link Reset
- **Register:** `FPGA_JESD_CTRL` at `0x0008`
- **Write value:** `0x00000001`
- **Wait/Poll:** Wait 100us
- **Rationale:** 

### Step 7 — JESD Link Enable
- **Register:** `FPGA_JESD_CTRL` at `0x0008`
- **Write value:** `0x00000025`
- **Wait/Poll:** Poll LINK_READY=1 (timeout 100ms)
- **Rationale:** Enable JESD204B with 2 lanes, scrambler, subclass 1; wait for code group sync

### Step 8 — VCO Init
- **Register:** `VCO_SPI_CFG_REG` at `0x0200`
- **Write value:** `0x00000001`
- **Wait/Poll:** Wait 1ms
- **Rationale:** Enable VCO core with default div4 setting

### Step 9 — VCO Frequency Tune
- **Register:** `VCO_FREQ_REG` at `0x0204`
- **Write value:** `0x00008000`
- **Wait/Poll:** Poll FREQ_LOCK=1 (timeout 50ms)
- **Rationale:** Set VTUNE to mid-scale and verify lock; adjust BAND_SEL/VTUNE for target frequency

### Step 10 — System Enable
- **Register:** `FPGA_SYS_CTRL` at `0x0000`
- **Write value:** `0x0000000C`
- **Wait/Poll:** None
- **Rationale:** Enable DAC and VCO outputs - JESD now streaming, LO active

### Step 11 — RF Power Enable
- **Register:** `DAC_SPI_CFG_REG` at `0x0100`
- **Write value:** `0x00000038`
- **Wait/Poll:** Wait 500us for PA bias to settle
- **Rationale:** Enable DAC TX output drivers and set 4x interpolation mode

### Step 12 — Final Enable
- **Register:** `FPGA_RF_POWER` at `0x0014`
- **Write value:** `0x01000000`
- **Wait/Poll:** None
- **Rationale:** Set RF_OUTPUT_EN=1 - PA now active and RF signal on output connector J2

### Step 13 — Operational
- **Register:** `FPGA_RF_POWER` at `0x0014`
- **Write value:** `0x01000204`
- **Wait/Poll:** Continuous monitor of FPGA_JESD_STATUS for errors
- **Rationale:** Set default DAC gain (mid-scale) and zero attenuation for max output
