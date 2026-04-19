---
name: peer-reviewer
description: Multi-agent peer review orchestrator for data platform deliverables. Use this skill to run 4–5 specialist agents in parallel reviewing the same document, then consolidate findings into a single actionable report. Trigger when an architecture plan, notebook, SQL code, or security design needs high-quality review before customer delivery.
version: 1.0.0
author: omaperoha
---

# Peer Reviewer — Multi-Agent Review Orchestrator

## The 5-Specialist Team

| Agent | Skill | Focus |
|-------|-------|-------|
| Senior Data Architect | `data-architect` | Model correctness, completeness, performance |
| IT Security Specialist | `security-reviewer` | PII, access control, compliance |
| Platform Specialist | project-specific | Platform feasibility, limitations, cost |
| SQL Performance Specialist | `sql-performance` (agent) | Query correctness, performance, type safety |
| BI Engineer | `bi-engineer` (agent) | Reporting usability, DAX, Copilot readiness |

## How to Run a Peer Review

### Step 1: Prepare
- Have the document ready (architecture plan, notebook, SQL, etc.)
- Identify document type → select which specialists are relevant

### Step 2: Launch Agents in Parallel

```
Launch 4–5 agents simultaneously using the Agent tool:

Agent 1 (Senior Data Architect):
  "Review [document] as a Senior Data Architect. Focus on data model correctness,
   completeness, performance at scale, and Medallion architecture best practices.
   Search the web for latest best practices before reviewing.
   Rate each finding Critical/Important/Nice-to-Have with specific fixes."

Agent 2 (IT Security Specialist):
  "Review [document] as an IT Security & Compliance Specialist. Focus on PII
   exposure, access control gaps, data flow security, and compliance risks.
   Search the web for latest security best practices before reviewing.
   Rate each finding with specific mitigation steps."

Agent 3 (Platform Specialist):
  "Review [document] as a [Platform] Specialist. Focus on platform feasibility,
   known limitations, capacity implications, and cost optimization.
   Rate each finding with platform-specific alternatives."

Agent 4 (SQL Performance Specialist):
  "Review [document] as a SQL & Query Performance Specialist. Focus on query
   correctness, NULL handling, type safety, and performance anti-patterns.
   Rate each finding with specific code fixes."

Agent 5 (BI Engineer) — optional, include for Gold/semantic model reviews:
  "Review [document] as a BI Engineer. Focus on reporting usability, DAX correctness,
   Copilot readiness, and regulatory report mappings.
   Rate each finding with specific fixes."
```

### Step 3: Consolidate Findings

1. **De-duplicate** — Multiple agents often flag the same issue. Keep the most detailed version.
2. **Track convergence** — Note when 2+ agents flag the same issue (3+ = highest confidence).
3. **Sort by severity** — Critical → Important → Nice-to-Have.
4. **Add action plan** — For each Critical finding, specify who fixes it and when.

## Consolidation Report Format

```markdown
# Peer Review — Consolidated Findings

> **Reviewers:** [list agents used]
> **Document reviewed:** [document name and version]
> **Date:** [date]

## Summary

| Severity | Raw Count | De-duplicated | Applied |
|----------|:---------:|:------------:|:-------:|
| Critical | X | Y | Yes/No |
| Important | X | Y | Yes/No |
| Nice-to-Have | X | Y | Yes/No |

## Critical Findings

### CR-1 | [Title]
**Flagged by:** [which agent(s)]
**Section:** [document section]
**Issue:** [description]
**Fix:** [specific, actionable fix]

## Important Findings
...

## Nice-to-Have
...
```

## When to Use

- Architecture plans before customer presentation
- Notebook code before production deployment
- Security-sensitive designs involving PII or compliance
- Complex SQL/DAX with business-critical calculations
- Any deliverable where quality > speed

## Agent Selection by Document Type

| Document Type | Recommended Agents |
|--------------|-------------------|
| Star schema / Gold layer | All 5 |
| Architecture plan | All 5 |
| PySpark notebook | Architect + SQL + Platform |
| Security design | Security + Architect |
| DAX measures | SQL + BI Engineer + Architect |
| Pipeline design | Platform + Architect |
| Data validation | Architect + SQL |

## Key Lessons Learned
- **Always ask agents to search the web** for latest best practices before reviewing
- **3+ agent convergence = highest confidence** — track it explicitly
- **BI Engineer catches what others miss**: regulatory mappings, date dimension gaps, Copilot synonyms
- **Expect 40–70% de-duplication** across 5 agents
- **Peer review changes estimates** — budget for a +15–40% effort adjustment after findings are applied
