# Document Standards

## Company Name Placeholders

When creating deliverables (architecture plans, presentations, documentation):

| Entity | Placeholder | When to Use |
|--------|------------|-------------|
| Customer / Client | `[Customer]` | Always — never use real customer name in repo |
| Your consulting team | `[Consulting Team]` | Always — never use real company name |
| Third-party vendors | Use real name | OK if the vendor is publicly known (e.g., "Microsoft Fabric", "Paycom") |

**Why:** Deliverables may be stored in repos, shared, or reused. Customer names in templates leak confidential relationships.

## Document References

When referencing other documents in a deliverable:

1. **Use relative paths** — `See docs/04_architecture_plan.md` not absolute paths
2. **Reference by section** — "See Section 7.3 (Gold Write Strategy)" not just "see the plan"
3. **Include version** — "per Architecture Plan v1.1" when the document has versions
4. **Cross-reference findings** — "Addresses CR-B1 from peer review" to trace decisions

## Formatting Standards

- **Markdown** for all technical documentation
- **Tables** for structured comparisons (never inline lists for tabular data)
- **Mermaid diagrams** for architecture flows (renders in GitHub)
- **Code blocks** with language tags for all code snippets
- **Headings** follow a consistent hierarchy (H1 = doc title, H2 = sections, H3 = subsections)

## Dual Format Delivery

**ALWAYS** generate both formats for every deliverable:

| Format | Audience | Purpose |
|--------|----------|---------|
| `.md` (Markdown) | Engineers, GitHub reviewers | Version-controlled, diffable, renders in GitHub |
| `.docx` (Word) | Non-technical stakeholders, customers | Professional formatting, printable, email-ready |

**Rules:**
1. Regenerate `.docx` after ANY markdown update — never let them drift out of sync
2. Use `scripts/md_to_docx.js` (or equivalent) for automated conversion
3. Commit both formats together in the same commit
4. Mermaid diagrams in markdown should be replaced with rendered images in docx

## Version Control for Documents

- Major changes increment version: v1.0 -> v2.0
- Peer review fixes increment minor version: v1.0 -> v1.1
- Always note version and date at top of document
- Keep a brief changelog at bottom for major documents
