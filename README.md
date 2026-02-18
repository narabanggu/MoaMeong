# 모아멍

모아멍은 간단한 구독 현황 관리를 위한 Flutter Web 미니앱 MVP입니다.

## Current MVP Scope

1. One-page home flow (mobile-first)
2. Subscription list management (add/edit/delete)
3. Monthly normalized total view
4. Upcoming payment alerts (within 7 days) via right-side drawer
5. Local-only persistence with browser localStorage

## Technical Boundary

- Runtime: Flutter Web
- Storage: localStorage (`SharedPreferences`)
- Backend/DB/API/SDK: not used
- Auth/Login: not used

## Design Baseline

- Tone: clean miniapp style
- Palette: white + yellow (orange only for warning accents)
- Material: liquid-glass UI components
- Mascot: maltipoo-style 2D character
- Favicon: maltipoo face-only icon (`apps/miniapp/web/favicon.png`, 32x32)
- App font: SUIT

## Verification

- Run from repository root: `bash scripts/verify.sh`
- This command runs `flutter analyze -> flutter test -> flutter build web --release` in order and stops immediately on failure.

## Out of Scope

- Monthly budget tracking
- Server APIs / database
- Push notifications / batch workers
- Third-party integrations without explicit user approval

## Documentation

- Active PRD: `.codex/PRD/PRD-v0.2-quality-polish.md`
- Completed baseline: `.codex/PRD/PRD-v0.1-mvp-baseline.md`
- Backlog: `.codex/TODO/backlog.md`
- Changelog: `.codex/changelog/CHANGELOG.md`
- QA checklist template: `qa/mobile-qa-checklist.md`
- QA report template: `qa/mobile-qa-report-template.md`
- Docs index (KR): `docs/docs-index-ko.md`
