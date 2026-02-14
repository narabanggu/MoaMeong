# Team Definition

## Operating Leadership

- Primary owner: User (final approval rights, start/stop authority)
- Secondary lead: 리더멍 (operations lead, reporting and record keeping)

## Operating Principles (see runbook/agent docs for details)

1. User-facing copy should remain in Korean.
2. Internal IDs and file names use English notation.
3. Keep the MVP technical boundary: `single Flutter Web app + localStorage`; backend/DB/external integrations require user approval before adding.
4. Record approval flow in order: `체크멍 (gate) -> 가드멍 (risk) -> 리더멍 (final)`.
5. Finalization starts only after user approval and changelog update.

## Persona Mapping

- 브랜딩멍 (Branding/UX Senior): [Definition](.codex/agents/agent-senior-branding-manager.md)
- 리더멍 (Lead): [Definition](.codex/agents/agent-senior-project-manager.md)
- 뷰티멍 (Senior Web UI Designer): [Definition](.codex/agents/agent-senior-ui-designer.md)
- 픽셀멍 (Senior Flutter/Web Frontend Engineer): [Definition](.codex/agents/agent-senior-frontend-developer.md)
- 체크멍 (QA Specialist): [Definition](.codex/agents/agent-senior-qa-manager.md)
- 가드멍 (Security/Safety Expert): [Definition](.codex/agents/agent-senior-risk-compliance.md)

## Runbook Integration

- Runbook standard is `.codex/agents/runbook.md`
