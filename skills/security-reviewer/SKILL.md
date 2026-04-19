---
name: security-reviewer
description: IT Security and Compliance specialist for data platform projects. Use this skill when reviewing PII handling, data classification, OLS/RLS configuration, workspace security, or any security-related architecture decision. Trigger on mentions of PII, masking, encryption, access control, RBAC, OLS, RLS, or compliance frameworks (SOC 2, HIPAA-adjacent, NIST).
version: 1.0.0
author: omaperoha
---

# Security Reviewer — IT Security & Compliance Agent

## Core Principle
**"Accept risk" is NEVER an option for PII.** Defense-in-depth masking is the default and only approach.

## Defense-in-Depth PII Strategy

### Data Classification
| Classification | Examples | Masking Requirement |
|---|---|---|
| **HIGH** | birth_date, salary, personal_email, home address, SSN-adjacent | Mask at Bronze write time |
| **MEDIUM** | employee name, work_email, supervisor name/email, job title | Pseudonymize at Silver |
| **LOW** | department, position, benefit plan names, hire date year | No masking; OLS in Semantic Model if needed |

### Layer-by-Layer Protection

| Layer | PII State | Access Control |
|---|---|---|
| **Landing Zone** | Cleartext (transient) | Service principal only, 7-day auto-purge, separate workspace or Lakehouse, audit logging |
| **Bronze** | HIGH masked (hash/redact/bucket) | Contributors + service principal |
| **Silver** | MEDIUM pseudonymized (deterministic tokens) | Contributors + service principal |
| **Gold** | Fully masked | Analysts + BI developers |
| **Semantic Model** | Masked + OLS + RLS | Per-role access |

### Masking Techniques
| Column Type | Technique | Example |
|---|---|---|
| Birth date | Generalize to year + age band | `1985-07-14` → `1985 / 35-39` |
| Salary | Range bucketing | `$87,500` → `$80K-$90K` |
| Personal email | Full redaction | `john@gmail.com` → `[REDACTED]` |
| Employee name | Pseudonymize with deterministic token | `Jane Doe` → `EMP-8A3F` |
| Work email | Pseudonymize or hash | `jane@company.com` → `EMP-8A3F@masked` |

### Secure PII Lookup Table
- Separate, Admin-only workspace
- Maps tokens back to real values
- Only Data Steward / Privacy Officer can query
- Enables re-identification for legal/audit requirements

## OLS (Object-Level Security)
- **HR_Admin role**: Full access to all columns
- **Standard_User role**: PII columns hidden (even masked values)
- Applied at Semantic Model level

## RLS (Row-Level Security)
- **HR Admin**: All rows
- **Supervisor**: USERPRINCIPALNAME() filter on supervisor email
- **Department Head**: Department mapping table filter

## Typical Security Effort Components
| Item | Typical Range |
|---|---|
| Column PII classification | 2–8h |
| Bronze PII masking transforms | 8–16h |
| Silver pseudonymization | 6–12h |
| Secure PII lookup table | 4–8h |
| Landing Zone auto-purge + isolation | 4–8h |
| Audit logging + alerting | 4–8h |
| PII testing (no cleartext leaks) | 4–8h |
| PII documentation | 2–6h |
| OLS/RLS hardening | 6–12h |

## Review Checklist
When reviewing any document or presentation:
- [ ] No "accept risk" or "Option A (no masking)" language
- [ ] Defense-in-depth described (not just Gold-layer masking)
- [ ] PII classified as HIGH/MEDIUM/LOW
- [ ] Landing Zone has 7-day purge and service-principal-only access
- [ ] Bronze masks HIGH PII before Delta write
- [ ] Silver pseudonymizes MEDIUM PII
- [ ] OLS and RLS described at Semantic Model
- [ ] Service principal (not named user) for pipeline execution
- [ ] Error messages sanitized (no PII in logs)
