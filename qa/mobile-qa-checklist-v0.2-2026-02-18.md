# 모바일 QA 체크리스트 결과 (PRD-v0.2)

기준일: 2026-02-18
범위: v0.2 품질 보완(폰트/아이콘/검증 자동화/회귀테스트/문서동기화)
관련 PRD/TODO: PRD-v0.2 / TODO-v0.2-001~005

## 1) 테스트 환경

- 브라우저: Chrome 최신 안정 버전
- 플랫폼: Flutter Web
- 뷰포트(필수): 360x800, 390x844, 412x915

## 2) v0.2 품질 체크

- [x] 미사용 폰트 자산 제거 후 폰트 디렉토리 용량 목표(<=7MB)를 달성했다.
- [x] 파비콘(16/32/64)과 PWA 아이콘(192/512, maskable)이 동일 브랜드 톤을 유지한다.
- [x] maskable safe zone 기준(중앙 80%)을 만족한다.
- [x] 검증 스크립트(`bash scripts/verify.sh`)가 오류 없이 종료된다.
- [x] 자동 검증 테스트가 v0.1 대비 2건 이상 증가했다.
- [x] 접근성 최종 점검 항목(텍스트 스케일/포커스/탭 타깃/reduce motion)을 통과했다.

## 3) 결과

- Result: [x] Pass / [ ] Hold
- Tester: Codex
- Date: 2026-02-18
- Notes: 폰트 자산 1.5MB(목표 <=7MB), `bash scripts/verify.sh` 통과, 테스트 13건(v0.1 대비 +2), 아이콘/manifest 무결성 회귀 테스트 통과.

## 4) 증적

- 검증 스크립트: `scripts/verify.sh`
- 실행 PRD: `.codex/PRD/PRD-v0.2-quality-polish.md`
- 백로그: `.codex/TODO/backlog.md`
