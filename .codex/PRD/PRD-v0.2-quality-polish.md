# PRD-v0.2: 모아멍 Quality Polish & Release Hygiene

## Document Info
- PRD ID: PRD-v0.2
- Version: v0.2 (Polish Cycle)
- Created: 2026-02-16
- Updated: 2026-02-16
- Owners: 리더멍, 픽셀멍, 체크멍, 가드멍
- Source: v0.1 완료 점검 후 보완 과제(용량/브랜딩 일관성/운영 자동화)

## 0) Quantitative Baseline (2026-02-16)

- 기준 측정:
  - `apps/miniapp/assets/fonts`: 약 `25MB`
  - `apps/miniapp/build/web`: 약 `42MB` (release build 산출물)
- v0.2 정량 목표:
  - 저장소 내 폰트 자산 용량 `25MB -> 7MB 이하`
  - release build 총량은 v0.1 기준 대비 `증가 금지`(허용 오차 +3% 이내)

## 1) Purpose

v0.1에서 기능/QA 완료 상태를 확보했으므로, v0.2에서는 릴리즈 품질을 높이는 보완 과제에 집중한다.

- 불필요 자산을 정리해 배포/운영 부담을 낮춘다.
- 파비콘과 PWA 앱 아이콘의 브랜드 일관성을 맞춘다.
- 반복 검증을 자동화해 회귀 리스크를 줄인다.
- 문서/백로그/품질 게이트를 v0.2 기준으로 재정렬한다.

## 2) Scope

- 폰트/에셋 경량화(미사용 자산 제거, 포함 자산 검증)
- 웹 아이콘 세트 통일(파비콘 + PWA icon/maskable)
- 자동 검증 실행 경로 표준화(analyze/test/build)
- v0.2 QA 체크포인트/운영 문서 동기화

## 3) Out of Scope

- 신규 기능 추가(견종 전환, 서버 연동, 알림 고도화)
- 캐릭터 리디자인 신규 라운드
- 정보 구조(원페이지) 개편
- 외부 SDK/백엔드/DB 도입

## 4) Requirements

### 4-1) Asset & Font Hygiene

- 앱에서 사용하지 않는 폰트 자산은 저장소 기준으로 정리한다.
- Flutter 번들에 포함되는 폰트는 `Pretendard`만 유지한다.
- 자산 정리 후에도 텍스트 렌더링 회귀가 없어야 한다.
- 산출물 검증:
  - `pubspec.yaml` 폰트 선언 단일화 확인
  - 빌드 후 폰트/자산 누락 오류 없음
  - `apps/miniapp/assets/fonts` 폴더 용량 `7MB 이하` 달성

### 4-2) Brand Icon Consistency

- 현재 말티푸 얼굴 파비콘 스타일을 PWA 설치 아이콘까지 일관화한다.
- `web/icons/Icon-192.png`, `Icon-512.png`, `Icon-maskable-*`를 동일 브랜드 톤으로 교체한다.
- `manifest.json`과 실제 파일 세트의 사이즈/경로를 일치시킨다.
- 16/32/64(파비콘) + 192/512(PWA) 가독성을 함께 검증한다.
- maskable 기술 기준:
  - 핵심 얼굴 요소는 아이콘 중앙 `safe zone(지름 80% 원)` 안에 배치
  - 모서리 크롭 시 눈/코/입 주요 파츠가 잘리지 않아야 함
  - 배경 대비 기준: 라이트 배경에서 얼굴 윤곽이 유지될 것

### 4-3) Verification Automation

- 로컬에서 반복 실행 가능한 표준 검증 명령(스크립트 또는 문서화된 단일 커맨드)을 제공한다.
- 최소 포함:
  - `flutter analyze`
  - `flutter test`
  - `flutter build web --release`
- 실패 시 즉시 중단되는 순차 실행 정책을 사용한다.
- 표준 진입점:
  - 스크립트 파일: `scripts/verify_v0_2.sh`
  - 실행 명령: `bash scripts/verify_v0_2.sh`

### 4-4) Regression Guard Expansion

- v0.1 핵심 테스트(11개)는 유지한다.
- v0.2 보완 범위에 대한 자동 검증 최소 2개를 추가한다.
  - 필수 1: 아이콘/manifest 리소스 참조 무결성 검증
  - 필수 2: 폰트 설정 단일화(`Pretendard` only) 회귀 검증
- 접근성 최종 점검 항목은 QA 체크리스트에 유지한다.

### 4-5) Documentation Sync

- `PRD-INDEX`, `backlog`, `changelog`, `docs-index`, `README`를 v0.2 기준으로 정렬한다.
- v0.1은 완료 베이스라인으로 보존하고, 활성 실행 기준은 v0.2로 전환한다.
- v0.2 QA 실행본 파일명 규칙:
  - 체크리스트: `qa/mobile-qa-checklist-v0.2-YYYY-MM-DD.md`
  - 리포트: `qa/mobile-qa-report-v0.2-YYYY-MM-DD.md`

## 5) Deliverables

1. v0.2 실행 PRD 문서
2. v0.2 backlog 항목(우선순위/완료 기준 포함)
3. 브랜드 통일 웹 아이콘 세트(파비콘 + PWA)
4. 검증 실행 표준(`scripts/verify_v0_2.sh`)
5. v0.2 QA 결과 문서(체크리스트/리포트, v0.2 파일명 규칙)
6. 동기화된 운영 문서 세트

## 6) Acceptance Criteria

- 미사용 폰트 자산 정리 후 앱 렌더링/빌드 회귀가 없다.
- 파비콘과 PWA 아이콘이 같은 말티푸 얼굴 아이덴티티로 노출된다.
- 표준 검증 실행 1회로 analyze/test/build가 연속 수행된다.
- 자동 검증 테스트가 v0.1 대비 2건 이상 증가한다.
- 아이콘 maskable safe zone 기준을 통과한다.
- QA 최종 판정이 Pass이며 v0.2 문서 세트가 동기화된다.
- 최종 DoD: `체크멍 gate + 가드멍 risk review + 리더멍 final approval`

## 7) Risks / Mitigation

- 리스크: 폰트 제거 시 한글 가독성 저하
  - 대응: 제거 전/후 주요 화면 비교 및 텍스트 스케일 회귀 확인
- 리스크: 아이콘 교체 후 플랫폼별 마스킹 깨짐
  - 대응: 192/512 + maskable 별도 시안 확인, QA artifact 보관
- 리스크: 자동화 스크립트/문서 불일치
  - 대응: changelog/README에 동일 명령을 단일 기준으로 기록

## 8) Approval Conditions

- 체크멍: 자동/수동 QA 통과, 리소스 무결성 확인
- 가드멍: v0.2 범위 외 스코프 확장 없음
- 리더멍: PRD-backlog-changelog 추적 가능성 확인

## 9) Schedule

1. 자산/아이콘 현황 점검 및 교체안 확정
2. 자산 정리 및 아이콘 세트 교체
3. 자동 검증 표준화 + 회귀 테스트 2건 추가
4. QA 실행 및 문서 동기화
5. 승인 게이트 통과

## 10) Execution Linkage (Backlog / Runbook)

- [PRD-v0.2][TODO-v0.2-001-폰트-에셋-정리] 미사용 폰트/에셋 정리 및 번들 회귀 점검
- [PRD-v0.2][TODO-v0.2-002-PWA-아이콘-통일] 파비콘/PWA 아이콘 말티푸 얼굴 톤 일관화
- [PRD-v0.2][TODO-v0.2-003-검증-자동화] analyze/test/build 표준 검증 실행 경로 확정
- [PRD-v0.2][TODO-v0.2-004-회귀테스트-2건추가] 보완 범위 자동 검증 2건 이상 추가
- [PRD-v0.2][TODO-v0.2-005-QA-문서동기화] QA 결과 및 운영 문서 세트 v0.2 동기화

## 11) Task Completion Contract (Evidence)

- `TODO-v0.2-001-폰트-에셋-정리` 완료 기준:
  - 증적: `apps/miniapp/pubspec.yaml`, `apps/miniapp/assets/fonts`
  - 검증: `bash scripts/verify_v0_2.sh` 통과
- `TODO-v0.2-002-PWA-아이콘-통일` 완료 기준:
  - 증적: `apps/miniapp/web/favicon.svg`, `apps/miniapp/web/favicon.png`, `apps/miniapp/web/icons/*`, `apps/miniapp/web/manifest.json`
  - 검증: 아이콘 16/32/64/192/512 가독성 확인 및 QA artifact 저장
- `TODO-v0.2-003-검증-자동화` 완료 기준:
  - 증적: `scripts/verify_v0_2.sh`, `README.md` 실행 가이드
  - 검증: 비정상 종료 코드 전파 + 3단계(analyze/test/build) 로그 확인
- `TODO-v0.2-004-회귀테스트-2건추가` 완료 기준:
  - 증적: `apps/miniapp/test/widget_test.dart`(또는 동등 테스트 파일)
  - 검증: 전체 테스트 pass + 신규 2건 식별 가능
- `TODO-v0.2-005-QA-문서동기화` 완료 기준:
  - 증적: `qa/mobile-qa-checklist-v0.2-YYYY-MM-DD.md`, `qa/mobile-qa-report-v0.2-YYYY-MM-DD.md`, `docs/docs-index-ko.md`, `.codex/changelog/CHANGELOG.md`
  - 검증: 최종 판정 Pass + PRD/backlog/changelog 상호 참조 일치
