import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('FocusableState', () {
    testWidgets('creates owned FocusNode when none provided', (tester) async {
      tester.pumpWidget(const _TestFocusableWidget());

      expect(tester.state<_TestFocusableState>()!.focusNode, isNotNull);
    });

    testWidgets('uses provided FocusNode', (tester) async {
      final externalNode = FocusNode();
      addTearDown(() => externalNode.dispose());

      final widget = _TestFocusableWidget(focusNode: externalNode);
      tester.pumpWidget(widget);

      expect(
        tester.state<_TestFocusableState>()!.focusNode,
        same(externalNode),
      );
    });

    testWidgets('hasFocus is true for first registered node', (tester) async {
      tester.pumpWidget(const _TestFocusableWidget());

      final state = tester.state<_TestFocusableState>()!;
      expect(state.hasFocus, isTrue);
    });

    testWidgets('handles FocusNode change on didUpdateWidget', (tester) async {
      final node1 = FocusNode();
      final node2 = FocusNode();
      addTearDown(() {
        node1.dispose();
        node2.dispose();
      });

      tester.pumpWidget(_TestFocusableWidget(focusNode: node1));
      expect(tester.state<_TestFocusableState>()!.focusNode, same(node1));

      tester.pumpWidget(_TestFocusableWidget(focusNode: node2));
      expect(tester.state<_TestFocusableState>()!.focusNode, same(node2));
    });

    testWidgets('creates new FocusNode when provided becomes null', (
      tester,
    ) async {
      final externalNode = FocusNode();
      addTearDown(() => externalNode.dispose());

      tester.pumpWidget(_TestFocusableWidget(focusNode: externalNode));
      final ownedNode = tester.state<_TestFocusableState>()!.focusNode;
      expect(ownedNode, same(externalNode));

      tester.pumpWidget(const _TestFocusableWidget());
      final newNode = tester.state<_TestFocusableState>()!.focusNode;
      expect(newNode, isNot(same(externalNode)));
    });

    testWidgets('onKeyEvent receives key events when focused', (tester) async {
      KeyEvent? receivedEvent;
      tester.pumpWidget(
        _TestFocusableWidget(
          onKeyEvent: (event) {
            receivedEvent = event;
          },
        ),
      );
      await tester.pumpAndSettle();

      tester.sendKeyEvent(const KeyEvent(code: KeyCode.enter));
      await tester.pumpAndSettle();

      expect(receivedEvent, isNotNull);
      expect(receivedEvent!.code, equals(KeyCode.enter));
    });

    testWidgets('rebuilds on focus change', (tester) async {
      int buildCount = 0;
      tester.pumpWidget(_TestFocusableWidget(onBuild: () => buildCount++));

      buildCount = 0;

      final state = tester.state<_TestFocusableState>()!;
      state.focusNode.requestFocus();
      tester.pump();

      expect(buildCount, greaterThanOrEqualTo(1));
    });
  });
}

class _TestFocusableWidget extends StatefulWidget {
  const _TestFocusableWidget({this.focusNode, this.onKeyEvent, this.onBuild});

  final FocusNode? focusNode;
  final void Function(KeyEvent)? onKeyEvent;
  final void Function()? onBuild;

  @override
  State<_TestFocusableWidget> createState() => _TestFocusableState();
}

class _TestFocusableState extends State<_TestFocusableWidget>
    with FocusableState<_TestFocusableWidget> {
  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void onKeyEvent(KeyEvent event) {
    widget.onKeyEvent?.call(event);
  }

  @override
  Widget build(BuildContext context) {
    widget.onBuild?.call();
    return SizedBox(
      width: 10,
      height: 1,
      child: hasFocus ? const Text('focused') : const Text('unfocused'),
    );
  }
}
