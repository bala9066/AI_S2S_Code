# CycloneDX SBOM — rx module

**Format:** CycloneDX 1.4 JSON
**Generated:** 2026-04-14 17:57 UTC
**Total Components:** 3

## Component Summary

### Hardware (3)

| Component | Vendor | Version | Description |
|-----------|--------|---------|-------------|
| SPI | DSA
        MCU --> | 1.0 | *GPIO* |
| Extracted | Unknown | 1.0 | from requirements document. |
| I2C | MCU
        MCU --> | 1.0 | *SPI/I2C* |

## Usage

Import `sbom.json` into [Dependency-Track](https://dependencytrack.org/) or any CycloneDX-compatible tool for vulnerability scanning and license compliance.

```bash
# Validate with cyclonedx-cli
cyclonedx validate --input-file sbom.json

# Upload to Dependency-Track
curl -X PUT "https://your-dt-instance/api/v1/bom" \
  -H "X-API-Key: YOUR_KEY" \
  -F "autoCreate=true" \
  -F "projectName=rx module" \
  -F "bom=@sbom.json"
```