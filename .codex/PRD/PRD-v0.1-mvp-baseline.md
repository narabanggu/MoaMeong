# PRD-v0.1: 모아멍 MVP Baseline (Character & Home Hero)

## Document Info
- PRD ID: PRD-v0.1
- Version: v0.1 (Release Baseline)
- Created: 2026-02-15
- Updated: 2026-02-16
- Owners: 리더멍, 뷰티멍, 픽셀멍, 체크멍, 가드멍
- Related Agents: 브랜딩멍, 뷰티멍, 픽셀멍, 체크멍, 가드멍
- Source: 사용자 요청(캐릭터라이징 강화 + 홈 Hero 확장)

## 1) Purpose

현재 서비스의 재미 요소를 강화하기 위해 캐릭터 중심 경험을 명확히 올린다.

- 1차 출시 캐릭터는 `말티푸`로 고정한다.
- 견종 전환 구조는 이번 MVP(PRD-v0.1)에서 확정하지 않고 추후 단계에서 도입한다.
- 홈 진입 시 캐릭터 존재감과 요약 가독성을 동시에 강화한다.
- 제품 톤은 `다마고찌 감성 + 구독 관리`를 결합한 방향으로 정의한다.
- 본 PRD에서 최우선 항목은 `캐릭터 제작 완성도`다.

## 2) Scope

- 캐릭터 시스템 고도화(말티푸 기본 캐릭터 경험 강화)
- 캐릭터 탭/클릭 반응 애니메이션 추가
- 홈 상단 Hero(캐릭터 + 요약 카드) 크기 확대
- 다마고찌 감성의 경량 상호작용(반응/표정/상태 피드백) 방향 정의
- 모바일 기준 레이아웃/성능 검증

## 3) Out of Scope

- 3D 캐릭터, 음성, 복잡한 파티클 이펙트
- 서버 기반 캐릭터 다운로드/마켓
- 로그인 기반 개인화 캐릭터 동기화
- 외부 SDK/게임엔진 도입

## 4) Requirements

### 4-1) Character Baseline

- 기본 마스코트는 `말티푸` 2D 자산으로 출시한다.
- 파일명/식별자는 영어 규칙 유지, 사용자 노출 문구는 한국어 유지.
- 캐릭터 자산은 기존 Flutter Web 렌더링 구조에서 교체 가능해야 한다.
- 스타일 레퍼런스:
  - 큰 눈, 짧은 주둥이, 풍성한 귀/가슴털, 둥근 실루엣
  - 고채도 오렌지-브라운 털 + 크림 포인트
  - 아웃라인이 살아있는 귀여운 2D 일러스트 톤

### 4-2) Deferred Note (Breed Switch)

- 견종 전환(다른 강아지 선택/저장 구조)은 `PRD-v0.1 범위 밖`으로 둔다.
- 본 문서에서는 말티푸 단일 캐릭터 경험 완성도를 우선한다.
- 추후 별도 PRD에서 견종 선택 UX/데이터 구조를 재정의한다.

### 4-3) Click Animation

- 캐릭터 클릭 시 짧은 반응 애니메이션을 제공한다.
  - 예: scale bounce, ear wiggle, blink 중 1~2개 조합
- 애니메이션 길이는 과하지 않게 유지한다(권장 200~500ms).
- 연속 탭 시 끊김/프레임 드랍이 없도록 제한(cooldown 또는 중첩 방지)한다.
- 계약값(고정):
  - Total duration: `360ms`
  - Scale sequence: `1.00 -> 1.08 (120ms) -> 0.97 (100ms) -> 1.00 (140ms)`
  - Cooldown: `700ms` (반응 시작 시점 기준)
  - Overlap policy: 반응 재생 중 추가 탭은 `drop`(큐잉 없음)

### 4-4) Home Hero Enlargement

- 홈 상단 Hero의 캐릭터 크기를 기존 대비 명확히 확대한다.
- 요약 카드(헤드라인/설명/다음 결제 문구) 면적을 함께 확장한다.
- 스크롤 축소 인터랙션은 유지하되, 시작 상태와 축소 후 상태의 위계 차이가 명확해야 한다.

### 4-5) Content Rules

- 요약 문구는 현재 규칙 유지:
  - 7일 이내 결제 존재 시 임박 알림 우선
  - 없으면 구독 수 + 월환산 총액
  - 가능 시 다음 결제 서비스/일자 노출
- 과장형 카피보다 상태 전달 중심 카피를 유지한다.

### 4-5-a) Tamagotchi Tone Rule

- 홈 메인 캐릭터는 단순 장식이 아니라 상태를 전달하는 `반응형 비서`로 동작한다.
- 반응은 짧고 명확하게 유지한다(과도한 게임화 금지).
- 핵심 메시지는 항상 구독 관리 정보가 우선이며, 캐릭터 반응은 보조 역할로 배치한다.

### 4-6) Character Exposure Boundary

- 캐릭터는 `홈 상단 요약(Hero) 메인 영역`에서만 노출한다.
- 구독 목록(리스트/타일/행)에는 캐릭터를 노출하지 않는다.
- 빈 상태에서도 기본 원칙은 동일하며, 리스트 가독성을 우선한다.
- 적용 상태(2026-02-16): 홈 Hero 외 영역(구독 목록/알림 empty state) 캐릭터 제거 완료.

### 4-7) Tamagotchi-style 2D Animation Implementation

- 홈 Hero 캐릭터에 `다마고찌 감성`의 2D 애니메이션 시스템을 구현한다.
- 애니메이션 구성(최소):
  - Idle loop: 숨쉬기/눈깜빡임 기반의 저강도 반복 애니메이션
  - Reaction: 탭/클릭 시 즉각 반응(바운스/귀 흔들림/표정 변화)
  - State hint: 임박 결제 유무에 따른 표정/모션 차등(과도한 연출 금지)
- 구현 방식:
  - Flutter 내에서 관리 가능한 2D 방식으로 구현한다(SVG/벡터 파츠 애니메이션 또는 동등 난이도)
  - 프레임/상태 전환은 이벤트 기반으로 제어하고 중첩 재생을 방지한다.
- 성능/품질 기준:
  - 모바일 기준 스크롤/탭과 함께 동작해도 체감 버벅임이 없어야 한다.
  - 애니메이션은 정보 전달을 방해하지 않도록 짧고 읽기 쉬운 리듬을 유지한다.

### 4-8) Animation Technical Contract (Locked)

- 상태머신(단일 인스턴스):
  - `Idle` (기본)
  - `Reacting` (탭/클릭 반응)
  - `StateHint` (임박 결제 상태 힌트)
- 상태 전이 규칙:
  - `Idle -> Reacting`: 탭 이벤트 + cooldown 만료 시
  - `Reacting -> Idle`: 반응 종료 즉시
  - `Idle <-> StateHint`: 요약 데이터 변경 시 즉시 평가
  - `Reacting` 중에는 `StateHint` 갱신 이벤트를 큐잉하지 않고 종료 후 최신 상태 1회만 반영
- 타이밍 계약값:
  - Idle breathe loop: `2400ms` (easeInOut)
  - Idle blink interval: `3.2s ~ 5.8s` 랜덤
  - StateHint pulse:
    - 임박 결제 있음(<=7일): `1600ms` pulse
    - 임박 결제 없음: `2200ms` gentle bob
  - Global cooldown(react trigger): `700ms`
- 접근성 예외(모션 축소):
  - OS/브라우저의 `reduce motion` 선호가 활성화되면 Idle/StateHint/깜빡임 루프 모션은 완화 또는 정지한다.
  - 이 경우에도 탭 반응은 유지하되 과도한 회전/진폭은 축소한다.
- 재생 정책:
  - 동시에 활성화 가능한 강조 애니메이션은 1개(`Reacting` 우선)
  - 프레임 드랍 방지를 위해 Hero 영역 밖에서는 애니메이션 강도를 축소하거나 정지 가능

## 5) Deliverables

1. 말티푸 캐릭터 최종 자산(v1)
2. 캐릭터 클릭 애니메이션 구현
3. 다마고찌 스타일 2D 애니메이션 세트(Idle/Reaction/State hint) 구현
4. 홈 Hero 레이아웃 확대 및 스크롤 축소 보정
5. 다마고찌+구독관리 톤 가이드(반응 규칙/카피 톤) 문서화
6. 모바일 반응형/성능 QA 체크 결과
7. 관련 실행 문서(`PRD-v0.1`/`backlog`/`changelog`/`qa`) 동기화

## 6) Acceptance Criteria

- 홈 최초 진입에서 캐릭터와 요약 카드가 기존 대비 더 큰 위계로 보인다.
- 캐릭터 클릭 시 명확한 반응 애니메이션이 재생된다.
- Idle/Reaction/State hint 3종 2D 애니메이션이 홈 Hero에서 정상 동작한다.
- 7일 임박/비임박/다음 결제 요약 규칙이 깨지지 않는다.
- 캐릭터 노출은 홈 요약 메인 영역으로 제한되고 구독 목록에는 나타나지 않는다.
- 말티푸 1차 출시 견종 고정 정책이 문서화된다.
- 다마고찌 감성은 반응 UX에 반영되되, 구독 관리 가독성을 해치지 않는다.
- 모바일 주요 해상도에서 레이아웃 깨짐과 체감 프레임 저하가 없다.
- 최종 DoD: `체크멍 gate + 가드멍 risk review + 리더멍 final approval`

## 7) Risks / Mitigation

- 리스크: 애니메이션 과다로 성능 저하
  - 대응: 단일 위젯 범위 애니메이션, duration 제한, 중첩 방지
- 리스크: 캐릭터 강조로 정보 가독성 저하
  - 대응: 요약 텍스트 line clamp/행간 기준 고정, 모바일 우선 시뮬레이션
- 리스크: 2D 애니메이션 구현 복잡도 증가
  - 대응: Idle/Reaction/State hint 최소 세트부터 단계 적용, 이벤트/성능 기준 먼저 고정

## 8) Approval Conditions

- 체크멍: UI/성능/회귀 게이트 pass
- 가드멍: MVP 경계 위반(외부연동/스코프 확장) 없음
- 리더멍: PRD 요구사항과 백로그 매핑 완료 확인

## 9) Schedule

1. 말티푸 캐릭터 시안/최종안 확정 (최우선)
2. 2D 애니메이션 세트(Idle/Reaction/State hint) 구현
3. 홈 Hero 확대 및 다마고찌 반응 애니메이션 보정
4. QA 및 문서 동기화
5. 승인 게이트 통과

## 10) Execution Linkage (Backlog / Runbook)

- [PRD-v0.1][TODO-004-캐릭터-말티푸-v1] 말티푸 캐릭터 최종안 확정
- [PRD-v0.1][TODO-004-캐릭터-클릭애니메이션] 캐릭터 반응 애니메이션 구현
- [PRD-v0.1][TODO-004-캐릭터-2D애니메이션] 다마고찌 스타일 Idle/Reaction/State hint 2D 애니메이션 구현
- [PRD-v0.1][TODO-004-홈히어로-확대] 상단 Hero 캐릭터/요약 영역 확대 및 축소 인터랙션 보정
- [PRD-v0.1][TODO-004-다마고찌-톤가이드] 다마고찌 감성 + 구독 관리 톤 가이드 수립
- [PRD-v0.1][TODO-004-모바일-QA] 모바일 해상도/성능/터치 반응 점검
- [PRD-v0.1][TODO-004-파비콘-말티푸얼굴] 1차 출시 캐릭터(말티푸) 얼굴 단독 이미지 기반 파비콘으로 교체

## 11) Completion Sync (2026-02-16)

- 완료 기준: `Execution Linkage`의 TODO-004 항목 전부 완료, backlog active pending 없음
- 참고(2026-02-18): 버전 고정 QA 산출물(`qa/*-2026-02-16.md`)과 QA 파비콘 아티팩트(`qa/artifacts/*`)는 운영 정책 정리로 제거되고, 공용 QA 템플릿만 유지한다.
- `TODO-004-캐릭터-말티푸-v1`: 완료
  - 증적: `apps/miniapp/assets/characters/maltipoo_mascot.svg`, `.codex/changelog/CHANGELOG.md`
- `TODO-004-캐릭터-클릭애니메이션`: 완료
  - 증적: `apps/miniapp/lib/features/home/home_page.dart`, `apps/miniapp/test/widget_test.dart`
- `TODO-004-캐릭터-2D애니메이션`: 완료
  - 증적: `apps/miniapp/lib/core/widgets/mascot_branding.dart`, `apps/miniapp/test/widget_test.dart`
- `TODO-004-홈히어로-확대`: 완료
  - 증적: `apps/miniapp/lib/features/home/home_page.dart`, `apps/miniapp/test/widget_test.dart`
- `TODO-004-다마고찌-톤가이드`: 완료
  - 증적: `README.md`, `.codex/changelog/CHANGELOG.md`
- `TODO-004-모바일-QA`: 완료
  - 증적: `qa/mobile-qa-checklist.md`, `qa/mobile-qa-report-template.md`, `.codex/changelog/CHANGELOG.md`
- `TODO-004-파비콘-말티푸얼굴`: 완료
  - 증적: `.codex/changelog/CHANGELOG.md`, `apps/miniapp/test/release_hygiene_test.dart`

## 12) v0.1 Hardening (2026-02-16)

- 시간 소스 통합:
  - 캐릭터 반응 쿨다운 판정이 앱 주입 시간 소스(`nowProvider`) 기준으로 동작하도록 정렬.
- 노출 경계 회귀 강화:
  - 구독 목록/알림 드로어에서 캐릭터 추가 노출이 없는지 위젯 테스트로 고정.
- 모션 접근성 보강:
  - `reduce motion` 환경에서 루프 모션을 완화하고 핵심 탭 반응만 유지.
