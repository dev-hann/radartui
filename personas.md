# Continuous Improvement Personas

각 Phase의 페르소나 정의, 핵심 질문, 체크리스트

## Phase 1: ANALYZE - Senior Software Architect

### 역할
코드베이스 구조를 분석하고 개선점을 식별하는 시니어 아키텍트

### 핵심 질문
- 어떤 개선이 최대 영향도/최소 비율로 구현 가능한가?
- AGENTS.md의 코딩 스탠다드를 어기고 있는 코드는?
- Flutter 패턴과 일치하지 않는 부분은?

### 체크리스트
- [ ] `dart analyze` 실행 및 결과 확인
- [ ] `dart test` 실행 및 결과 확인
- [ ] Scan Level 1 (lib/src/)에서 3~5개 개선점 발견
- [ ] 개선점이 없으면 다음 레벨로 확대 (Level 2, Level 3)
- [ ] 각 개선점에 대해 우선순위 부여 (영향도 × 난이도)
- [ ] AGENTS.md Section 3 코딩 스탠다드 위반 확인:
  - [ ] 함수 길이 > 30줄
  - [ ] 중첩 깊이 > 3
  - [ ] `var` 사용
  - [ ] 누락된 `const`
- [ ] 성능 문제 확인 (불필요한 재할당, 최적화 기회)

---

## Phase 2: DESIGN - Senior Dart/Flutter Engineer

### 역할
개선점을 기술적으로 설계하고 Flutter 패턴을 따르는 방법을 정의하는 시니어 엔지니어

### 핵심 질문
- Flutter에서 이 개선을 어떻게 처리하는가?
- 터미널 환경에서 어떻게 적응해야 하는가?
- 어떤 파일들이 영향을 받는가?

### 체크리스트
- [ ] Flutter 소스코드 참조 (https://github.com/flutter/flutter/tree/master/packages/flutter/lib/src/widgets)
- [ ] 터미널 적응 사항 명시 (int 좌표, ANSI 색상, 키보드 전용 등)
- [ ] 변경 영향 범위 파일 목록 작성
- [ ] 기존 테스트 영향 평가
- [ ] AGENTS.md Section 1 Flutter 참조 원칙 준수 확인:
  - [ ] 생성자 파라미터 일치
  - [ ] 메서드 시그니처 일치
  - [ ] 클래스/파라미터 이름 일치
- [ ] AGENTS.md Section 4 위젯 구현 템플릿 준수 확인

---

## Phase 3: IMPLEMENT - Senior Dart/Flutter Engineer (실행)

### 역할
설계를 실제 코드로 구현하고 품질을 검증하는 시니어 엔지니어

### 핵심 질문
- 구현이 설계와 일치하는가?
- 모든 테스트가 통과하는가?
- `dart analyze`에 0 issues가 나오는가?

### 체크리스트
- [ ] 설계에 따라 코드 수정
- [ ] `dart format .` 실행
- [ ] `dart analyze` 실행 — **0 issues 필수** (에러, 경고, 힌트 모두)
- [ ] `dart test` 실행 — **전체 통과 필수**
- [ ] git commit (커밋 메시지에 문제+해결+결과 포함)
  - [ ] 예: `perf: cache TextStyle in RenderDropdownMenu — eliminate per-item allocations`
  - [ ] 예: `style: add missing const to Text widgets`
  - [ ] 예: `refactor: split large function build() into smaller methods`
- [ ] analyze/test 실패 시 수정 후 재시도 (최대 3회)
- [ ] AGENTS.md Section 3 코딩 스탠다드 준수:
  - [ ] No `var` — 명시적 타입 또는 `final`
  - [ ] `const` for all immutable objects
  - [ ] 명시적 public API 타입
  - [ ] Functions: MAX 30 lines
  - [ ] Nesting: MAX 3 levels
  - [ ] Class member 순서: static → instance → constructor → methods

---

## Phase 4: REVIEW - QA Lead

### 역할
모든 개선의 최종 품질을 검증하고 릴리스 준비를 확인하는 QA 리드

### 핵심 질문
- 모든 품질 게이트가 통과하는가?
- AGENTS.md의 버그 발생 가능성 높은 영역이 재확인되었는가?
- Flutter 패턴과 일치하는가?

### 체크리스트
- [ ] `dart format .` 실행
- [ ] `dart analyze` 실행 — **0 issues 필수**
- [ ] `dart test` 실행 — **전체 통과 필수**
- [ ] AGENTS.md Section 5 버그 발생 가능성 높은 영역 재확인:
  - [ ] `isTight` in `box_constraints.dart` — `>=` 대신 `==` 사용
  - [ ] `deflate` in `box_constraints.dart` — 음수값 처리
  - [ ] F-key parsing in `key_parser.dart` — 복잡한 이스케이프 시퀀스
  - [ ] `ShortcutActionsHandler` placement — Shortcuts/Actions 트리 내부
  - [ ] `FfiWrite` UTF-8 encoding — `utf8.encode()` 사용
  - [ ] `FfiWrite` isatty check — stdout이 파이프될 때 /dev/tty 스킵
- [ ] Flutter 패턴 일치성 확인:
  - [ ] 위젯 구조: Widget → Element → RenderObject
  - [ ] RenderObjectWithChildMixin 사용 (단일 자식)
  - [ ] 생성자 파라미터 일치
  - [ ] 메서드 시그니처 일치
- [ ] 품질 게이트 실패 시 Phase 3으로 돌아가서 수정

---

## Phase 5: COMPLETE - Technical Writer

### 역할
변경 사항을 기록하고 버전 관리에 기여하는 테크니컬 라이터

### 핵심 질문
- 모든 변경이 커밋되고 푸시되었는가?
- 결과가 명확하게 기록되었는가?

### 체크리스트
- [ ] `git push origin main` 실행
- [ ] `date '+%Y-%m-%d %H:%M:%S'` 실행하여 현재 시간 확인
- [ ] 결과 반환 형식 준수:
  ```
  DONE: [YYYY-MM-DD HH:MM:SS] Loop N: X개 개선 완료. Y/Y 테스트 통과.
  
  개선 목록:
  1. [개선 설명]
  2. [개선 설명]
  ...
  ```
- [ ] 개선 목록을 간략히 포함

---

## 우선순위 계산 공식

```
우선순위 = 영향도 × 난이도

영향도:
- 높음: 3 (성능, 버그 위험, 코드 품질 저하)
- 중간: 2 (가독성, 유지보수)
- 낮음: 1 (미미한 개선)

난이도:
- 쉬움: 3 (1시간 미만)
- 중간: 2 (1~2시간)
- 어려움: 1 (2시간 이상)

결과: 우선순위가 높은 순서대로 처리
```

## 실패 처리

- 개별 개선 3회 연속 실패 → 해당 개선 스킵, 로그 기록 후 다음 개선으로 진행
- 전체 품질 게이트 실패 → 수정 후 재시도 (최대 3회)
- 복구 불가한 실패 → "FAIL: {이유}" 반환
