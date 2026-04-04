import 'dart:async';
import 'package:radartui/radartui.dart';

class RichTextExample extends StatefulWidget {
  const RichTextExample();

  @override
  State<RichTextExample> createState() => _RichTextExampleState();
}

class _RichTextExampleState extends State<RichTextExample> {
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription = ServicesBinding.instance.keyboard.keyEvents.listen((
      key,
    ) {
      if (key.code == KeyCode.escape) {
        Navigator.of(context).pop();
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
    return const Padding(
      padding: EdgeInsets.all(1),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                'RichText & TextSpan Demo',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 1),
          Container(
            width: 60,
            padding: EdgeInsets.all(1),
            color: Color.brightBlack,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Multiple Colors in One Line:',
                  style: TextStyle(bold: true, underline: true),
                ),
                SizedBox(height: 1),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Red ',
                        style: TextStyle(color: Color.red),
                      ),
                      TextSpan(
                        text: 'Green ',
                        style: TextStyle(color: Color.green),
                      ),
                      TextSpan(
                        text: 'Blue ',
                        style: TextStyle(color: Color.blue),
                      ),
                      TextSpan(
                        text: 'Yellow',
                        style: TextStyle(color: Color.yellow),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '2. Style Mixing:',
                  style: TextStyle(bold: true, underline: true),
                ),
                SizedBox(height: 1),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'Bold ', style: TextStyle(bold: true)),
                      TextSpan(text: 'Italic ', style: TextStyle(italic: true)),
                      TextSpan(
                        text: 'Underline ',
                        style: TextStyle(underline: true),
                      ),
                      TextSpan(
                        text: 'All Combined',
                        style: TextStyle(
                          bold: true,
                          italic: true,
                          underline: true,
                          color: Color.magenta,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '3. Syntax Highlighting Example:',
                  style: TextStyle(bold: true, underline: true),
                ),
                SizedBox(height: 1),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Color.white),
                    children: [
                      TextSpan(
                        text: 'void ',
                        style: TextStyle(color: Color.magenta),
                      ),
                      TextSpan(
                        text: 'main',
                        style: TextStyle(color: Color.yellow),
                      ),
                      TextSpan(text: '() {\n'),
                      TextSpan(
                        text: '  final ',
                        style: TextStyle(color: Color.cyan),
                      ),
                      TextSpan(
                        text: 'name ',
                        style: TextStyle(color: Color.blue),
                      ),
                      TextSpan(text: '= '),
                      TextSpan(
                        text: "'RadarTUI'",
                        style: TextStyle(color: Color.green),
                      ),
                      TextSpan(text: ';\n'),
                      TextSpan(
                        text: '  print',
                        style: TextStyle(color: Color.yellow),
                      ),
                      TextSpan(text: '(name);\n'),
                      TextSpan(text: '}'),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '4. Inherited Styles:',
                  style: TextStyle(bold: true, underline: true),
                ),
                SizedBox(height: 1),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Color.cyan),
                    children: [
                      TextSpan(text: 'Parent color (cyan) '),
                      TextSpan(
                        text: 'Child override (red)',
                        style: TextStyle(color: Color.red),
                      ),
                      TextSpan(text: ' Back to parent'),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '5. maxLines with ellipsis:',
                  style: TextStyle(bold: true, underline: true),
                ),
                SizedBox(height: 1),
                SizedBox(
                  width: 40,
                  child: RichText(
                    text: TextSpan(
                      text: 'This is a very long text that will be truncated '
                          'when maxLines is set and overflow is ellipsis.',
                      style: TextStyle(color: Color.white),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            'Press ESC to return to menu',
            style: TextStyle(color: Color.brightYellow, italic: true),
          ),
        ],
      ),
    );
  }
}
