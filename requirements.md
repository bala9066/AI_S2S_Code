# Hardware Requirements
## sample rf

## 1. Project Summary

5-18 GHz wideband RF receiver for 5G/6G telecom applications with baseband digital output. The design provides 10-15 dBm output power with +20 to +30 dBm OIP3 linearity, noise figure better than 10 dB, and -60 to -50 dBm sensitivity. Operating from 5-12V supply in industrial temperature range (-40 to +85°C) with moderate size constraints (<200g).

## 2. Design Parameters

| Parameter | Value |
|---|---|
| Center Freq Mhz | 11500 |
| Bandwidth Mhz | 13000 |
| Min Input Power Dbm | -60 |
| Max Input Power Dbm | -50 |
| Output Power Dbm | 10 to 15 |
| Noise Figure Db | <10 |
| Oip3 Dbm | +20 to +30 |
| Group Delay Variation Ns | 10 to 50 |
| Supply Voltage V | 5 to 12 |
| Operating Temp C | -40 to +85 |
| Max Weight G | <200 |
| Input Frequency Ghz | 5 to 18 |
| Output Interface | Baseband digital (IQ) |

## 3. Requirements

### 3.1 Functional Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-001 | RF Input Frequency Range | Receiver shall accept RF input signals from 5 GHz to 18 GHz. | Must have | test | None | None |
| REQ-HW-002 | Output Interface Format | Receiver shall provide baseband digital output (IQ data) for signal processing. | Must have | test | None | None |
| REQ-HW-012 | Gain Flatness | Receiver gain variation shall be within ±3 dB across 5-18 GHz operating band. | Should have | test | None | None |

### 3.2 Performance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-003 | Noise Figure | Receiver system noise figure shall be less than 10 dB across 5-18 GHz band. | Must have | test | None | None |
| REQ-HW-004 | Input Sensitivity | Receiver shall detect signals at minimum input power of -60 to -50 dBm. | Must have | test | None | None |
| REQ-HW-005 | Output Power Level | Receiver shall provide 10-15 dBm output power at baseband interface. | Must have | test | None | None |
| REQ-HW-006 | Linearity (OIP3) | Receiver output third-order intercept (OIP3) shall be +20 to +30 dBm. | Must have | test | None | None |
| REQ-HW-007 | Group Delay Variation | Receiver group delay variation shall be 10-50 ns across the 5-18 GHz band. | Should have | test | None | None |
| REQ-HW-011 | Input Return Loss | RF input port shall provide minimum 10 dB return loss across 5-18 GHz band. | Should have | test | None | None |

### 3.3 Interface Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-008 | Power Supply Input | Receiver shall operate from 5V to 12V DC power supply. | Must have | test | None | None |

### 3.4 Environmental Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-009 | Operating Temperature | Receiver shall meet all specifications over industrial temperature range of -40°C to +85°C. | Must have | test | None | None |

### 3.5 Constraint Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-010 | Weight Constraint | Total receiver module weight shall not exceed 200 grams. | Must have | inspection | None | None |

### 3.6 Compliance Requirements

| ID | Title | Description | Priority | Validation | Dependencies | Constraints |
|---|---|---|---|---|---|---|
| REQ-HW-013 | RoHS Compliance | All components shall be RoHS compliant. | Must have | inspection | None | None |
| REQ-HW-014 | REACH Compliance | All components shall meet REACH substance restrictions. | Must have | inspection | None | None |
