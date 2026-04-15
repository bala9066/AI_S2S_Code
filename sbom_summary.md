# CycloneDX SBOM — iguyc

**Format:** CycloneDX 1.4 JSON
**Generated:** 2026-04-15 12:40 UTC
**Total Components:** 1

## Component Summary

### Hardware (1)

| Component | Vendor | Version | Description |
|-----------|--------|---------|-------------|
| Spec | Value | 1.0 |  |

## Usage

Import `sbom.json` into [Dependency-Track](https://dependencytrack.org/) or any CycloneDX-compatible tool for vulnerability scanning and license compliance.

```bash
# Validate with cyclonedx-cli
cyclonedx validate --input-file sbom.json

# Upload to Dependency-Track
curl -X PUT "https://your-dt-instance/api/v1/bom" \
  -H "X-API-Key: YOUR_KEY" \
  -F "autoCreate=true" \
  -F "projectName=iguyc" \
  -F "bom=@sbom.json"
```