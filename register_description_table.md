# Register Description Table
## rffff

> **Total registers:** 11

rffff RF Transmitter System Register Map - FPGA (XC7A100T) control registers + AD9144 HSDAC (SPI/JESD204B) + HMC733 VCO (SPI). System requires power rail sequencing, DAC calibration, JESD204B link training, and LO VCO tuning before RF transmission enabled.

---
### `FPGA_SYS_CTRL` — Address: `0x0000`
**Reset value:** `0x00000000`

Main system control register for FPGA global operation

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SOFT_RESET` | `[0]` | RW | `0x0` | Software reset - write 1 to reset entire FPGA logic |
| `DAC_ENABLE` | `[1]` | RW | `0x0` | Enable DAC power and JESD204B TX lanes |
| `VCO_ENABLE` | `[2]` | RW | `0x0` | Enable VCO LO output |
| `PA_ENABLE` | `[3]` | RW | `0x0` | Enable PA bias - MUST be sequenced AFTER DAC/VCO stable |
| `RESERVED` | `[31:4]` | R | `0x0` | Reserved - read as 0 |

---
### `FPGA_PWR_STATUS` — Address: `0x0004`
**Reset value:** `0x00000000`

Power good status readback from all DC-DC converters

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `PGD_1V0` | `[0]` | R | `0x0` | FPGA Core 1.0V power good (from R1 pullup) |
| `PGD_1V2` | `[1]` | R | `0x0` | VCCBRAM 1.2V power good (from R2 pullup) |
| `PGD_1V8` | `[2]` | R | `0x0` | VCCAUX 1.8V power good (from R3 pullup) |
| `PGD_3V3` | `[3]` | R | `0x0` | VCCO 3.3V power good from U5 |
| `PGD_5V0` | `[4]` | R | `0x0` | RF 5V power good from U6 |
| `PGD_M5V0` | `[5]` | R | `0x0` | RF -5V power good from U7 |
| `ALL_RAILS_OK` | `[7]` | R | `0x0` | All power rails valid - ready for init |
| `RESERVED` | `[31:8]` | R | `0x0` | Reserved - read as 0 |

---
### `FPGA_JESD_CTRL` — Address: `0x0008`
**Reset value:** `0x00000000`

JESD204B transmitter control to AD9144 DAC

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_RESET` | `[0]` | RW | `0x0` | Reset JESD204B PHY - write 1 to reset |
| `LINK_ENABLE` | `[1]` | RW | `0x0` | Enable JESD204B TX lanes after reset |
| `SYNC_N` | `[2]` | RW | `0x1` | JESD204B SYNC_N output (active low) |
| `LANE_SEL` | `[4:3]` | RW | `0x0` | Lane configuration: 00=1 lane, 01=2 lanes, 10=4 lanes |
| `SCR` | `[6:5]` | RW | `0x1` | Scrambler: 00=off, 01=on (recommended) |
| `SUBCLASS` | `[8:7]` | RW | `0x0` | JESD subclass: 00=0, 01=1 (deterministic latency) |
| `RESERVED` | `[31:9]` | R | `0x0` | Reserved - read as 0 |

---
### `FPGA_JESD_STATUS` — Address: `0x000C`
**Reset value:** `0x00000000`

JESD204B link status monitoring

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `LINK_READY` | `[0]` | R | `0x0` | JESD link aligned and code group sync achieved |
| `PHY_READY` | `[1]` | R | `0x0` | Transceiver PHY PLL locked |
| `SYNC_STATE` | `[2]` | R | `0x0` | 1=SYNC_N asserted (requesting sync) |
| `CODE_ERR` | `[3]` | RC | `0x0` | Code group sync error (read clears) |
| `DISP_ERR` | `[4]` | RC | `0x0` | Disparity error detected (read clears) |
| `RESERVED` | `[31:5]` | R | `0x0` | Reserved - read as 0 |

---
### `FPGA_VCO_TUNE` — Address: `0x0010`
**Reset value:** `0x00000000`

VCO control voltage for HMC733 LO

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VTUNE_DAC` | `[11:0]` | RW | `0x800` | 12-bit VTUNE DAC value (0-4095) for LO frequency |
| `VTUNE_EN` | `[12]` | RW | `0x0` | Enable VTUNE DAC output to VCO |
| `VCO_LOCKED` | `[16]` | R | `0x0` | VCO lock indicator readback |
| `FREQ_TARGET` | `[31:17]` | R | `0x0` | Target frequency in GHz * 100 (e.g., 7.5GHz = 750) |

---
### `FPGA_RF_POWER` — Address: `0x0014`
**Reset value:** `0x00000000`

RF output power and gain control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `DAC_GAIN` | `[7:0]` | RW | `0x00` | DAC full-scale gain adjustment (dBFS) |
| `PA_ATTEN` | `[15:8]` | RW | `0x00` | PA attenuation (0-255 steps, ~0.25dB/step) |
| `RF_OUTPUT_EN` | `[24]` | RW | `0x0` | Enable RF output to PA (must be last) |
| `EMERGENCY_SHDN` | `[31]` | RW | `0x0` | Emergency shutdown - immediately disables RF output |

---
### `DAC_SPI_CFG_REG` — Address: `0x0100`
**Reset value:** `0x00000018`

AD9144 SPI configuration register (mapped via FPGA bridge)

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `SOFT_RESET` | `[0]` | RW | `0x0` | DAC soft reset |
| `CLK_EN` | `[1]` | RW | `0x0` | Enable DAC clock inputs |
| `DAC_PWR_DWN` | `[2]` | RW | `0x0` | DAC power down (1=power down) |
| ` interpolate` | `[4:3]` | RW | `0x2` | Interpolation mode: 00=1x, 01=2x, 10=4x, 11=8x |
| `TX_EN` | `[5]` | RW | `0x0` | Enable TX output drivers |
| `RESERVED` | `[31:6]` | R | `0x0` | Reserved - read as 0 |

---
### `DAC_JESD_CFG_REG` — Address: `0x0104`
**Reset value:** `0x00000000`

AD9144 JESD204B configuration

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `JESD_EN` | `[0]` | RW | `0x0` | Enable JESD204B interface |
| `LANES_EN` | `[4:1]` | RW | `0x0` | Enable lanes: bit0=lane0, bit1=lane1 |
| `SUBCLASSV` | `[6:5]` | RW | `0x1` | JESD subclass: 01=Subclass 1 |
| `SCR_EN` | `[7]` | RW | `0x1` | Enable scrambler |
| `RESERVED` | `[31:8]` | R | `0x0` | Reserved - read as 0 |

---
### `DAC_TEST_REG` — Address: `0x0108`
**Reset value:** `0x00000000`

AD9144 test pattern generator

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `TEST_MODE_EN` | `[0]` | RW | `0x0` | Enable test pattern output |
| `PAT_SEL` | `[3:1]` | RW | `0x0` | Pattern: 000=ramp, 001=PN9, 010=PN23, 011=custom |
| `PAT_DATA` | `[31:4]` | RW | `0x0` | Custom pattern data (16 LSBs used) |

---
### `VCO_SPI_CFG_REG` — Address: `0x0200`
**Reset value:** `0x00000800`

HMC733 VCO SPI configuration register

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `VCO_EN` | `[0]` | RW | `0x0` | VCO core enable (must be 1 for operation) |
| `MUX_OUT` | `[3:1]` | RW | `0x0` | MUX output select: 000=RFOUT, 001=div/2, 111=lock detect |
| `RF_DIV` | `[6:4]` | RW | `0x1` | RF divider: 000=div1, 001=div2, 010=div4, 011=div8 |
| `LD_SEL` | `[8]` | RW | `0x0` | Lock detect mode: 0=highZ, 1=push-pull |
| `RESERVED` | `[31:9]` | R | `0x0` | Reserved - read as 0 |

---
### `VCO_FREQ_REG` — Address: `0x0204`
**Reset value:** `0x00000000`

HMC733 VCO frequency tuning control

| Field | Bits | Access | Reset | Description |
|-------|------|--------|-------|-------------|
| `BAND_SEL` | `[3:0]` | RW | `0x0` | VCO band select (0-15) |
| `VTUNE` | `[15:4]` | RW | `0x800` | VTUNE DAC value (12-bit, center=2048) |
| `FREQ_LOCK` | `[16]` | R | `0x0` | Frequency locked readback |
| `RESERVED` | `[31:17]` | R | `0x0` | Reserved - read as 0 |
