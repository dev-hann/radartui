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
    final ThemeData theme = _useDarkTheme ? ThemeData.dark : ThemeData.light;

    return Theme(
      data: theme,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            const Container(
              width: 50,
              height: 3,
              color: Color.blue,
              child: Center(
                child: Text(
                  '🎨 Theme & MediaQuery Example',
                  style: TextStyle(color: Color.white, bold: true),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 50,
              color: Color.brightBlack,
              padding: const EdgeInsets.all(2),
              child: Column(
                children: [
                  Text(
                    'Current Theme: ${_useDarkTheme ? "Dark" : "Light"}',
                    style: const TextStyle(color: Color.cyan, bold: true),
                  ),
                  const SizedBox(height: 1),
                  Builder(
                    builder: (BuildContext ctx) {
                      final ThemeData t = Theme.of(ctx);
                      return Column(
                        children: [
                          Text(
                            'primaryColor: ${_colorName(t.primaryColor)}',
                            style: TextStyle(color: t.textColor),
                          ),
                          Text(
                            'backgroundColor: ${_colorName(t.backgroundColor)}',
                            style: TextStyle(color: t.textColor),
                          ),
                          Text(
                            'textColor: ${_colorName(t.textColor)}',
                            style: TextStyle(color: t.textColor),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 50,
              color: Color.brightBlack,
              padding: const EdgeInsets.all(2),
              child: Builder(
                builder: (BuildContext ctx) {
                  final MediaQueryData mq = MediaQuery.maybeOf(ctx);
                  return Column(
                    children: [
                      const Text(
                        'MediaQuery Data:',
                        style: TextStyle(color: Color.cyan, bold: true),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Terminal Size: ${mq.size.width} x ${mq.size.height}',
                        style: const TextStyle(color: Color.white),
                      ),
                      Text(
                        'Padding: ${mq.padding}',
                        style: const TextStyle(color: Color.white),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Press T to toggle theme, ESC to return',
              style: TextStyle(color: Color.yellow, italic: true),
            ),
          ],
        ),
      ),
    );
  }

  String _colorName(Color color) {
    if (color == Color.black) return 'Black';
    if (color == Color.white) return 'White';
    if (color == Color.blue) return 'Blue';
    return 'Custom';
  }
}
