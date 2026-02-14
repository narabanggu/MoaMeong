# Agent Execution Runbook

## Purpose

- Execute feature-level work from PRDs consistently and quickly.
- Maintain quality, risk controls, and documentation alignment.
- Feed completion learnings into the next feature.

## Composition

- Top owner: User
- Execution lead: 리더멍
- Active members: 브랜딩멍, 리더멍, 뷰티멍, 픽셀멍, 체크멍, 가드멍

## PRD-Driven Feature Flow

### 1) Pre-Development Team Meeting
- Trigger: run immediately when PRD/spec changes are received.
- Output: scope, completion criteria, approval conditions, expected blockers.
- Actions: confirm role ownership, align decision priority, branch user-approval required items.
- PRD-001/PRD-002 are handled with a parallel meeting flow.
  1) Common kickoff (all) → 2) parallel track alignment (branding / ideation) → 3) integration alignment
  - Integration log: `.codex/PRD/PRD-001-002-kickoff-meeting-log.md`

### 2) Execution
- 리더멍 manages scope, milestones, and blocker status.
- Each member executes with role-specific criteria and shares changes immediately.
- Stop conditions: `technical boundary breach`, `verification failure`, `risk escalation`.

## Parallel Meeting Template

- Common kickoff: priority, approval chain, top 3 blockers, PRD-001/PRD-002 dependency alignment.
- Track A (Branding): tone/copy/component standards, forbidden/sensitive words, review rounds.
- Track B (Ideation): evaluate 3+ candidates, select 3-5 core screens, re-check MVP scope.
- Integration: only split duplicate/conflict items, then finalize backlog carryover items.

### 3) Retrospective Meeting
- Validate artifact consistency and evidence.
- Reflect issues, mistakes, gaps, and prevention actions.
- Record follow-up items in `.codex/TODO/backlog.md`.
- Reflect these items in the approval loop before starting the next feature.

## Execution Gates

- Finalization: user approval and zero blockers.
- Documentation consistency: `.codex/PRD/`, `.codex/TODO/backlog.md`, `.codex/changelog/CHANGELOG.md`
- Core operating rule: Korean user copy, English internal identifiers, technical boundary `Flutter Web + localStorage`, zero backend/DB/external integration
