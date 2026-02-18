# 모바일 QA 체크리스트 템플릿

기준일:
범위:
관련 PRD/TODO:

## 1) 테스트 환경

- 브라우저:
- 플랫폼:
- 뷰포트(필수): 360x800, 390x844, 412x915

## 2) 기능 체크

- [ ] 핵심 화면 진입 시 주요 정보가 즉시 보인다.
- [ ] 주요 인터랙션(스크롤/열기/닫기/등록)이 오류 없이 동작한다.
- [ ] 주요 동선에서 비의도 노출/중복 노출이 없다.

## 3) 리소스/브랜딩 체크

- [ ] 폰트 구성(가족/파일 경로)이 현재 기준 문서와 일치한다.
- [ ] 웹 favicon/PWA icon 파일이 저장소에 존재하지 않는다. (`apps/miniapp/web/favicon*`, `apps/miniapp/web/icons/*`)
- [ ] `apps/miniapp/web/index.html`에 favicon/apple-touch-icon 링크가 없다.
- [ ] `apps/miniapp/web/manifest.json`의 `icons`가 빈 배열(`[]`)이다.
- [ ] `AppPalette` 고정 토큰(`F3F4F6`, `FFFFFF`, `FBD1A2`, `FFEFB1`, `FFF7D6`, `F39A1F`, `E27C00`)이 기준 문서와 일치한다.
- [ ] 화면에서 화이트 컴포넌트와 라이트 그레이 배경 구분이 명확하고, 컬러 포인트가 캐릭터 영역 중심으로 유지된다.

## 4) 접근성/성능 체크

- [ ] 텍스트 스케일 1.5에서 핵심 문구 잘림/오버플로우가 없다.
- [ ] 탭 타깃 최소 44x44와 포커스 이동 순서가 유지된다.
- [ ] reduce motion/저사양 시나리오에서 주요 동선이 유지된다.

## 5) 자동 검증 체크

- [ ] `bash scripts/verify.sh`가 오류 없이 종료된다.
- [ ] 회귀 테스트 수가 목표 기준을 만족한다.

## 6) 결과

- Result: [ ] Pass / [ ] Hold
- Tester:
- Date:
- Notes:
