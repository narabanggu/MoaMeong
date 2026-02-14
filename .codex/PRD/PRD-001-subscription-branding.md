# PRD-001: Subscription Mong Branding and Brand Design

## Document Info
- PRD ID: PRD-001
- Created: 2026-02-14
- Owners: 브랜딩멍, 리더멍
- Related Agents: 브랜딩멍

## 1) Purpose

Set one single standard for language tone, messaging, and visual rules so future app design and outputs continue with consistent brand alignment.

## 2) Scope

- Define core brand messages (headline, value proposition, user promise)
- Draft branding language guide (allowed tone, forbidden terms, sensitive expressions)
- Define first-pass color/typography/component rules
- Apply reusable copy/component rules to Toss miniapp screens
- Register change approval flow (review → improvement → final approval)

## 3) Out of Scope

- Backend/DB/API/server integration work
- External ad-campaign/marketing copy operations
- Legal notice/privacy-policy drafting (only ensure compliance to copy guide)

## 4) Requirements

- User-facing copy is in Korean.
- Internal identifiers and filenames use English.
- Brand rules are managed by at least 3 categories:
  - Tone (credibility / empathy / clarity)
  - Emotional intensity (strong / normal / mild)
  - Guarded wording (overclaim / fear / unnecessary exaggeration)
- Check at least 10 inconsistency items across existing outputs
- Apply the same rules to new channels (alerts, guides, Toss-style screens)

## 5) Deliverables

- Draft `docs/branding-guide.md` (internal standard document)
- Forbidden/sensitive term list
- First-pass color / typography / button / card rules
- Branding usage guide for PRD-002 miniapp planning

## 6) Acceptance Criteria

- Tone match: pass 90%+ across 10 key samples
- No misleading copy (hold immediately if sensitive/overclaiming terms are found)
- After branding approval, zero `high` risk findings from Guard review
- Hold if checklist fields are missing

## 7) Risks / Mitigations

- Overclaiming / misunderstanding: re-score copy and submit toned-down alternatives
- Visual rule conflicts: separate component units to minimize source conflicts
- Consistency drift: strengthen logs after weekly review

## 8) Approval Conditions

- 브랜딩멍: draft confirmation
- 체크멍: pass gate checklist
- 가드멍: no high-risk warnings
- 리더멍: final approval

## 9) Schedule

- Start after pre-development meeting
- Draft completion within 2 days
- One review cycle, then reflect revisions
- Lock backlog items to carry-forward at closing meeting

## 10) Execution Linkage

- Backlog rollout:
  - `TODO-001-브랜딩가이드`
  - `TODO-001-브랜딩리스크리뷰`
- Runbook linkage: apply first-pass pre-development meeting outcome, register follow-ups in retrospective review

## Pre-development Meeting Linkage

- Parallel meeting log: `.codex/PRD/PRD-001-002-kickoff-meeting-log.md`
- Status: aligned and reflected (Track A applied)

## Parallel Draft Output

### Branding First Draft Message

- Mission statement: `Make subscriptions easier to check and easier to manage.`
- Core principles
  - Trust first: express numbers, period, and benefits directly without overstatement
  - Reduce user load: split long messages into two sentences or fewer
  - Remove emotional overdrive: avoid anxiety-inducing/fear-based marketing
- Base tone
  - Opening: `Let's check your current status.`
  - Warning: `The due date is coming soon.`
  - Guidance: `Please verify these items before changing anything.`

### Draft Language Guide

- Tone guardrails
  - Allowed: `confirm`, `guide`, `recommend`, `reassure`
  - Restricted: `mandatory`, `must`, `100%`, `guaranteed`
  - Sensitive: overclaiming, fear, overly definitive negative claims
- Copy review criteria
  - Misleading copy: 0 tolerance
  - Repeated correction (same expression pattern): provide alternatives after 2 occurrences
  - New channels (alerts/status banners/chats): re-check with same criteria

### Draft Visual / Component Rules

- Color
  - Background: `#F7F8FA` (light neutral)
  - Accent: `#3F66FF` (primary action, links)
  - Warning: `#E5A000` (attention, upcoming items)
  - Error: `#D93A3A` (attention required)
- Typography
  - Base: readability-first
  - Key metrics (remaining days/amount): heavier weight + 1.5x line height
- Components
  - Core buttons: keep minimum touch area, consistent label style
  - Cards: one state color label per card
  - Alert badge: no more than 2 emphasis items at once

### Reference Outputs

- Detailed guide: `docs/branding-guide.md`
- Forbidden/sensitive term list: initial copy-review baseline
- PRD-002 message application: apply same tone to Home/Alert/Billing screens
