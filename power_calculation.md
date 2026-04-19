# Power Calculation
## hm

**Date:** 19-04-2026

> All values in Watts (W). TYP = typical operating power, MAX = worst-case (130% of TYP).
> Rail assignment is based on component operating voltage from BOM.

## Power Budget — 5 V & 3.3 V Rails

| SI | Description | Part No | Qty | 5V TYP (W) | 5V MAX (W) | 3.3V TYP (W) | 3.3V MAX (W) | Total TYP (W) | Total MAX (W) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | RF limiter / input protection — protects LNA from +20 dBm overload and ESD. 120 dBm dynamic range, low insertion loss. | SKY16406-321LF | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 2 | LNA — first active stage in the signal chain. Sets system noise figure to < 2 dB. | PMA3-83LN+ | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 3 | RF SPDT switches for sub-band filter bank — routes signal through the appropriate bandpass filter for the selected 300–1000 MHz sub-band. | HMC253LC4 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 4 | 1st mixer — converts selected UHF sub-band (300–1000 MHz) down to 70 MHz IF using high-side LO injection. | ADE-25MH+ | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 5 | IF bandpass filter — 70 MHz center frequency, 10 MHz bandwidth crystal or LC filter for channel selection and image rejection. | BFCG-70A+ | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 6 | IF VGA with AGC — maintains constant IF output level despite varying input signal levels. Provides ~40 dB gain control range. | ADL5330 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 7 | IQ demodulator — splits the 70 MHz IF into quadrature baseband I and Q channels for coherent pulse-Doppler processing. | LTC5596 | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 8 | PLL synthesizer — generates tunable LO (230–930 MHz) for 1st mixer, plus quadrature LO for IQ demod. Phase noise -100 dBc/Hz at 10 kHz offset. | ADF4153A | 1 | — | — | 0.165 | 0.214 | 0.165 | 0.214 |
| 9 | VCO — voltage-controlled oscillator for the PLL loop. Covers 370–1070 MHz for high-side LO injection to 300–1000 MHz RF. | ROS-1080+ | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 10 | LO buffer amplifier — provides +7 dBm drive to the mixer LO port and isolation between LO chain and mixer. | GVA-84+ | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 11 | Baseband low-pass filter — 5 MHz cutoff for I and Q channels. Active filter with Butterworth/Bessel response for strict group delay variation < 1 ns. | LTC1569-7 | 1 | — | — | 0.99 | 1.287 | 0.99 | 1.287 |
| 12 | DC-DC converter — steps down +28V to +5V for powering RF chain, synthesizer, and baseband. | LTM8074 | 1 | 6.0 | 7.8 | — | — | 6.0 | 7.8 |
| 13 | Low-noise LDO — generates clean +3.3V rail from +5V for PLL synthesizer, VCO tuning, and control logic. | LT3045 | 1 | 2.5 | 3.25 | — | — | 2.5 | 3.25 |
| | **TOTALS** | |  | **8.5** | **11.05** | **6.765** | **8.792** | **15.265** | **19.842** |

---

## Power Summary

| Rail | Typical Power (W) | Max Power (W) |
|------|-------------------|---------------|
| 5V | 8.5 | 11.05 |
| 3.3V | 6.765 | 8.792 |
| 2.5V | 0.0 | 0.0 |
| 1.8V | 0.0 | 0.0 |
| **TOTAL** | **15.265** | **19.842** |

> Note: Power values are estimated from component datasheets and design parameters.
> Actual measurements should be taken during hardware bring-up and updated in this table.