# RadarTUI: A Flutter-Inspired TUI Framework for Dart

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Dart](https://img.shields.io/badge/Platform-Dart-blue.svg)](https://dart.dev)
[![Style: effective_dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://dart.dev/guides/language/effective-dart)

**RadarTUI는 Dart를 사용하여 아름답고 반응성이 뛰어난 터미널 사용자 인터페이스(TUI)를 구축하기 위한 플러터 스타일의 프레임워크입니다.** 복잡한 터미널 애플리케이션을 선언적 위젯 패러다임으로 손쉽게 개발하세요.

---

## 🎯 주요 특징

- **✨ 선언적 UI**: 상태가 변경되면 UI가 자동으로 업데이트되는 플러터와 유사한 위젯 트리 구조.
- **📦 풍부한 위젯 라이브러리**: `Row`, `Column`, `Text`, `Container`, `Button`, `TextField` 등 필수적인 레이아웃 및 UI 위젯 제공.
- **⚡️ 효율적인 렌더링**: 변경된 부분만 다시 그리는 지능적인 Diff 기반의 터미널 렌더링 최적화.
- **⌨️ 유연한 입력 처리**: 키보드 이벤트를 손쉽게 처리하고 애플리케이션 상태와 상호작용.
- **🎨 유연한 레이아웃 시스템**: Flexbox 기반의 강력한 레이아웃 위젯으로 복잡한 UI도 손쉽게 구성.
- **🧭 직관적인 상태 관리**: `StatelessWidget`과 `StatefulWidget` 패턴을 통한 명확하고 예측 가능한 상태 관리.

## 🏗️ 아키텍처

RadarTUI는 플러터에서 영감을 받은 계층적 아키텍처를 따릅니다. 각 계층은 명확하게 분리된 역할을 수행하여 코드의 유지보수성과 확장성을 높입니다.

```
┌──────────────────────────┐
│     Application Layer    │ (사용자 애플리케이션)
├──────────────────────────┤
│       Widgets Layer      │ (선언적 UI 위젯)
├──────────────────────────┤
│      Scheduler Layer     │ (프레임 스케줄링 및 라이프사이클)
├──────────────────────────┤
│      Rendering Layer     │ (레이아웃 및 페인팅)
├──────────────────────────┤
│       Services Layer     │ (터미널 제어, 입출력)
├──────────────────────────┤
│      Foundation Layer    │ (기본 데이터 타입)
└──────────────────────────┘
```

더 자세한 아키텍처 정보는 [GEMINI.md](GEMINI.md) 문서를 참고하세요.

## 🚀 시작하기

### 1. 의존성 추가

`pubspec.yaml` 파일에 RadarTUI를 추가합니다.

```yaml
dependencies:
  radartui:
    path: ../ # 또는 pub.dev 버전 명시
```

### 2. 기본 예제 코드

간단한 카운터 애플리케이션 예제입니다.

```dart
import 'package:radartui/radartui.dart';

void main() {
  runApp(const CounterApp());
}

class CounterApp extends StatefulWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = SchedulerBinding.instance.keyboard.keyEvents.listen((event) {
      if (event.key == 'q') {
        shutdown();
      } else {
        setState(() {
          _counter++;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '키를 눌러 카운트를 올려보세요: $_counter\n\'q\'를 누르면 종료됩니다.',
        style: const TextStyle(color: AnsiColor.green),
      ),
    );
  }
}
```

## 📦 예제 실행 방법

프로젝트에 포함된 다양한 예제를 실행하여 RadarTUI의 기능을 확인해 보세요.

1.  `example` 디렉토리로 이동합니다.

    ```sh
    cd example
    ```

2.  의존성을 설치합니다.

    ```sh
    dart pub get
    ```

3.  원하는 예제를 실행합니다. (예: `main.dart`는 여러 예제를 선택할 수 있는 메뉴를 제공합니다)
    ```sh
    dart run
    ```

## 🗺️ 로드맵

RadarTUI는 지속적으로 발전하고 있으며, 다음과 같은 기능들을 계획하고 있습니다.

- [ ] **애니메이션 시스템**: 상태 변화에 따른 부드러운 시각적 전환 효과.
- [ ] **포커스 관리 시스템**: 위젯 간 키보드 네비게이션 및 포커스 제어.
- [ ] **테마 시스템**: 애플리케이션 전반의 색상과 스타일을 중앙에서 관리.
- [ ] **위젯 테스트 프레임워크**: TUI 애플리케이션을 위한 테스트 유틸리티.
- [ ] **고급 레이아웃 위젯**: `Grid`, `Stack`, `ListView` 등 더 다양한 레이아웃 옵션.

## 🤝 기여하기

RadarTUI에 기여하는 것을 환영합니다! 버그 리포트, 기능 제안, 코드 기여 등 어떤 형태의 참여든 좋습니다.

기여를 시작하기 전에 [GEMINI.md](GEMINI.md) 아키텍처 문서를 읽어보시면 프로젝트의 구조를 이해하는 데 큰 도움이 됩니다.

## 📜 라이선스

RadarTUI는 [MIT 라이선스](LICENSE)에 따라 배포됩니다.
