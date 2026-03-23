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

## Mitigation Options Template

Present these to the customer for sign-off:

- **Option A: Full OLS + RLS** — All PII columns hidden from non-authorized roles. Requires OLS configuration per table. Most secure.
- **Option B: Separate PII workspace** — PII-containing tables in a restricted workspace. Business users access only Gold layer with PII removed. Moderate complexity.
- **Option C: Accepted risk with audit** — Document the risk, implement audit logging, defer masking to Phase 2. Fastest but least secure.
