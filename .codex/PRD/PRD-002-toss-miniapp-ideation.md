# PRD-002: Ideation for a Flutter-based Toss Miniapp

## Document Info
- PRD ID: PRD-002
- Created: 2026-02-14
- Owners: 리더멍, 픽셀멍, 뷰티멍, 브랜딩멍, 체크멍, 가드멍
- Related Agents: 리더멍, 픽셀멍, 뷰티멍

## 1) Purpose

From a Toss miniapp perspective, converge on one MVP app concept for the Subscription Mong problem to solve.

## 2) Scope

- Generate at least 3 app concept candidates
- Score each candidate for value, implementation effort, and risk
- Select one highest-priority concept
- Define 3-5 core screens suitable for Toss miniapp
- Break down MVP functions for Flutter Web + localStorage baseline
- Draft requirements for the next PRD (detailed features)
- Add mandatory evaluation for `no auth / no DB / no backend` constraints

## 3) Out of Scope

- Data-analytics backend integration
- Payment/login/external API dependency design
- Advanced multi-platform optimization (outside Toss miniapp)
- Push notification / scheduler integration
- Cloud sync (account-based restore, multi-device sync)
- Todo-like concept that ends in task-check only

## 4) Requirements

- Core scope (priority order):
  - Subscription remaining days / amount alerts
  - Text-based change/cancel guidance
  - Weekly/monthly cost summary
  - Alert rules for key dates / fee changes
- UI must be implementable in Flutter Web.
- For scenarios without backend/DB, localStorage is the default state store.
- User-facing copy should remain in Korean and follow branding guide.
- Main screen entry should expose key indicators quickly.
- Users can register/manage subscriptions per device without login.

## 4-1) Ideation Checkpoints

- Goal: implementation stays simple without becoming a plain Todo app
- Minimum flow: `Input (add subscription) -> Compute status -> Home summary -> Action suggestion`
- Data path: calculations from a JSON array stored in localStorage on one device
- Forbidden: external login, auth token, auto-refresh/sync, backend computation assumptions
- Required value (minimum 2): at least 2 of below should be immediately visible
  - Imminent status (near renewal / budget warning)
  - Cost summary (monthly/annual projection)
  - Suggested next action (extend/cancel/adjust guide)

## 5) Deliverables

- 3 candidate ideas
- Candidate matrix (value / effort / risk)
- Selection rationale document
- Toss miniapp first-pass wireframe
- Core feature list expandable to next PRD

## 6) Acceptance Criteria

- Complete 3+ concepts and scoring table
- Finalize at least one priority candidate
- Record selection rationale as `value > effort > risk`
- Zero stop-risk (`high`) features by Guard review
- Zero unresolved priority/requirement gaps from QA
- 100% compliance with no-auth/no-backend feasibility
- Zero high-risk items from Todo-only regression check

## 7) Risks / Mitigation

- Features beyond miniapp capability: reduce scope back to MVP
- Todo-only drift risk: remove items without summary/imminent-status/action guidance
- LocalStorage collision/recovery failures: define version + migration policy in advance
- UX complexity growth: keep 3-5 core screens only

## 8) Approval Conditions

- 리더멍: final approval on scope and priority
- 픽셀멍: pass Flutter execution feasibility
- 뷰티멍: pass core screen readability
- 브랜딩멍: confirm message/tone application
- 가드멍: zero stop-risk items
- 체크멍: pass gate

## 9) Schedule

- Start after criteria aligned in pre-development meeting
- Generate and score candidates in 1 day
- One internal review (risk/quality) to finalize candidate
- Extract backlog carryover items in closing meeting

## 10) Execution Linkage

- Backlog roll-out:
  - `TODO-002-아이데이션-목록`
  - `TODO-002-아이데이션-후보비교`
  - `TODO-002-미니앱-최종선정`
  - `TODO-002-토스미니앱-Wireframe`
- Runbook linkage: record under PRD 3-step flow (pre-dev meeting -> execution -> retrospective)

## Pre-Development Meeting Linkage

- Parallel meeting log: `.codex/PRD/PRD-001-002-kickoff-meeting-log.md`
- Status: Track B candidate consensus applied (3 candidates, fixed priority rule)

## Parallel Draft Output

### Candidate Concepts

- C1: Home-first subscription status app
  - Core value: check remaining days, amounts, and upcoming charges at a glance in one screen
- C2: Subscription change guide app
  - Core value: reduce decision burden with step-by-step change/cancel flow
- C3: Cost-control mission app
  - Core value: warn users of overspending windows via weekly/monthly summaries

### Candidate Matrix

Score (10 points, higher is better)

| Candidate | Value | Effort (lower is better, higher score) | Risk (lower is better, higher score) | Total |
| --- | --- | --- | --- | --- |
| C1 | 9 | 8 | 8 | 25 |
| C2 | 8 | 6 | 7 | 21 |
| C3 | 9 | 6 | 6 | 21 |

### Constraint-based Supplementary Scores

| Candidate | Backend-free feasibility (10) | Anti-Todo drift (10) | Local recoverability (10) | Extended total |
| --- | --- | --- | --- | --- |
| C1 | 10 | 10 | 9 | 29 |
| C2 | 9 | 7 | 8 | 24 |
| C3 | 10 | 8 | 9 | 27 |

Selection rule: prioritize total score, then value.

### Final Priority Candidate

- 1st: `C1 Home-first subscription status app`
- Selection rationale:
  - Higher user value (9), lower effort (8), lower risk (8)
  - Fits Toss miniapp constraints (concise, fast execution)

### Core Screens (Draft)

1. Home (summary): remaining days, monthly total, 2-3 imminent items
2. Alert center: fee changes, upcoming renewal, adjustable status
3. Subscription management: detail view + entry to change/cancel guide
4. Monthly summary: period cost comparison and charts
5. Settings: guide texts, help, data reset instructions

### MVP Priority List (Draft)

- Must-have: local data ownership check, minimum 3 core screens, alert rules
- Optional: monthly summary expansion, deeper guidance
- Excluded: external integration (payment/login/auto-sync), automated analytics report

### Fixed Constraints for PRD-002

- Login/auth: none
- Permissions/account: none
- Backend/DB: none
- Storage: localStorage only
- App format: not a plain Todo app (must provide state summary + decision guidance)
