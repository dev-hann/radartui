import 'dart:async';
import 'package:radartui/radartui.dart';

class ThemeExample extends StatefulWidget {
  const ThemeExample();

  @override
  State<ThemeExample> createState() => _ThemeExampleState();
}

class _ThemeExampleState extends State<ThemeExample> {
  bool _useDarkTheme = true;
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription =
        ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.code == KeyCode.escape) {
        Navigator.of(context).pop();
      } else if (key.code == KeyCode.char && key.char == 't') {
        setState(() {
          _useDarkTheme = !_useDarkTheme;
        });
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _useDarkTheme ? ThemeData.dark : ThemeData.light;

    return Theme(
      data: theme,
      child: Builder(
        builder: (context) {
          final currentTheme = Theme.of(context);

          return Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 3,
                  color: currentTheme.primaryColor,
                  child: Center(
                    child: Text(
                      'Theme & MediaQuery Demo',
                      style:
                          TextStyle(color: currentTheme.textColor, bold: true),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: 60,
                  color: currentTheme.backgroundColor,
                  padding: const EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Text(
                        'Current Theme: ${_useDarkTheme ? "Dark" : "Light"}',
                        style: TextStyle(
                            color: currentTheme.textColor, bold: true),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Primary: ${_colorName(currentTheme.primaryColor)}',
                        style: TextStyle(color: currentTheme.textColor),
                      ),
                      Text(
                        'Background: ${_colorName(currentTheme.backgroundColor)}',
                        style: TextStyle(color: currentTheme.textColor),
                      ),
                      Text(
                        'Text: ${_colorName(currentTheme.textColor)}',
                        style: TextStyle(color: currentTheme.textColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: 60,
                  color: Color.brightBlack,
                  padding: const EdgeInsets.all(1),
                  child: Builder(
                    builder: (context) {
                      final mediaQuery = MediaQuery.maybeOf(context);
                      final size = mediaQuery.size;
                      final padding = mediaQuery.padding;

                      return Column(
                        children: [
                          const Text(
                            'MediaQuery Data:',
                            style: TextStyle(color: Color.cyan, bold: true),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'Terminal Size: ${size.width} x ${size.height}',
                            style: const TextStyle(color: Color.white),
                          ),
                          Text(
                            'Padding: $padding',
                            style: const TextStyle(color: Color.white),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: 60,
                  color: currentTheme.primaryColor,
                  padding: const EdgeInsets.all(1),
                  child: Column(
                    children: [
                      Text(
                        'Themed Button:',
                        style: TextStyle(color: currentTheme.textColor),
                      ),
                      const SizedBox(height: 1),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 1),
                        color: currentTheme.selectedColor,
                        child: Text(
                          'Selected',
                          style: TextStyle(color: currentTheme.textColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Container(
                  width: 60,
                  color: Color.yellow,
                  padding: EdgeInsets.all(1),
                  child: Column(
                    children: [
                      Text('Controls:',
                          style: TextStyle(color: Color.black, bold: true)),
                      Text('T: Toggle Theme | ESC: Return',
                          style: TextStyle(color: Color.black)),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Theme propagates down the widget tree',
                  style: TextStyle(color: currentTheme.textColor),
                ),
                Text(
                  'MediaQuery provides screen dimensions',
                  style: TextStyle(color: currentTheme.textColor),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _colorName(Color color) {
    if (color == Color.black) return 'Black';
    if (color == Color.white) return 'White';
    if (color == Color.red) return 'Red';
    if (color == Color.green) return 'Green';
    if (color == Color.blue) return 'Blue';
    if (color == Color.yellow) return 'Yellow';
    if (color == Color.cyan) return 'Cyan';
    if (color == Color.magenta) return 'Magenta';
    return 'Custom';
  }
}
