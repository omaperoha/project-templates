# Peer Review Orchestrator

## Overview

This document describes how to run a multi-agent peer review using Claude Code's Agent tool. The pattern uses 5 specialized agents reviewing the same document in parallel, then consolidates findings into a single actionable report.

## The 5-Specialist Pattern

| Agent | Role File | Focus |
|-------|-----------|-------|
| Senior Data Architect | `data-architect.md` | Model correctness, completeness, performance |
| IT Security Specialist | `security-reviewer.md` | PII, access control, compliance |
| Platform Specialist | `fabric-specialist.md` | Platform feasibility, limitations, cost |
| SQL Performance Specialist | `sql-performance.md` | Query correctness, performance, type safety |
| BI Engineer | `bi-engineer.md` | Reporting usability, DAX, Copilot readiness, regulatory reports |

## How to Run a Peer Review

### Step 1: Prepare the Document
- Have the document to review ready (architecture plan, notebook, SQL code, etc.)
- Identify the document type to determine which agents are relevant

### Step 2: Launch Agents in Parallel

Use Claude Code's Agent tool to launch all 4 specialists simultaneously:

```
Launch 4 agents in parallel:

Agent 1 (Senior Data Architect):
  "Review [document] as a Senior Data Architect. Focus on data model correctness,
   completeness, performance at scale, and Medallion architecture best practices.
   Rate each finding as Critical/Important/Nice-to-Have with specific fixes."

Agent 2 (IT Security Specialist):
  "Review [document] as an IT Security & Compliance Specialist. Focus on PII
   exposure, access control gaps, data flow security, and compliance risks.
   Rate each finding with specific mitigation steps."

Agent 3 (Platform Specialist):
  "Review [document] as a [Platform] Specialist. Focus on platform feasibility,
   known limitations, capacity implications, and cost optimization.
   Rate each finding with platform-specific alternatives."

Agent 4 (SQL Performance Specialist):
  "Review [document] as a SQL & Query Performance Specialist. Focus on query
   correctness, NULL handling, type safety, and performance anti-patterns.
   Rate each finding with specific code fixes."
```

### Step 3: Consolidate Findings

After all 4 agents complete, consolidate into a single report:

1. **De-duplicate** — Multiple agents often flag the same issue. Keep the most detailed version.
2. **Cross-reference** — Note when 2+ agents flag the same issue (increases confidence).
3. **Sort by severity** — Critical > Important > Nice-to-Have.
4. **Add action plan** — For each Critical finding, specify who fixes it and when.

### Consolidation Report Format

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

...

## Important Findings
...

## Nice-to-Have
...
```

## When to Use This Pattern

- **Architecture plans** before customer presentation
- **Notebook code** before production deployment
- **Security-sensitive designs** involving PII or compliance requirements
- **Complex SQL/DAX** with business-critical calculations
- **Any deliverable** where quality is more important than speed

## Customizing the Team

Not every review needs all 5 specialists. Choose based on the document:

| Document Type | Recommended Agents |
|--------------|-------------------|
| Star schema / Gold layer design | All 5 (proven effective: 105 raw findings, 60 de-duplicated) |
| Architecture plan | All 5 |
| PySpark notebook | Data Architect + SQL Performance + Platform |
| Security design | Security + Data Architect |
| DAX measures | SQL Performance + BI Engineer + Data Architect |
| Semantic model design | BI Engineer + Platform + SQL Performance |
| Pipeline design | Platform + Data Architect |
| Data validation | Data Architect + SQL Performance |
| Reporting requirements | BI Engineer + Data Architect |

### Lessons Learned (from Fabric-Modeling_Layer-Bank, 2026-03-27)

- **All 5 agents should search the web for current best practices** before reviewing. Add "Before reviewing, search the web for the latest [topic] best practices as of [current date]" to each agent's prompt.
- **3+ agent convergence = highest confidence.** When 3+ agents independently flag the same issue, it is almost certainly a real problem. Track convergence in the consolidated report.
- **BI Engineer catches what others miss:** regulatory report mappings (NCUA 5300), missing origination facts, date dimension gaps, Copilot synonym requirements. Always include this agent for financial services projects.
- **Expect 40-70% de-duplication** across 5 agents. Raw finding count will be high; consolidated count is what matters.
- **Effort impact is significant:** the Fabric-Modeling_Layer-Bank peer review increased the effort estimate from 236h to 326-360h (+38-52%). Budget for peer review to change the plan.
