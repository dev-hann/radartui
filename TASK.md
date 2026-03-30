# RadarTUI Phase 1 작업 명세서

> 병렬 실행 가능한 독립 작업들

---

## 작업 상태 요약

| Task ID | 작업명 | 상태 | 담당자 | 브랜치 |
|---------|--------|------|--------|--------|
| T-001 | IndexedStack | ✅ 완료 | - | feat/indexedstack |
| T-002 | TabBar / TabBarView | ✅ 완료 | - | feat/tabbar |
| T-003 | DropdownButton | ✅ 완료 | - | feat/dropdown |
| T-004 | Shortcuts / Actions | ✅ 완료 | - | feat/shortcuts |
| T-005 | RichText / TextSpan | ✅ 완료 | - | feat/richtext |
| T-006 | DefaultTextStyle | ✅ 완료 | - | feat/defaulttextstyle |
| T-007 | Icon Widget | ✅ 완료 | - | feat/icon |
| T-008 | DataTable | ✅ 완료 | - | feat/datatable |

**범례:** ⬜ 대기 | 🔄 진행중 | ✅ 완료 | ❌ 실패

---

## 병렬 실행 가능 여부

```
T-001 IndexedStack     ─────┐
T-002 TabBar           ◀────┘ (T-001 완료 후 권장, T-001 없이도 가능)
T-003 DropdownButton   ──────── (완전 독립)
T-004 Shortcuts        ──────── (완전 독립)
T-005 RichText         ──────── (완전 독립)
T-006 DefaultTextStyle ◀──────── (T-005와 관련, 독립 실행 가능)
T-007 Icon             ──────── (완전 독립)
T-008 DataTable        ──────── (완전 독립, 가장 복잡)
```

**완전 병렬 실행 가능:** T-001, T-003, T-004, T-005, T-007, T-008 (6개 동시)

---

## T-001: IndexedStack

### 상태
⬜ **대기**

### 개요
인덱스로 자식 위젯을 전환하는 Stack 변형. 탭 네비게이션, 위저드 단계 등에 사용.

### Flutter API 호환
```dart
// Flutter
class IndexedStack extends MultiChildRenderObjectWidget {
  const IndexedStack({
    super.key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.index = 0,
    this.sizing = StackFit.loose,
    super.children,
  });
}
```

### RadarTUI API 설계
```dart
class IndexedStack extends MultiChildRenderObjectWidget {
  const IndexedStack({
    super.key,
    this.index = 0,
    required super.children,
  });
  
  final int index;
}
```

### 구현 파일
| 파일 | 설명 |
|------|------|
| `lib/src/widgets/basic/indexed_stack.dart` | 위젯 + RenderObject |
| `lib/src/widgets/basic.dart` | export 추가 |
| `test/unit/widgets/indexed_stack_test.dart` | 단위 테스트 |
| `test/integration/indexed_stack_test.dart` | 통합 테스트 |
| `example/src/indexed_stack_example.dart` | 예제 |

### 구현 세부사항

1. **IndexedStack Widget**
   - `index` 속성으로 현재 표시할 자식 지정
   - 범위 벗어난 인덱스는 빈 화면 또는 첫 번째 자식

2. **RenderIndexedStack**
   - `performLayout()`: 모든 자식 레이아웃 (성능을 위해 현재 자식만도 가능)
   - `paint()`: `index`에 해당하는 자식만 그림
   - `StackParentData` 재사용

### 검증 기준
- [ ] `dart analyze` 통과
- [ ] 단위 테스트 5개 이상
- [ ] 통합 테스트 3개 이상
- [ ] `dart test` 전체 통과
- [ ] 예제에서 TabBar 없이 인덱스 전환 동작 확인

### 예상 난이도
🟢 **낮음** (Stack 기반, 단순 로직)

---

## T-002: TabBar / TabBarView

### 상태
⬜ **대기**

### 의존성
- T-001 (IndexedStack) 완료 후 권장 (TabBarView 내부에서 IndexedStack 사용)

### 개요
탭 네비게이션 시스템. TabBar로 탭 선택, TabBarView로 내용 표시.

### Flutter API 호환
```dart
// Flutter Material
class TabBar extends StatefulWidget {
  final List<Tab> tabs;
  final TabController? controller;
  // ...
}

class TabBarView extends StatefulWidget {
  final List<Widget> children;
  final TabController? controller;
  // ...
}

class TabController extends ChangeNotifier {
  final int length;
  int get index;
  // ...
}
```

### RadarTUI API 설계
```dart
class TabController extends ChangeNotifier {
  TabController({required this.length, int initialIndex = 0});
  final int length;
  int get index;
  set index(int value);
  int get previousIndex;
}

class TabBar extends StatefulWidget {
  const TabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
  });
  
  final List<String> tabs;  // TUI는 간단하게 문자열 탭
  final TabController? controller;
  final void Function(int)? onTap;
}

class TabBarView extends StatelessWidget {
  const TabBarView({
    super.key,
    required this.children,
    required this.controller,
  });
  
  final List<Widget> children;
  final TabController controller;
}
```

### 구현 파일
| 파일 | 설명 |
|------|------|
| `lib/src/widgets/basic/tab_bar.dart` | TabController, TabBar, TabBarView |
| `lib/src/widgets/basic.dart` | export 추가 |
| `test/unit/widgets/tab_bar_test.dart` | 단위 테스트 |
| `test/integration/tab_bar_test.dart` | 통합 테스트 |
| `example/src/tab_bar_example.dart` | 예제 |

### 구현 세부사항

1. **TabController**
   - `ChangeNotifier` 상속
   - `index` 변경 시 `notifyListeners()` 호출
   - `length`, `previousIndex` 속성

2. **TabBar**
   - 좌/우 화살표로 탭 전환
   - 현재 탭 하이라이트 표시 (`[Tab 1] Tab 2 Tab 3`)
   - FocusNode 사용

3. **TabBarView**
   - 내부적으로 `IndexedStack` 사용
   - TabController 리스닝하여 index 변경 시 rebuild

### 검증 기준
- [ ] `dart analyze` 통과
- [ ] 단위 테스트 8개 이상 (TabController + TabBar + TabBarView)
- [ ] 통합 테스트 5개 이상
- [ ] `dart test` 전체 통과
- [ ] 예제에서 탭 전환 + 내용 전환 동작 확인

### 예상 난이도
🟡 **중간** (상태 관리, IndexedStack 통합)

---

## T-003: DropdownButton

### 상태
⬜ **대기**

### 개요
목록에서 값을 선택하는 드롭다운 위젯. 폼에서 필수적.

### Flutter API 호환
```dart
// Flutter
class DropdownButton<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?)? onChanged;
  // ...
}
```

### RadarTUI API 설계
```dart
class DropdownButton<T> extends StatefulWidget {
  const DropdownButton({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
    this.hint,
    this.enabled = true,
  });
  
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?) onChanged;
  final String? hint;
  final bool enabled;
}

class DropdownMenuItem<T> {
  const DropdownMenuItem({required this.value, required this.child});
  final T value;
  final Widget child;
}
```

### 구현 파일
| 파일 | 설명 |
|------|------|
| `lib/src/widgets/basic/dropdown_button.dart` | DropdownButton, DropdownMenuItem |
| `lib/src/widgets/basic.dart` | export 추가 |
| `test/unit/widgets/dropdown_button_test.dart` | 단위 테스트 |
| `test/integration/dropdown_button_test.dart` | 통합 테스트 |
| `example/src/dropdown_example.dart` | 예제 |

### 구현 세부사항

1. **기본 상태 (닫힘)**
   - 현재 선택된 값 표시 + 화살표 표시 (예: `Option 1 ▼`)
   - Enter/Space로 펼침

2. **펼쳐진 상태**
   - 위에 overlay로 목록 표시 (ListView 사용)
   - 위/아래 화살표로 선택
   - Enter로 선택 확정
   - ESC로 닫기

3. **키보드 네비게이션**
   - FocusNode 사용
   - Tab으로 포커스 이동 시 닫힘

### 검증 기준
- [ ] `dart analyze` 통과
- [ ] 단위 테스트 6개 이상
- [ ] 통합 테스트 4개 이상
- [ ] `dart test` 전체 통과
- [ ] 예제에서 열기/선택/닫기 동작 확인

### 예상 난이도
🟡 **중간** (overlay 상태 관리)

---

## T-004: Shortcuts / Actions

### 상태
⬜ **대기**

### 개요
키보드 단축키 시스템. 위젯 트리 전체에 단축키 매핑.

### Flutter API 호환
```dart
// Flutter
class Shortcuts extends StatefulWidget {
  final Map<ShortcutActivator, Intent> shortcuts;
  final Widget child;
}

class Actions extends StatefulWidget {
  final Map<Type, Action<Intent>> actions;
  final Widget child;
}

class ActionDispatcher {
  Object? invokeAction(Action<Intent> action, Intent intent);
}
```

### RadarTUI API 설계
```dart
class ShortcutActivator {
  const ShortcutActivator({required this.key, this.ctrl, this.alt, this.shift});
  final KeyCode key;
  final bool? ctrl;
  final bool? alt;
  final bool? shift;
  
  bool accepts(KeyEvent event);
}

class Intent {
  const Intent();
}

class Action<T extends Intent> {
  Object? invoke(T intent);
}

class Shortcuts extends StatefulWidget {
  const Shortcuts({
    super.key,
    required this.shortcuts,
    required this.child,
  });
  
  final Map<ShortcutActivator, Intent> shortcuts;
  final Widget child;
}

class Actions extends StatefulWidget {
  const Actions({
    super.key,
    required this.actions,
    required this.child,
  });
  
  final Map<Type, Action> actions;
  final Widget child;
}

class CallbackAction extends Action<Intent> {
  CallbackAction({required this.onInvoke});
  final Object? Function(Intent) onInvoke;
}
```

### 구현 파일
| 파일 | 설명 |
|------|------|
| `lib/src/widgets/basic/shortcuts.dart` | Shortcuts, Actions, Intent, Action |
| `lib/src/widgets/basic.dart` | export 추가 |
| `test/unit/widgets/shortcuts_test.dart` | 단위 테스트 |
| `test/integration/shortcuts_test.dart` | 통합 테스트 |
| `example/src/shortcuts_example.dart` | 예제 |

### 구현 세부사항

1. **ShortcutActivator**
   - KeyCode + modifier 조합
   - `accepts(KeyEvent)` 메서드로 매칭

2. **Shortcuts Widget**
   - InheritedWidget으로 shortcuts 전파
   - 자식의 FocusNode에서 키 이벤트 발생 시 shortcuts 조회

3. **Actions Widget**
   - InheritedWidget으로 actions 전파
   - Intent 타입 → Action 매핑

4. **단축키 처리 흐름**
   ```
   KeyEvent → Shortcuts.lookup() → Intent → Actions.invoke() → Action.invoke()
   ```

### 검증 기준
- [ ] `dart analyze` 통과
- [ ] 단위 테스트 8개 이상
- [ ] 통합 테스트 5개 이상
- [ ] `dart test` 전체 통과
- [ ] 예제에서 Ctrl+S, Ctrl+Q 등 단축키 동작 확인

### 예상 난이도
🟡 **중간** (InheritedWidget, 이벤트 전파)

---

## T-005: RichText / TextSpan

### 상태
⬜ **대기**

### 개요
하나의 텍스트에서 여러 스타일을 적용할 수 있는 기능. 구문 강조, 로그 표시 등에 필수.

### Flutter API 호환
```dart
// Flutter
class RichText extends LeafRenderObjectWidget {
  final InlineSpan text;
}

abstract class InlineSpan {}

class TextSpan extends InlineSpan {
  final String? text;
  final List<InlineSpan>? children;
  final TextStyle? style;
}
```

### RadarTUI API 설계
```dart
class TextSpan {
  const TextSpan({
    this.text,
    this.children,
    this.style,
  });
  
  final String? text;
  final List<TextSpan>? children;
  final TextStyle? style;
  
  String get plainText;  // 모든 텍스트 합친 것
}

class RichText extends LeafRenderObjectWidget {
  const RichText({
    super.key,
    required this.text,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });
  
  final TextSpan text;
  final int? maxLines;
  final TextOverflow overflow;
}
```

### 구현 파일
| 파일 | 설명 |
|------|------|
| `lib/src/widgets/basic/rich_text.dart` | TextSpan, RichText |
| `lib/src/widgets/basic.dart` | export 추가 |
| `test/unit/widgets/rich_text_test.dart` | 단위 테스트 |
| `test/integration/rich_text_test.dart` | 통합 테스트 |
| `example/src/rich_text_example.dart` | 예제 |

### 구현 세부사항

1. **TextSpan**
   - 트리 구조로 중첩 가능
   - `plainText` getter로 전체 텍스트 반환
   - `visitChildren()` 메서드로 순회

2. **RenderRichText**
   - `performLayout()`: 텍스트 렌더링 크기 계산
   - `paint()`: OutputBuffer에 스타일별로 쓰기
   - 각 TextSpan의 style 적용

3. **기존 Text 위젯과 통합**
   - Text 내부적으로 RichText + TextSpan 사용하도록 리팩터링 가능

### 검증 기준
- [ ] `dart analyze` 통과
- [ ] 단위 테스트 8개 이상 (TextSpan 파싱, 스타일 적용)
- [ ] 통합 테스트 4개 이상
- [ ] `dart test` 전체 통과
- [ ] 예제에서 색상/굵기 혼합 텍스트 표시 확인

### 예상 난이도
🟡 **중간** (텍스트 렌더링 로직 변경)

---

## T-006: DefaultTextStyle

### 상태
⬜ **대기**

### 의존성
- T-005 (RichText) 완료 후 권장 (텍스트 스타일 시스템 통합)

### 개요
위젯 서브트리에 기본 텍스트 스타일 적용. 반복적인 스타일 지정 방지.

### Flutter API 호환
```dart
// Flutter
class DefaultTextStyle extends InheritedWidget {
  final TextStyle style;
  final Widget child;
  
  static TextStyle of(BuildContext context);
}
```

### RadarTUI API 설계
```dart
class DefaultTextStyle extends InheritedWidget {
  const DefaultTextStyle({
    super.key,
    required this.style,
    required super.child,
  });
  
  final TextStyle style;
  
  static TextStyle of(BuildContext context);
  
  @override
  bool updateShouldNotify(DefaultTextStyle oldWidget);
}
```

### 구현 파일
| 파일 | 설명 |
|------|------|
| `lib/src/widgets/basic/default_text_style.dart` | DefaultTextStyle |
| `lib/src/widgets/basic.dart` | export 추가 |
| `test/unit/widgets/default_text_style_test.dart` | 단위 테스트 |
| `test/integration/default_text_style_test.dart` | 통합 테스트 |
| `example/src/default_text_style_example.dart` | 예제 |

### 구현 세부사항

1. **DefaultTextStyle Widget**
   - InheritedWidget 상속
   - `of(context)` 정적 메서드
   - `updateShouldNotify()` 구현

2. **Text 위젯 통합**
   - Text 위젯에서 `DefaultTextStyle.of(context)` 조회
   - 명시적 style 없으면 DefaultTextStyle 사용

3. **TextStyle.merge() 추가**
   - 부모 스타일과 병합하는 메서드

### 검증 기준
- [ ] `dart analyze` 통과
- [ ] 단위 테스트 4개 이상
- [ ] 통합 테스트 3개 이상
- [ ] `dart test` 전체 통과
- [ ] 예제에서 중첩 스타일 상속 확인

### 예상 난이도
🟢 **낮음** (InheritedWidget 패턴)

---

## T-007: Icon Widget

### 상태
⬜ **대기**

### 개요
유니코드/브라일 기호를 아이콘으로 표시. TUI에서 시각적 요소 추가.

### Flutter API 호환
```dart
// Flutter
class Icon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
}
```

### RadarTUI API 설계
```dart
class Icon extends StatelessWidget {
  const Icon({
    super.key,
    required this.icon,
    this.color,
  });
  
  final String icon;  // 유니코드 문자열
  final Color? color;
}

class Icons {
  static const String check = '✓';
  static const String cross = '✗';
  static const String arrowRight = '→';
  static const String arrowLeft = '←';
  static const String arrowUp = '↑';
  static const String arrowDown = '↓';
  static const String folder = '📁';
  static const String file = '📄';
  // ...
}
```

### 구현 파일
| 파일 | 설명 |
|------|------|
| `lib/src/widgets/basic/icon.dart` | Icon, Icons |
| `lib/src/widgets/basic.dart` | export 추가 |
| `test/unit/widgets/icon_test.dart` | 단위 테스트 |
| `test/integration/icon_test.dart` | 통합 테스트 |
| `example/src/icon_example.dart` | 예제 |

### 구현 세부사항

1. **Icon Widget**
   - 단순히 Text 위젯 래핑
   - color 적용

2. **Icons 클래스**
   - 유니코드 아이콘 상수 모음
   - Nerd Font 지원 아이콘 포함 (선택)
   - ASCII 대안도 제공

3. **터미널 호환성**
   - 기본 ASCII 문자 대안 (`>`, `<`, `*` 등)
   - 유니코드 미지원 터미널 고려

### 검증 기준
- [ ] `dart analyze` 통과
- [ ] 단위 테스트 3개 이상
- [ ] 통합 테스트 2개 이상
- [ ] `dart test` 전체 통과
- [ ] 예제에서 다양한 아이콘 표시 확인

### 예상 난이도
🟢 **낮음** (단순 위젯)

---

## T-008: DataTable

### 상태
⬜ **대기**

### 개요
정렬, 스크롤 가능한 데이터 테이블. TUI 앱에서 데이터 표시에 필수.

### Flutter API 호환
```dart
// Flutter
class DataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  // ...
}

class DataColumn {
  final Widget label;
  final bool numeric;
  final VoidCallback? onSort;
}
```

### RadarTUI API 설계
```dart
class DataColumn {
  const DataColumn({
    required this.label,
    this.numeric = false,
    this.onSort,
  });
  
  final String label;
  final bool numeric;
  final void Function(int columnIndex, bool ascending)? onSort;
}

class DataRow {
  const DataRow({
    required this.cells,
    this.onSelectChanged,
    this.selected = false,
  });
  
  final List<DataCell> cells;
  final void Function(bool selected)? onSelectChanged;
  final bool selected;
}

class DataCell {
  const DataCell(this.value);
  final String value;
}

class DataTable extends StatefulWidget {
  const DataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
  });
  
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int? sortColumnIndex;
  final bool sortAscending;
  final VoidCallback? onSelectAll;
}
```

### 구현 파일
| 파일 | 설명 |
|------|------|
| `lib/src/widgets/basic/data_table.dart` | DataColumn, DataRow, DataCell, DataTable |
| `lib/src/widgets/basic.dart` | export 추가 |
| `test/unit/widgets/data_table_test.dart` | 단위 테스트 |
| `test/integration/data_table_test.dart` | 통합 테스트 |
| `example/src/data_table_example.dart` | 예제 |

### 구현 세부사항

1. **레이아웃**
   - 열 너비 자동 계산 (최대 셀 너비 기준) 또는 고정
   - 가로 스크롤 (열이 많을 때)
   - 세로 스크롤 (ListView 활용)

2. **헤더**
   - 컬럼 라벨 표시
   - 정렬 표시 (`▲` / `▼`)
   - 정렬 가능한 컬럼은 Enter로 정렬 토글

3. **행 선택**
   - 위/아래 화살표로 행 이동
   - Space로 행 선택/해제
   - 다중 선택 지원

4. **렌더링**
   - 선택된 행 하이라이트
   - 홀수/짝수 행 구분 (선택)

### 검증 기준
- [ ] `dart analyze` 통과
- [ ] 단위 테스트 10개 이상
- [ ] 통합 테스트 6개 이상
- [ ] `dart test` 전체 통과
- [ ] 예제에서 정렬, 선택, 스크롤 동작 확인

### 예상 난이도
🔴 **높음** (복잡한 레이아웃, 스크롤, 상태 관리)

---

## 작업 실행 가이드

### 1. Worktree 생성
```bash
git worktree add ../.worktrees/<branch> -b <branch>
```

### 2. 각 작업별 브랜치 명명 규칙
| Task ID | 브랜치명 |
|---------|----------|
| T-001 | `feat/indexedstack` |
| T-002 | `feat/tabbar` |
| T-003 | `feat/dropdown` |
| T-004 | `feat/shortcuts` |
| T-005 | `feat/richtext` |
| T-006 | `feat/defaulttextstyle` |
| T-007 | `feat/icon` |
| T-008 | `feat/datatable` |

### 3. 각 작업 완료 후 체크리스트
- [ ] `dart analyze` 통과
- [ ] `dart test` 전체 통과
- [ ] Example 추가
- [ ] PR 생성
- [ ] 머지
- [ ] Worktree 정리

### 4. 진행 상황 업데이트
작업 시작/완료 시 이 문서의 상태 업데이트:
- ⬜ → 🔄 (시작)
- 🔄 → ✅ (완료)
- 🔄 → ❌ (실패/블로킹)

---

## 완료 기록

| 날짜 | Task ID | PR | 비고 |
|------|---------|-----|------|
| 2026-03-31 | GridView | #3 | 완료 |
| 2026-03-31 | RichText / TextSpan | #4 | 완료 |
| 2026-03-31 | Shortcuts / Actions | #5 | 완료 |
| 2026-03-31 | Icon Widget | #6 | 완료 |
| 2026-03-31 | DefaultTextStyle | #7 | 완료 |
| 2026-03-31 | IndexedStack | #8 | 완료 |
| 2026-03-31 | DataTable | #9 | 완료 |
| 2026-03-31 | DropdownButton | #10 | 완료 |
| 2026-03-31 | TabBar / TabBarView | #11 | 완료 |
