# 모아멍

모아멍은 간단한 구독 현황 관리를 위한 Flutter Web 미니앱 MVP입니다.

## v0.3 Focus (In Progress)

- 말티푸 캐릭터 디자인 개선(레퍼런스 톤 기반)
- 얼굴 중심 favicon + PWA 아이콘 일관화
- 전 화면 UI 컴포넌트 beautify
- 컬러 정책 정리: 화이트 컴포넌트 + 라이트 그레이 배경 + 캐릭터 옐로우 포인트

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
- Palette: white components + light gray background + yellow mascot accents (orange only for warning accents)
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

- Active PRD: `.codex/PRD/PRD-v0.3-visual-refresh.md`
- Completed PRD (latest first): `.codex/PRD/PRD-v0.2-quality-polish.md`, `.codex/PRD/PRD-v0.1-mvp-baseline.md`
- Backlog: `.codex/TODO/backlog.md`
- Changelog: `.codex/changelog/CHANGELOG.md`
- QA checklist template: `qa/mobile-qa-checklist.md`
- QA report template: `qa/mobile-qa-report-template.md`
- Docs index (KR): `docs/docs-index-ko.md`
