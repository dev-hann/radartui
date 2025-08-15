## 📁 lib/src/widgets

이 디렉토리는 개발자가 UI를 구축하기 위해 직접 사용하는 위젯과 관련된 핵심 클래스들을 포함합니다. 선언적 UI 패러다임의 기반이 됩니다.

### 주요 파일 및 디렉토리

- **`framework.dart`**: `Widget`, `Element`, `State` 등 위젯 시스템의 가장 근간이 되는 추상 클래스들을 정의합니다. 위젯의 생명주기와 엘리먼트 트리 관리를 담당합니다.
- **`basic.dart`**: `basic/` 디렉토리에 있는 모든 구체적인 위젯들을 외부에 노출(`export`)하는 역할을 합니다.
- **`focus_manager.dart`**: UI 내에서 키보드 포커스를 관리하고 위젯 간 포커스 이동을 처리하는 로직을 담고 있습니다.
- **`navigation.dart`**: 화면(Route) 간의 전환을 관리하는 `Navigator` 위젯 관련 로직을 포함합니다.
- **`navigator_observer.dart`**: `Navigator`의 상태 변화(push, pop 등)를 감지하고 콜백을 실행하는 옵저버 클래스를 정의합니다.
- **`basic/`**: `Text`, `Container`, `Row`, `Column` 등 실제로 UI를 구성하는 데 사용되는 구체적인 위젯 클래스들이 구현되어 있는 디렉토리입니다.
