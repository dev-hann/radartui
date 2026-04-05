# PTY 기반 터미널 렌더링 골든 테스트 설계

## 목표

`package:pty`를 사용해 실제 PTY에서 RadarTUI 앱을 실행하고, ANSI 출력을 캡처해 텍스트 그리드로 파싱하여 `.txt` 골든 파일과 비교하는 테스트 인프라 구축.

## 배경

현재 `TestBinding` 기반 인메모리 테스트는 위젯 로직 검증에 충분하지만, `OutputBuffer.flush()`가 생성하는 ANSI escape sequence가 실제 터미널에서 올바르게 렌더링되는지는 검증하지 못한다. PTY 기반 테스트로 이 간극을 메운다.

## 아키텍처

```
test/pty/
├── pty_test_runner.dart      # PTY 프로세스 관리, 출력 캡처
├── vt100_parser.dart          # ANSI escape → 텍스트 그리드 파서
├── golden_matcher.dart        # 골든 파일 비교 매처
├── pty_test_widgets.dart      # testPtyWidget() 헬퍼
├── examples/                  # 각 위젯별 테스트 앱 진입점
│   ├── text_app.dart
│   ├── button_app.dart
│   └── ...
├── golden/                    # 골든 .txt 파일
│   ├── text_golden.txt
│   └── ...
└── pty_test.dart              # 실제 테스트 파일
```

## 핵심 컴포넌트

### 1. PTY 테스트 러너 (`pty_test_runner.dart`)

`package:pty`의 `PseudoTerminal`로 Dart 예제 앱 스크립트를 PTY 환경에서 실행.

```dart
class PtyTestRunner {
  PtyTestRunner({this.width = 80, this.height = 24});

  final int width;
  final int height;

  Future<List<String>> runExample(String examplePath);
}
```

- PTY 크기 80x24로 고정 (테스트 일관성)
- 예제 앱에 `--pty-test` 플래그 전달
- 프로세스 종료 후 전체 ANSI 출력 캡처
- 타임아웃(5초)으로 무한 실행 방지

### 2. VT100 파서 (`vt100_parser.dart`)

캡처한 ANSI 출력을 80x24 텍스트 그리드로 파싱.

```dart
class Vt100Parser {
  Vt100Parser({this.width = 80, this.height = 24});

  List<String> parse(String ansiOutput);
}
```

지원 CSI 시퀀스:
- `\x1b[H` / `\x1b[row;colH` — 커서 이동
- `\x1b[J` / `\x1b[2J` — 화면 지우기
- `\x1b[K` — 라인 지우기
- `\x1b[...m` — SGR (스타일, 현재 텍스트 검증에서 제외)
- `\x1b[?25l` / `\x1b[?25h` — 커서 표시/숨기기

### 3. 골든 매처 (`golden_matcher.dart`)

```dart
Matcher matchesGoldenFile(String goldenPath);
```

- `--update-goldens` 플래그 시 골든 파일 자동 생성/업데이트
- 비교 시 라인 단위 diff 출력
- 골든 파일은 `test/pty/golden/` 디렉토리에 `.txt` 형식 저장

### 4. 예제 앱 (`examples/`)

각 예제 앱의 구조:

```dart
import 'package:radartui/radartui.dart';

void main(List<String> args) {
  final isPtyTest = args.contains('--pty-test');
  final binding = AppBinding.ensureInitialized();
  binding.attachRootWidget(MyWidget());

  if (isPtyTest) {
    binding.renderFrame();
    // 렌더링 완료 후 즉시 종료
    exit(0);
  } else {
    binding.runApp();
  }
}
```

### 5. 테스트 작성 패턴

```dart
import 'package:test/test.dart';
import 'pty_test_widgets.dart';

void main() {
  group('PTY Golden Tests', () {
    testPtyWidget(
      'Text renders correctly',
      example: 'text_app.dart',
      golden: 'text_golden.txt',
    );

    testPtyWidget(
      'Button renders correctly',
      example: 'button_app.dart',
      golden: 'button_golden.txt',
    );
  });
}
```

## 데이터 흐름

```
dart test test/pty/pty_test.dart
  → testPtyWidget() 호출
  → PtyTestRunner.runExample() 실행
    → PseudoTerminal.start('dart', ['run', 'test/pty/examples/text_app.dart', '--pty-test'])
    → PTY 크기 80x24 설정
    → pty.out 스트림에서 출력 수집
    → 프로세스 종료 대기 (최대 5초 타임아웃)
  → Vt100Parser.parse() 실행
    → ANSI 시퀀스 파싱 → 80x24 텍스트 그리드 변환
  → matchesGoldenFile() 비교
    → 골든 파일 읽기
    → 파싱된 그리드와 골든 비교
    → 불일치 시 diff 출력
```

## 예제 앱 자동 종료 전략

예제 앱은 `--pty-test` 플래그 수신 시:
1. `AppBinding.ensureInitialized()` 초기화
2. 위젯 트리 구성
3. 1프레임 렌더링 (`renderFrame()`)
4. `exit(0)` 즉시 종료

이를 위해 `AppBinding`에 `renderFrame()` 메서드 추가 필요:
- `attachRootWidget(Widget)` — 루트 위젯 설정 (runApp 없이)
- `renderFrame()` — 단일 프레임 빌드/레이아웃/페인트/플러시 실행

## 의존성

```yaml
dev_dependencies:
  pty: ^0.2.2-pre
```

## 제약사항

- Linux/macOS에서만 동작 (Windows는 `package:pty` JIT 모드에서 크래시)
- CI 환경에서 PTY 지원 필요 (GitHub Actions ubuntu-latest는 기본 지원)
- 테스트 실행이 `TestBinding` 테스트보다 느림 (프로세스 생성 오버헤드)
- 스타일(색상, 볼드 등)은 첫 구현에서 제외, 텍스트 그리드만 검증
