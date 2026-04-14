# CycloneDX SBOM — TX Module

**Format:** CycloneDX 1.4 JSON
**Generated:** 2026-04-14 14:20 UTC
**Total Components:** 11

## Component Summary

### Hardware (11)

| Component | Vendor | Version | Description |
|-----------|--------|---------|-------------|
| 11500 | Unknown | 1.0 | () |
| Extracted | Unknown | 1.0 | from requirements document. |
| SMP | Unknown | 1.0 | () |
| 200 | ## Requirements (23 captured | 1.0 | ) |
| REQ-HW-001 | Operating Frequency Range | 1.0 | *Must have* |
| REQ-HW-002 | Output Power | 1.0 | *Must have* |
| REQ-HW-003 | Analog Modulation Support | 1.0 | *Must have* |
| REQ-HW-004 | Power Efficiency | 1.0 | *Must have* |
| REQ-HW-005 | Gain | 1.0 | *Must have* |
| REQ-HW-006 | Output Return Loss | 1.0 | *Must have* |
| REQ-HW-007 | RF Input Interface | 1.0 | *Must have* |

## Usage

Import `sbom.json` into [Dependency-Track](https://dependencytrack.org/) or any CycloneDX-compatible tool for vulnerability scanning and license compliance.

```bash
# Validate with cyclonedx-cli
cyclonedx validate --input-file sbom.json

# Upload to Dependency-Track
curl -X PUT "https://your-dt-instance/api/v1/bom" \
  -H "X-API-Key: YOUR_KEY" \
  -F "autoCreate=true" \
  -F "projectName=TX Module" \
  -F "bom=@sbom.json"
```