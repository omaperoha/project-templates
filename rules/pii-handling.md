# PII Handling Rules

## Classification

| Category | Examples | Minimum Protection |
|----------|----------|-------------------|
| **High PII** | SSN, bank account, salary, medical records, birth date | Column-level encryption + OLS + audit logging |
| **Medium PII** | Full name, email, phone, home address, ZIP code | OLS masking + RLS by role |
| **Low PII** | Department, job title, hire date, work location | RLS by role |
| **Non-PII** | Aggregated metrics, anonymized codes | Standard access control |

## Rules

1. **Inventory first.** Before development begins, create a complete PII inventory listing every column that contains personal data, its classification, and the protection mechanism.

2. **Customer sign-off required.** PII exposure risk must be documented and presented to the customer with mitigation options. Development of PII-containing features is blocked until sign-off.

3. **Synthetic data only.** All development, testing, and documentation must use synthetic or anonymized data. Never use real PII in code, notebooks, commit messages, or documentation.

4. **Masking in BI layer.** Any field containing personal data must be masked by default in reports and dashboards. Use platform-specific mechanisms:
   - **Power BI:** Object-Level Security (OLS) to hide columns from unauthorized roles
   - **Looker:** `_user_attributes['can_see_pii']` conditional rendering
   - **Tableau:** User filters or row-level security

5. **Encryption at rest.** High PII columns should be encrypted at the storage layer when the platform supports it.

6. **Audit trail.** Access to High PII must be logged. Design the data model to support audit queries.

7. **Least privilege.** Grant the minimum access needed. Default = no PII access. PII access is opt-in, role-based, and audited.

## Defense-in-Depth Pattern (Recommended)

PII protection must be layered across the entire pipeline — not deferred to a single layer:

| Layer | HIGH PII Action | MEDIUM PII Action |
|-------|----------------|-------------------|
| **Bronze** | Mask at write time (SHA-256 hash or redact) | Pass through |
| **Silver** | Already masked | Pseudonymize (consistent hash for joins) |
| **Gold** | Fully masked — no raw PII reaches consumption | Fully masked |
| **Semantic Model** | OLS hides columns from unauthorized roles | OLS hides columns |
| **Row-Level** | RLS filters rows by user/role | RLS filters rows |

**"Accept risk" is NEVER an option.** Defense-in-depth masking is the default. Every project involving PII must implement protections at every layer, not defer to a single point of enforcement.

## Mitigation Options Template

Present these to the customer for sign-off:

- **Option A: Full Defense-in-Depth** — PII masked at every layer (Bronze through Semantic Model). OLS + RLS at consumption. Most secure. **Recommended.**
- **Option B: Separate PII workspace** — PII-containing tables in a restricted workspace. Business users access only Gold layer with PII removed. Moderate complexity.
- ~~**Option C: Accepted risk**~~ — **Not offered.** Risk acceptance for PII is not a valid mitigation strategy. If the customer requests it, document the refusal and explain regulatory exposure.
