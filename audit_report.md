# Red-Team Audit Report

- **Phase:** P1
- **Overall pass:** FAIL
- **Confidence:** 0.30
- **Hallucinations:** 0
- **Unresolved citations:** 0
- **Cascade errors:** 0

## Issues

| Severity | Category | Location | Detail | Suggested fix |
|---|---|---|---|---|
| critical | hallucinated_part | component_recommendations/Mini-Circuits BFHK-5001+ | Part `Mini-Circuits BFHK-5001+` was not found on DigiKey, Mouser, or in the local component seed — the LLM may have invented it. | Replace with a verifiable active-production part from data/sample_components.json or a real distributor MPN. |
| critical | hallucinated_part | component_recommendations/Pi attenuator 3 dB | Part `Pi attenuator 3 dB` was not found on DigiKey, Mouser, or in the local component seed — the LLM may have invented it. | Replace with a verifiable active-production part from data/sample_components.json or a real distributor MPN. |
| medium | datasheet_url | component_recommendations/Mini-Circuits BFHK-5001+ | Component `Mini-Circuits BFHK-5001+` has no `datasheet_url` field. | Populate `datasheet_url` with the manufacturer's product page. |
| medium | datasheet_url | component_recommendations/Pi attenuator 3 dB | Component `Pi attenuator 3 dB` has no `datasheet_url` field. | Populate `datasheet_url` with the manufacturer's product page. |
| high | not_from_candidate_pool | component_recommendations/Mini-Circuits BFHK-5001+ | Part `Mini-Circuits BFHK-5001+` was not in the `find_candidate_parts` shortlist for this turn — the LLM either skipped the retrieval step or picked an MPN outside the returned candidates. | Re-run P1 and ensure the LLM calls find_candidate_parts for every signal-chain stage, then selects only from the returned `candidates[].part_number` list. |
| high | not_from_candidate_pool | component_recommendations/Pi attenuator 3 dB | Part `Pi attenuator 3 dB` was not in the `find_candidate_parts` shortlist for this turn — the LLM either skipped the retrieval step or picked an MPN outside the returned candidates. | Re-run P1 and ensure the LLM calls find_candidate_parts for every signal-chain stage, then selects only from the returned `candidates[].part_number` list. |