import 'package:radartui/radartui.dart';
import 'src/exports.dart';

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
        '/flex': (context) => const FlexExample(),
        '/stack': (context) => const StackExample(),
        '/spacer': (context) => const SpacerExample(),
        '/gridview': (context) => const GridViewExample(),
        '/style': (context) => const StyleExample(),
        '/richtext': (context) => const RichTextExample(),
        '/icon': (context) => const IconExample(),
        '/divider': (context) => const DividerExample(),
        '/card': (context) => const CardExample(),
        '/sparkline': (context) => const SparklineExample(),
        '/datatable': (context) => const DataTableExample(),
        '/button': (context) => const ButtonExample(),
        '/textfield': (context) => const TextFieldExample(),
        '/checkbox': (context) => const CheckboxExample(),
        '/radio': (context) => const RadioExample(),
        '/toggle': (context) => const ToggleExample(),
        '/slider': (context) => const SliderExample(),
        '/dropdown': (context) => const DropdownButtonExample(),
        '/circularprogress': (context) => const CircularProgressExample(),
        '/linearprogress': (context) => const LinearProgressExample(),
        '/tabbar': (context) => const TabBarExample(),
        '/expansiontile': (context) => const ExpansionTileExample(),
        '/treeview': (context) => const TreeViewExample(),
        '/menubar': (context) => const MenuBarExample(),
        '/dialog': (context) => const DialogExample(),
        '/toast': (context) => const ToastExample(),
        '/statusbar': (context) => const StatusBarExample(),
        '/form': (context) => const FormExample(),
        '/focus': (context) => const FocusExample(),
        '/shortcuts': (context) => const ShortcutsExample(),
        '/async': (context) => const AsyncExample(),
        '/theme': (context) => const ThemeExample(),
        '/defaulttextstyle': (context) => const DefaultTextStyleExample(),
        '/dashboard': (context) => const DashboardExample(),
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
  static const List<String> _exampleTitles = [
    '📐 Align & Center',
    '📏 Flex Layout',
    '📚 Stack Widget',
    '↕️ Spacer & Flexible',
    '🔲 GridView Widget',
    '✨ Text Styling',
    '🎨 RichText Widget',
    '🖼️ Icon Widget',
    '➖ Divider Widget',
    '🃏 Card Widget',
    '📈 Sparkline Widget',
    '📊 DataTable Widget',
    '🔘 Button Widget',
    '⌨️ TextField Widget',
    '☑️ Checkbox Widget',
    '◉ Radio Button',
    '🔀 Toggle Widget',
    '🎚️ Slider Widget',
    '▼ DropdownButton',
    '⏳ CircularProgressIndicator',
    '📊 LinearProgressIndicator',
    '📑 TabBar Example',
    '📂 ExpansionTile Widget',
    '🌳 TreeView Widget',
    '☰ MenuBar Widget',
    '💬 Dialog Widget',
    '🍞 Toast Widget',
    '📟 StatusBar Widget',
    '📝 Form Validation',
    '🎯 Focus Management',
    '⌨️ Shortcuts & Actions',
    '⚡ Async (Future/Stream)',
    '🎨 Theme & MediaQuery',
    '🔤 DefaultTextStyle',
    '💻 System Dashboard',
  ];

  static const List<String> _exampleRoutes = [
    '/align',
    '/flex',
    '/stack',
    '/spacer',
    '/gridview',
    '/style',
    '/richtext',
    '/icon',
    '/divider',
    '/card',
    '/sparkline',
    '/datatable',
    '/button',
    '/textfield',
    '/checkbox',
    '/radio',
    '/toggle',
    '/slider',
    '/dropdown',
    '/circularprogress',
    '/linearprogress',
    '/tabbar',
    '/expansiontile',
    '/treeview',
    '/menubar',
    '/dialog',
    '/toast',
    '/statusbar',
    '/form',
    '/focus',
    '/shortcuts',
    '/async',
    '/theme',
    '/defaulttextstyle',
    '/dashboard',
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
