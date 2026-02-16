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
- Multi-track PRDs are handled with a parallel meeting flow.
  1) Common kickoff (all) → 2) parallel track alignment (branding / ideation) → 3) integration alignment
  - Integration output tracking: `.codex/changelog/CHANGELOG.md` + `.codex/TODO/backlog.md`

### 2) Execution
- 리더멍 manages scope, milestones, and blocker status.
- Each member executes with role-specific criteria and shares changes immediately.
- Stop conditions: `technical boundary breach`, `verification failure`, `risk escalation`.

## Parallel Meeting Template

- Common kickoff: priority, approval chain, top 3 blockers, cross-track dependency alignment.
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

### QA Gate Checklist (External-Integration Re-entry Prevention)

체크멍 gate 통과 전에 아래 항목을 모두 확인한다.

1. Feature scope boundary check
   - 신규 스코프에 `backend`, `DB`, `API`, `batch/scheduler`, `third-party SDK` 의존이 없는지 확인
   - 발견 시 `P0 policy violation`으로 gate hold
2. Dependency and config check
   - `pubspec.*`, `web/index.html`, 앱 초기화 코드에 외부 연동 성격의 신규 패키지/스크립트/키 설정 추가 여부 확인
   - 발견 시 사용자 사전 승인 기록(요청 근거 + 승인 일시) 없으면 gate hold
3. Network behavior check
   - 핵심 사용자 흐름이 네트워크 부재 상태에서도 동작하는지 확인
   - 네트워크 필수 흐름이 생기면 `MVP boundary breach`로 gate hold
4. Storage model check
   - 상태 저장이 `localStorage` 단일 경로를 유지하는지 확인
   - 외부 동기화/원격 백업 경로가 추가되면 gate hold
5. Documentation traceability check
   - 외부연동 관련 요구/코드/문서 변경이 있을 경우 `PRD`, `TODO`, `CHANGELOG`에 동일하게 기록되었는지 확인
   - 누락 시 gate rework 요청

Gate output format:
- Result: `pass` or `hold`
- Evidence: 체크 항목별 파일 경로 + line reference
- If hold: owner / remediation ETA / re-test condition
