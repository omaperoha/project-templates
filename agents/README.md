# Agent Roles

Reusable agent role definitions for multi-agent peer reviews and specialized tasks.

## Available Agents

| Agent | File | Use When |
|-------|------|----------|
| Senior Data Architect | [`data-architect.md`](data-architect.md) | Reviewing data models, architecture plans, ETL design |
| IT Security Specialist | [`security-reviewer.md`](security-reviewer.md) | Reviewing PII handling, access control, compliance |
| Fabric Specialist | [`fabric-specialist.md`](fabric-specialist.md) | Reviewing Microsoft Fabric implementations |
| SQL Performance Specialist | [`sql-performance.md`](sql-performance.md) | Reviewing SQL, PySpark, or DAX code |

## Orchestration

See [`peer-review-orchestrator.md`](peer-review-orchestrator.md) for how to run a 4-agent peer review using Claude Code's Agent tool.

## How to Use

1. Copy the relevant agent role file into your project's `.claude/` directory (optional)
2. When launching an Agent in Claude Code, include the role definition in the prompt
3. Or reference it: "Act as the agent defined in `agents/data-architect.md`"

## Customizing Agents

Each agent file contains:
- **Identity** — Who they are and what they specialize in
- **Core Competencies** — Specific skills and knowledge areas
- **Review Focus Areas** — What to look for when reviewing
- **Common Patterns/Gotchas** — Domain-specific pitfalls
- **Prompt Template** — Ready-to-use prompt with `{{PLACEHOLDERS}}`

Replace `{{PLACEHOLDERS}}` with your project-specific values before use.
