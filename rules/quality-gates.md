# Quality Gates

## When to Peer Review

| Deliverable | Required? | Agents to Use |
|------------|:---------:|--------------|
| Architecture plan (before customer presentation) | **Yes** | All 4 specialists |
| Security design involving PII | **Yes** | Security + Data Architect |
| Production notebook code | **Yes** | Data Architect + SQL Performance + Platform |
| DAX measures (business-critical) | Recommended | SQL Performance + Data Architect |
| Pipeline design | Recommended | Platform + Data Architect |
| Documentation / runbook | Optional | Data Architect |

## Validation Checklist Before Delivery

### Before Customer Presentation
- [ ] Peer review completed and findings addressed
- [ ] No real customer names in documents (use `[Customer]` placeholder)
- [ ] PII risk section included with mitigation options
- [ ] Effort estimates reviewed and realistic
- [ ] All open questions documented with impact assessment
- [ ] Mermaid diagrams render correctly in GitHub

### Before Code Deployment
- [ ] All tests pass (local + integration)
- [ ] Data profiling completed on real data
- [ ] Null conventions documented and implemented
- [ ] PII columns identified and protection configured
- [ ] Error handling in place for all pipeline stages
- [ ] Idempotent — safe to re-run without duplicating data
- [ ] Commit message describes the "why"

### Before Handoff
- [ ] Architecture documentation up to date
- [ ] Data dictionary complete (source -> Bronze -> Silver -> Gold)
- [ ] Pipeline runbook written (how to operate, monitor, re-run)
- [ ] Semantic model documented (measures, relationships, RLS)
- [ ] Known issues and limitations documented
- [ ] Customer has been trained on operations

## Definition of Done

A task is "done" when:
1. Code is written and tested
2. Tests pass (automated + manual verification)
3. Documentation is updated
4. Peer review findings addressed (if applicable)
5. Changes committed with descriptive message
6. User has approved the result
