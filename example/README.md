# RadarTUI Examples Collection 🚀

이 디렉토리는 RadarTUI 프레임워크의 다양한 위젯들과 기능들을 보여주는 예제 모음입니다.

## 실행 방법

```bash
dart run main.dart
```

## 예제 목록

### 1. 카운터 (Counter) 
- **기능**: 기본적인 상태 관리와 키보드 이벤트 처리
- **사용 위젯**: `StatefulWidget`, `Text`, `Padding`, `Column`
- **키 조작**: 아무 키나 누르면 카운터 증가

### 2. 계산기 (Calculator) 🧮
- **기능**: 사칙연산 계산기
- **사용 위젯**: `Container`, `Row`, `TextStyle`, 키보드 입력 처리
- **키 조작**: 
  - 숫자 키: 0-9
  - 연산자: +, -, *, /
  - 계산: =, Enter
  - 초기화: C

### 3. 시스템 대시보드 (Dashboard) 📊
- **기능**: 실시간 시스템 모니터링 시뮬레이션
- **사용 위젯**: `Timer`, 프로그레스 바, 그래프, 복합 레이아웃
- **키 조작**: 
  - P: 일시정지/재시작
  - 실시간 업데이트 (1초 간격)

### 4. 숫자 맞추기 게임 (Guess Game) 🎯
- **기능**: 1-100 사이 숫자 맞추기
- **사용 위젯**: 게임 로직, 히스토리 관리, 동적 색상
- **키 조작**: 
  - 숫자 입력 후 Enter
  - N: 새 게임
  - Backspace: 지우기

### 5. 로딩 스피너 (Spinner Demo) ⏳
- **기능**: 애니메이션 스피너와 프로그레스 바
- **사용 위젯**: `Timer.periodic`, 애니메이션, 상태 업데이트
- **키 조작**: 아무 키나 누르면 재시작

### 6. 스타일 데모 (Style Demo) 🎨
- **기능**: 다양한 텍스트 스타일과 색상 시연
- **사용 위젯**: `TextStyle`, `Container`, `Color`, `EdgeInsets`
- **키 조작**: 정적 UI (상호작용 없음)

## 공통 기능

- **ESC 키**: 모든 예제에서 메인 메뉴로 돌아가기
- **통합 네비게이션**: 숫자 키(1-6)로 예제 선택
- **일관된 UI 디자인**: 모든 예제가 RadarTUI 스타일 가이드를 따름

## 파일 구조

```
example/
├── main.dart                    # 메인 앱 (통합 메뉴)
├── examples/                    # 개별 예제들
│   ├── calculator_example.dart
│   ├── dashboard_example.dart
│   ├── guess_game_example.dart
│   ├── spinner_example.dart
│   └── style_example.dart
├── calculator.dart              # → 이전됨 (리다이렉트)
├── dashboard.dart               # → 이전됨 (리다이렉트)
├── guess_game.dart              # → 이전됨 (리다이렉트)
├── spinner_demo.dart            # → 이전됨 (리다이렉트)
├── style_demo.dart              # → 이전됨 (리다이렉트)
└── pubspec.yaml
```

## 학습 포인트

1. **StatefulWidget vs StatelessWidget** 사용 시기
2. **키보드 이벤트 처리** 패턴
3. **Timer와 애니메이션** 구현
4. **복합 위젯 레이아웃** 구성
5. **상태 관리** 기법
6. **const 최적화** 활용

각 예제는 독립적으로 작동하며, 서로 충돌하지 않도록 설계되었습니다.