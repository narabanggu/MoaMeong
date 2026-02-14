# PRD-001 / PRD-002 Pre-Development Meeting Log

## Meeting Metadata

- Date: 2026-02-14 (parallel kickoff executed)
- Format: one parallel kickoff (`common -> track A/B parallel -> integration`)
- Participants: 사용자, 리더멍, 브랜딩멍, 뷰티멍, 픽셀멍, 체크멍, 가드멍

## Common Alignment

- Common principle: user-facing copy in Korean, internal identifiers in English
- Technical boundary: single Flutter Web app + localStorage, no backend / DB / external integration
- Gate chain: 체크멍 -> 가드멍 -> 리더멍
- User approval condition: blockers = 0 per PRD and documentation consistency

## Track A (Branding): PRD-001 Consensus

- Tone axis: trust / empathy / clarity
- Emotional intensity: normal (exclude overstimulation, fear, overstatement)
- Sensitive language: move misunderstanding/overstatement/overly emotional framing to hold list
- Scope: alerts / guides / screen copy / button labels / status messages
- Deliverables: draft forbidden words, tone guardrails, base component rules

## Track B (Ideation): PRD-002 Candidate Evaluation

- Requirement met: 3 candidates selected
- Priority rule: value > difficulty > risk
- Candidate set:
  - C1: remaining-days / amount dashboard
  - C2: change/cancel guide hub
  - C3: weekly/monthly summary + alert preview flow
- MVP core screens: start with 3 screens (dashboard, alerts, guide)
- Storage policy: localStorage-first when no backend/DB, with separate key schema/version policy docs
- Design decision: keep `summary + urgency indicator + action guidance` as core to avoid Todo-only drift

## Integration Alignment

- Conflict resolution: use PRD-001 guide for branding/UX tone conflicts
- Shared blockers: exclude any feature requiring external integration
- Shared blockers: exclude login/auth/account/backend-dependent features
- Next actions:
  - Apply PRD-001 copy/component rules to PRD-002
  - Decompose PRD-002 candidate requirements into next PRD

## Action Owners / Due Dates

- 브랜딩멍: draft PRD-001 tone/copy guide (24h)
- 픽셀멍: draft PRD-002 MVP screen structure (48h)
- 뷰티멍: draft C1~C3 readability standard (48h)
- 체크멍: apply PRD-001/002 gate checklist immediately
- 가드멍: draft risk classification table (24h)
- 리더멍: consolidate and request user approval

## Post-meeting Carryover Rules

- If blockers remain unresolved, pause start of the next PRD step.
- Move retrospective follow-up items immediately to `.codex/TODO/backlog.md` under `pre-development carryover`.
- Apply these items in the approval loop before starting next feature.
