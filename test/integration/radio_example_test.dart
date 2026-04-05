import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

class _RadioTestApp extends StatefulWidget {
  const _RadioTestApp();

  @override
  State<_RadioTestApp> createState() => _RadioTestAppState();
}

class _RadioTestAppState extends State<_RadioTestApp> {
  String _selectedValue = 'option1';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          Row(children: [
            Radio<String>(
              value: 'option1',
              groupValue: _selectedValue,
              onChanged: (v) {
                setState(() {
                  _selectedValue = v ?? 'option1';
                });
              },
            ),
            const SizedBox(width: 2),
            const Text('Option 1'),
          ]),
          Row(children: [
            Radio<String>(
              value: 'option2',
              groupValue: _selectedValue,
              onChanged: (v) {
                setState(() {
                  _selectedValue = v ?? 'option1';
                });
              },
            ),
            const SizedBox(width: 2),
            const Text('Option 2'),
          ]),
          Row(children: [
            Radio<String>(
              value: 'option3',
              groupValue: _selectedValue,
              onChanged: (v) {
                setState(() {
                  _selectedValue = v ?? 'option1';
                });
              },
            ),
            const SizedBox(width: 2),
            const Text('Option 3'),
          ]),
          const SizedBox(height: 1),
          Text('Selected: $_selectedValue'),
        ],
      ),
    );
  }
}

void main() {
  group('Radio example scenario', () {
    testWidgets('initial render shows option1 selected with focus',
        (tester) async {
      tester.pumpWidget(const _RadioTestApp());
      await tester.pumpAndSettle();

      // Row 2 (y=2): Radio 1 at x=2, selected (●), focused (blue border)
      tester.assertCellAt(2, 2, '(');
      tester.assertCellAt(3, 2, '\u25CF');
      tester.assertCellAt(4, 2, ')');
      tester.assertForegroundColor(2, 2, Color.blue);
      tester.assertForegroundColor(4, 2, Color.blue);

      // Row 3 (y=3): Radio 2 at x=2, unselected, unfocused (white border)
      tester.assertCellAt(2, 3, '(');
      tester.assertCellAt(3, 3, ' ');
      tester.assertCellAt(4, 3, ')');
      tester.assertForegroundColor(2, 3, Color.white);
      tester.assertForegroundColor(4, 3, Color.white);

      // Row 4 (y=4): Radio 3 at x=2, unselected, unfocused
      tester.assertCellAt(2, 4, '(');
      tester.assertCellAt(4, 4, ')');
      tester.assertForegroundColor(2, 4, Color.white);

      tester.assertContains('Selected: option1');
    });

    testWidgets('Tab moves focus from Radio 1 to Radio 2 visually',
        (tester) async {
      tester.pumpWidget(const _RadioTestApp());
      await tester.pumpAndSettle();

      // Initially Radio 1 focused (blue border)
      tester.assertForegroundColor(2, 2, Color.blue);
      tester.assertForegroundColor(2, 3, Color.white);

      tester.sendTab();
      await tester.pumpAndSettle();

      // Radio 1 loses focus (white border), Radio 2 gains focus (blue border)
      tester.assertForegroundColor(2, 2, Color.white);
      tester.assertForegroundColor(4, 2, Color.white);
      tester.assertForegroundColor(2, 3, Color.blue);
      tester.assertForegroundColor(4, 3, Color.blue);

      // Selection unchanged — option1 still selected
      tester.assertCellAt(3, 2, '\u25CF');
      tester.assertCellAt(3, 3, ' ');
      tester.assertContains('Selected: option1');
    });

    testWidgets('Tab twice moves focus to Radio 3', (tester) async {
      tester.pumpWidget(const _RadioTestApp());
      await tester.pumpAndSettle();

      tester.sendTab();
      await tester.pumpAndSettle();

      tester.sendTab();
      await tester.pumpAndSettle();

      tester.assertForegroundColor(2, 2, Color.white);
      tester.assertForegroundColor(2, 3, Color.white);
      tester.assertForegroundColor(2, 4, Color.blue);
      tester.assertForegroundColor(4, 4, Color.blue);
    });

    testWidgets('Tab wraps around back to Radio 1', (tester) async {
      tester.pumpWidget(const _RadioTestApp());
      await tester.pumpAndSettle();

      tester.sendTab();
      await tester.pumpAndSettle();
      tester.sendTab();
      await tester.pumpAndSettle();
      tester.sendTab();
      await tester.pumpAndSettle();

      tester.assertForegroundColor(2, 2, Color.blue);
      tester.assertForegroundColor(2, 3, Color.white);
      tester.assertForegroundColor(2, 4, Color.white);
    });

    testWidgets('Space on focused Radio 2 changes selection', (tester) async {
      tester.pumpWidget(const _RadioTestApp());
      await tester.pumpAndSettle();

      // Tab to Radio 2
      tester.sendTab();
      await tester.pumpAndSettle();

      // Select Radio 2
      tester.sendSpace();
      await tester.pumpAndSettle();

      // Radio 1: unselected, unfocused (white border)
      tester.assertCellAt(3, 2, ' ');
      tester.assertForegroundColor(2, 2, Color.white);

      // Radio 2: selected, focused (blue border, indicator ●)
      tester.assertCellAt(3, 3, '\u25CF');
      tester.assertForegroundColor(2, 3, Color.blue);
      tester.assertForegroundColor(4, 3, Color.blue);

      // Radio 3: unselected, unfocused
      tester.assertCellAt(3, 4, ' ');
      tester.assertForegroundColor(2, 4, Color.white);

      // Status text updated
      tester.assertContains('Selected: option2');
    });

    testWidgets('full sequence: Tab→Space→Tab→Space→verify', (tester) async {
      tester.pumpWidget(const _RadioTestApp());
      await tester.pumpAndSettle();

      // Initial: Radio 1 selected and focused
      tester.assertCellAt(3, 2, '\u25CF');
      tester.assertForegroundColor(2, 2, Color.blue);

      // Tab to Radio 2, select it
      tester.sendTab();
      await tester.pumpAndSettle();
      tester.sendSpace();
      await tester.pumpAndSettle();

      tester.assertCellAt(3, 2, ' ');
      tester.assertCellAt(3, 3, '\u25CF');
      tester.assertContains('Selected: option2');

      // Tab to Radio 3, select it
      tester.sendTab();
      await tester.pumpAndSettle();
      tester.sendSpace();
      await tester.pumpAndSettle();

      tester.assertCellAt(3, 3, ' ');
      tester.assertCellAt(3, 4, '\u25CF');
      tester.assertForegroundColor(2, 4, Color.blue);
      tester.assertContains('Selected: option3');

      // Tab wraps to Radio 1, select it
      tester.sendTab();
      await tester.pumpAndSettle();
      tester.sendSpace();
      await tester.pumpAndSettle();

      tester.assertCellAt(3, 2, '\u25CF');
      tester.assertCellAt(3, 4, ' ');
      tester.assertContains('Selected: option1');
    });

    testWidgets('Shift+Tab goes backwards', (tester) async {
      tester.pumpWidget(const _RadioTestApp());
      await tester.pumpAndSettle();

      // Radio 1 focused
      tester.assertForegroundColor(2, 2, Color.blue);

      // Shift+Tab wraps to Radio 3
      tester.sendShiftTab();
      await tester.pumpAndSettle();

      tester.assertForegroundColor(2, 2, Color.white);
      tester.assertForegroundColor(2, 4, Color.blue);
    });

    testWidgets('Enter key also selects Radio', (tester) async {
      tester.pumpWidget(const _RadioTestApp());
      await tester.pumpAndSettle();

      // Tab to Radio 2
      tester.sendTab();
      await tester.pumpAndSettle();

      // Enter to select
      tester.sendEnter();
      await tester.pumpAndSettle();

      tester.assertCellAt(3, 3, '\u25CF');
      tester.assertContains('Selected: option2');
    });

    testWidgets('selected Radio background uses activeColor', (tester) async {
      tester.pumpWidget(const _RadioTestApp());
      await tester.pumpAndSettle();

      // Radio 1 is selected and focused
      // Background of center cell should be blue (activeColor)
      tester.assertBackgroundColor(3, 2, Color.blue);

      // Radio 2 is unselected, background should be black (activeColor tween at 0)
      tester.assertBackgroundColor(3, 3, Color.black);
    });

    testWidgets('selecting different Radio changes backgrounds correctly',
        (tester) async {
      tester.pumpWidget(const _RadioTestApp());
      await tester.pumpAndSettle();

      // Initially Radio 1 has blue bg (selected)
      tester.assertBackgroundColor(3, 2, Color.blue);

      // Tab to Radio 2 and select
      tester.sendTab();
      await tester.pumpAndSettle();
      tester.sendSpace();
      await tester.pumpAndSettle();

      // Radio 1: deselected, bg fades to black
      tester.assertBackgroundColor(3, 2, Color.black);
      // Radio 2: selected, bg is blue
      tester.assertBackgroundColor(3, 3, Color.blue);
    });
  });
}
