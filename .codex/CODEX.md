# CODEX Configuration

This document defines the agent execution loop in one place.

## Start Sequence

1. Policy check: `.codex/AGENTS.md`
2. Role/permission check: `.codex/agents/team.md`
3. Confirm request scope and expected outputs.

## Standard Execution Loop

1. Confirm the goal and scope of the request.
2. Make safe, minimal changes.
3. Report results in the requested format.
4. Record blockers immediately in the handoff document.

## Detailed Operating Docs

- Roles/permissions: `.codex/agents/team.md`
- Handoff: `.codex/agents/handoff.md`
- Execution process / escalation: `.codex/agents/runbook.md`
