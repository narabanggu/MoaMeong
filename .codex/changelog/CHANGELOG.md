# Changelog

Format: Date / Summary / Owner

## Entries (v0.1 ~ v0.3)

- 2026-02-18 / Synced v0.3 docs to in-app icon-free policy and removed residual face asset dependency: updated PRD acceptance/evidence from favicon-PWA consistency to web icon removal baseline, dropped `maltipoo_face.svg` from runtime assets, and aligned hygiene tests to enforce mascot-body-only + no web icon files / 리더멍, 픽셀멍, 체크멍

- 2026-02-18 / Aligned web icon policy for in-app deployment: removed favicon and PWA icon files/references (`web/favicon.png`, `web/icons/*`, apple-touch-icon, manifest icons), removed face-style app header icon exposure, and updated hygiene tests to enforce no-icon web baseline / 픽셀멍, 체크멍

- 2026-02-18 / Completed PRD-v0.3 visual refresh implementation: rebuilt maltipoo as pixel-style mascot(face/body) from reference tone, unified favicon/PWA icon set with the pixel face source, enforced white-component + light-gray background policy with yellow accents constrained to mascot surfaces, improved multiline typography wrapping/readability, and passed full verify pipeline (`analyze + test + web release build`) / 픽셀멍, 뷰티멍, 체크멍

- 2026-02-18 / Opened PRD-v0.3 visual refresh cycle: promoted v0.3 as active execution PRD, defined scope for maltipoo character redesign + favicon/PWA face-icon consistency + app-wide UI beautify + white/gray/yellow color policy, and seeded active TODO backlog for implementation / 리더멍, 뷰티멍, 픽셀멍

- 2026-02-18 / Completed PRD-v0.2 quality polish: removed unused font assets (`assets/fonts` 25MB -> 1.5MB), added release hygiene regression tests (+2 for manifest/icon integrity and SUIT-only font guard), aligned favicon set (single 32px png + PWA 192/512 maskable), standardized verification entrypoint (`verify.sh`), and switched QA docs policy to template-based tracking (no per-version QA artifact commits) / 픽셀멍, 체크멍, 리더멍

- 2026-02-16 / Opened PRD-v0.2 quality polish cycle: documented post-v0.1 improvement scope in detail (asset/font hygiene, PWA icon consistency, verification automation, regression guard expansion), switched active PRD/backlog/docs index to v0.2 execution baseline / 리더멍, 체크멍

- 2026-02-16 / Finalized PRD-v0.1 completion sync: TODO-004 전체 완료 상태를 PRD/Backlog/QA 증적으로 고정하고 운영 문서 링크를 일관화 / 리더멍, 체크멍
- 2026-02-16 / Closed PRD-v0.1 hardening: `nowProvider` 기반 반응 쿨다운 정렬, 노출 경계(list/drawer) 회귀 테스트, reduce-motion 동작 보강 / 픽셀멍, 체크멍, 리더멍
- 2026-02-16 / Completed mascot build quality gates: 말티푸 캐릭터 v1 자산 확정, Hero 상태머신 애니메이션(Idle/Reacting/StateHint) 적용, 포커스 순서/접근성 테스트 강화 / 픽셀멍, 체크멍, 리더멍
- 2026-02-16 / Finalized QA and release artifacts: 모바일 QA 체크리스트/리포트 Pass, 웹 릴리즈 빌드 검증, 말티푸 얼굴 파비콘(svg/png + 16/32/64) 산출 / 체크멍, 리더멍
- 2026-02-16 / Migrated baseline naming to release convention: 활성 기준 문서명을 `PRD-v0.1-mvp-baseline.md`로 통일하고 README/docs/QA/handoff 참조를 동기화 / 리더멍, 체크멍
- 2026-02-15 / Established v0.1 product shape: 단일 홈 원페이지 구조, 우상단 알림 드로어/구독추가 액션, 홈 Hero 중심 요약 UX와 스크롤 축소 인터랙션 확정 / 픽셀멍, 뷰티멍, 리더멍
