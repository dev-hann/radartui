import 'package:radartui/radartui.dart';
import 'src/align_example.dart';
import 'src/async_example.dart';
import 'src/button_example.dart';
import 'src/card_example.dart';
import 'src/checkbox_example.dart';
import 'src/dialog_example.dart';
import 'src/divider_example.dart';
import 'src/flex_example.dart';
import 'src/focus_example.dart';
import 'src/form_example.dart';
import 'src/grid_view_example.dart';
import 'src/icon_example.dart';
import 'src/radio_example.dart';
import 'src/rich_text_example.dart';
import 'src/spacer_example.dart';
import 'src/spinner_example.dart';
import 'src/stack_example.dart';
import 'src/style_example.dart';
import 'src/textfield_example.dart';
import 'src/theme_example.dart';
import 'src/shortcuts_example.dart';
import 'src/wrap_example.dart';

void main() {
  runApp(const RadarTUIExamplesApp());
}

class RadarTUIExamplesApp extends StatelessWidget {
  const RadarTUIExamplesApp();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/align': (context) => const AlignExample(),
        '/async': (context) => const AsyncExample(),
        '/button': (context) => const ButtonExample(),
        '/card': (context) => const CardExample(),
        '/checkbox': (context) => const CheckboxExample(),
        '/dialog': (context) => const DialogExample(),
        '/divider': (context) => const DividerExample(),
        '/flex': (context) => const FlexExample(),
        '/focus': (context) => const FocusExample(),
        '/form': (context) => const FormExample(),
        '/gridview': (context) => const GridViewExample(),
        '/icon': (context) => const IconExample(),
        '/radio': (context) => const RadioExample(),
        '/richtext': (context) => const RichTextExample(),
        '/spacer': (context) => const SpacerExample(),
        '/spinner': (context) => const SpinnerExample(),
        '/stack': (context) => const StackExample(),
        '/style': (context) => const StyleExample(),
        '/textfield': (context) => const TextFieldExample(),
        '/theme': (context) => const ThemeExample(),
        '/shortcuts': (context) => const ShortcutsExample(),
        '/wrap': (context) => const WrapExample(),
      },
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen();

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<String> _exampleTitles = [
    'Align & Center',
    'Async (Future/Stream)',
    'Button Widget',
    'Card Widget',
    'Checkbox Widget',
    'Dialog Widget',
    'Divider Widget',
    'Flex Layout',
    'Focus Management',
    'Form Validation',
    'GridView Widget',
    'Icon Widget',
    'Radio Button',
    'RichText Widget',
    'Spacer & Flexible',
    'Spinner & Progress',
    'Stack Widget',
    'Text Styling',
    'TextField Widget',
    'Theme & MediaQuery',
    'Shortcuts & Actions',
    'Wrap Widget',
  ];

  final List<String> _exampleRoutes = [
    '/align',
    '/async',
    '/button',
    '/card',
    '/checkbox',
    '/dialog',
    '/divider',
    '/flex',
    '/focus',
    '/form',
    '/gridview',
    '/icon',
    '/radio',
    '/richtext',
    '/spacer',
    '/spinner',
    '/stack',
    '/style',
    '/textfield',
    '/theme',
    '/shortcuts',
    '/wrap',
  ];

  void _onExampleSelected(int index, String item) async {
    await Navigator.of(context).pushNamed(_exampleRoutes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        children: [
          const Container(
            width: 60,
            height: 5,
            color: Color.blue,
            child: Center(
              child: Text(
                'RadarTUI Examples Collection',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                const Text(
                  'Select Example:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                ListView(
                  initialSelectedIndex: 0,
                  items: _exampleTitles,
                  onItemSelected: _onExampleSelected,
                  wrapAroundNavigation: true,
                ),
                const SizedBox(height: 2),
                const Text(
                  'Use Arrow keys to move, Enter to select',
                  style: TextStyle(color: Color.yellow, italic: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
