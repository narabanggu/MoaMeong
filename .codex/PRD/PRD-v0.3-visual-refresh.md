# PRD-v0.3: 모아멍 Visual Refresh (Maltipoo & UI Beautify)

## Document Info
- PRD ID: PRD-v0.3
- Version: v0.3 (Visual Refresh Cycle)
- Created: 2026-02-18
- Updated: 2026-02-18
- Owners: 리더멍, 뷰티멍, 픽셀멍, 체크멍, 가드멍
- Source: 사용자 요청(v0.3 기획: 말티푸 캐릭터 리디자인 + 인앱 배포 기준 웹 아이콘 정리 + 전체 UI/컬러 정돈)

## 1) Purpose

v0.2 품질 정리 이후, v0.3에서는 제품의 첫 인상을 결정하는 시각 완성도를 강화한다.

- 첨부 레퍼런스 톤을 기준으로 말티푸 캐릭터 비주얼을 개선한다.
- 인앱 배포 기준에 맞춰 웹 favicon/PWA 아이콘 아티팩트를 제거한다.
- 전 화면 컴포넌트 시각 위계를 정리해 읽기 쉬운 UI로 개선한다.
- 컬러 정책을 `화이트 컴포넌트 + 라이트 그레이 배경 + 캐릭터 옐로우 포인트`로 고정한다.

## 2) Scope

- 말티푸 캐릭터 자산 리디자인(전신)
- 인앱 배포 기준 웹 아이콘 제거(`favicon`/`web/icons`/아이콘 링크)
- 앱 전 화면 UI 컴포넌트 beautify
- 컬러 토큰/테마 정비(중간 대비)
- 모션 품질 보정(절제된 모션 + reduce motion 유지)
- v0.3 문서/백로그/검증 기준 동기화

## 3) Out of Scope

- 신규 기능 추가(백엔드, 알림 시스템 확장, 정보 구조 대개편)
- 폰트 교체(`SUIT` 유지)
- 데이터 스키마/저장 구조 변경
- 외부 SDK/서드파티 연동 확대

## 4) Requirements

### 4-1) Maltipoo Character Refresh

- 캐릭터는 기존 말티푸 정체성을 유지하되, 레퍼런스처럼 큰 눈/풍성한 털/둥근 실루엣을 강화한다.
- 자산 구성:
  - 전신 SVG: `apps/miniapp/assets/characters/maltipoo_mascot.svg` (앱 Hero/브랜딩 영역)
- 캐릭터 강조는 Hero/브랜드 영역 중심으로 제한하고 정보 영역 가독성을 우선한다.

### 4-2) Web Icon Removal Policy (In-App)

- 웹 favicon/PWA 아이콘을 사용하지 않는다.
- `apps/miniapp/web/index.html`에는 `rel="icon"` 및 `apple-touch-icon` 링크를 두지 않는다.
- `apps/miniapp/web/manifest.json`의 `icons`는 빈 배열(`[]`)을 유지한다.
- `apps/miniapp/web/favicon.png`, `apps/miniapp/web/icons/*` 파일 잔존을 금지한다.
- 기본 Flutter/Dart 파비콘 재도입을 금지한다.

### 4-3) UI Beautify (All Screens)

- 대상 화면:
  - 홈
  - 알림 드로어/알림 센터
  - 구독 입력/수정 시트
- 공통 원칙:
  - 화이트 컴포넌트(카드/입력/버튼)와 배경 영역을 명확히 분리
  - 간격 스케일(8/12/16/24)과 반경/보더/그림자 규칙 일관화
  - 제목/본문/보조텍스트 타이포 위계 정리

### 4-4) Color Policy

- 전체 정책:
  - 컴포넌트: 화이트 기반
  - 컴포넌트 외 배경: 라이트 그레이 기반
  - 캐릭터 강조: 옐로우 포인트 중심
- v0.3 토큰 기준값(고정):
  - 배경(base): `#F3F4F6`
  - 표면(surface): `#FFFFFF`
  - 캐릭터 옐로우(primary): `#FBD1A2`
  - 캐릭터 옐로우 소프트: `#FFEFB1`
  - 경고 오렌지: `#F39A1F`
  - 위험 오렌지: `#E27C00`
- 경고/리스크 상태를 제외한 일반 정보 영역에서 오렌지 과다 사용을 제한한다.
- 컬러 강도는 가독성과 구분감을 해치지 않는 `중간 대비`를 기본값으로 한다.

### 4-5) Motion & Accessibility

- 모션은 절제된 범위로 적용한다(진입/상태전환/탭 반응 중심).
- `reduce motion` 환경에서는 반복/강한 모션을 완화 또는 정지한다.
- 기존 탭 타깃 최소 크기 및 키보드 포커스 순서 회귀를 유지한다.

### 4-6) Documentation & Verification

- v0.3를 활성 PRD로 전환하고, v0.2/v0.1은 완료 PRD로 분리해 유지한다.
- per-version QA 실행본 문서는 새로 커밋하지 않고 템플릿 중심 운영을 유지한다.
- 표준 검증 진입점은 `bash scripts/verify.sh`를 유지한다.

### 4-7) Regression Guard (v0.3)

- 기존 회귀 테스트는 유지한다.
- v0.3 범위 자동 검증을 최소 2건 추가한다.
  - 필수 1: 테마 토큰 적용 회귀(배경/컴포넌트 분리 정책)
  - 필수 2: 캐릭터 자산 경로/렌더링 회귀(전신 자산)
- 웹 아이콘 미사용 정책 및 폰트 단일화 회귀 테스트는 기존 기준을 유지한다.

## 5) Deliverables

1. v0.3 실행 PRD 문서
2. v0.3 활성 backlog 항목
3. 말티푸 캐릭터 리디자인 자산(전신)
4. 웹 아이콘 미사용 정책 반영(manifest/index/file)
5. 전 화면 UI beautify 반영
6. v0.3 문서/검증 기준 동기화

## 6) Acceptance Criteria

- 캐릭터 자산 파일은 `apps/miniapp/assets/characters/maltipoo_mascot.svg` 단일 전신 파일만 사용한다.
- `apps/miniapp/assets/characters/maltipoo_face.svg`는 존재하지 않는다.
- `apps/miniapp/web/favicon.png` 및 `apps/miniapp/web/icons/*` 파일이 존재하지 않는다.
- `apps/miniapp/web/index.html`에 `rel="icon"` 및 `apple-touch-icon` 링크가 없다.
- `apps/miniapp/web/manifest.json`의 `icons`가 빈 배열(`[]`)이다.
- `AppPalette`에 v0.3 컬러 기준값(`#F3F4F6`, `#FFFFFF`, `#FBD1A2`, `#FFEFB1`, `#F39A1F`, `#E27C00`)이 반영된다.
- v0.3 자동 검증 2건(테마 분리, 캐릭터 자산/렌더링)이 추가된다.
- reduce motion 및 접근성 회귀 없이 기존 기능이 유지된다.
- 문서 인덱스/백로그/체인지로그가 v0.3 활성 기준으로 일치한다.
- `bash scripts/verify.sh`가 통과한다.
- 최종 DoD: `체크멍 gate + 가드멍 risk review + 리더멍 final approval`

## 7) Risks / Mitigation

- 리스크: 캐릭터 강조가 정보 가독성을 해칠 수 있음
  - 대응: 캐릭터 강조 영역을 Hero/브랜딩으로 제한, 본문 영역은 중립 톤 유지
- 리스크: 웹 아이콘 파일 잔존으로 정책 혼선 발생
  - 대응: `release_hygiene_test.dart`에서 파일/링크/manifest 아이콘 부재를 고정 검증
- 리스크: beautify 범위 확장으로 회귀 증가
  - 대응: 공통 토큰 우선 적용 + 기존 회귀 테스트/verify 유지

## 8) Approval Conditions

- 체크멍: 시각/기능/접근성 회귀 기준 통과
- 가드멍: v0.3 범위 밖 기능 확장 없음
- 리더멍: PRD-backlog-changelog 추적 가능성 확인

## 9) Schedule

1. 캐릭터/아이콘 정책 가이드 확정
2. 자산 제작(전신) + 웹 아이콘 제거 반영
3. 테마 토큰/공통 컴포넌트 beautify 반영
4. 화면별 세부 보정(홈/알림/입력시트)
5. 검증 및 문서 동기화
6. 승인 게이트 통과

## 10) Execution Linkage (Backlog / Runbook)

- [PRD-v0.3][TODO-v0.3-001-캐릭터-리디자인] 말티푸 캐릭터 전신 v0.3 자산 제작
- [PRD-v0.3][TODO-v0.3-002-웹아이콘-제거] 인앱 배포 기준 웹 favicon/PWA 아이콘 참조 및 파일 제거
- [PRD-v0.3][TODO-v0.3-003-컬러-테마-정비] 화이트/그레이/옐로우 정책 및 고정 hex 토큰 기반 테마 정비
- [PRD-v0.3][TODO-v0.3-004-전화면-컴포넌트-뷰티파이] 홈/알림/입력시트 UI 일관성 개선
- [PRD-v0.3][TODO-v0.3-005-모션-접근성-회귀점검] 절제된 모션 + reduce motion 유지 검증
- [PRD-v0.3][TODO-v0.3-006-문서-검증-동기화] PRD/TODO/README/docs/changelog/verify 기준 정렬

## 11) Task Completion Contract (Evidence)

- `TODO-v0.3-001-캐릭터-리디자인` 완료 기준:
  - 증적: `apps/miniapp/assets/characters/maltipoo_mascot.svg`
  - 검증: 홈 Hero 캐릭터 렌더링 회귀 없음
- `TODO-v0.3-002-웹아이콘-제거` 완료 기준:
  - 증적: `apps/miniapp/web/manifest.json`, `apps/miniapp/web/index.html`, `apps/miniapp/test/release_hygiene_test.dart`
  - 검증: 웹 아이콘 파일/링크/manifest icons 부재
- `TODO-v0.3-003-컬러-테마-정비` 완료 기준:
  - 증적: `apps/miniapp/lib/core/theme/app_palette.dart`, `apps/miniapp/lib/core/theme/app_theme.dart`
  - 검증: 화이트 컴포넌트 + 라이트 그레이 배경 분리 + v0.3 컬러 토큰값 반영
- `TODO-v0.3-004-전화면-컴포넌트-뷰티파이` 완료 기준:
  - 증적: 홈/알림/입력시트 UI 관련 위젯 파일
  - 검증: spacing/typography/visual hierarchy 규칙 일관성 확인
- `TODO-v0.3-005-모션-접근성-회귀점검` 완료 기준:
  - 증적: `apps/miniapp/test/widget_test.dart`, `apps/miniapp/test/release_hygiene_test.dart`
  - 검증: reduce motion/포커스/탭 타깃 회귀 없음 + v0.3 신규 검증 2건 확인
- `TODO-v0.3-006-문서-검증-동기화` 완료 기준:
  - 증적: `.codex/PRD/PRD-INDEX.md`, `.codex/TODO/backlog.md`, `README.md`, `docs/docs-index-ko.md`, `.codex/changelog/CHANGELOG.md`
  - 검증: `bash scripts/verify.sh` 기준 운영 정책 문서 일치
