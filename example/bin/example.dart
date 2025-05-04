import 'package:radartui/radartui.dart';
import 'package:radartui/widget/expnaded.dart';
import 'package:radartui/widget/focus_manager.dart';
import 'package:radartui/widget/row.dart';
import 'package:radartui/widget/text_field.dart';

void main(List<String> arguments) {
  Radartui.runApp(
    Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Card(
                child: Card(
                  child: ListView(items: ["1234567890", "234", "4567"]),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Card(
                child: Card(
                  child: ListView(items: ["1234567890", "234", "4567"]),
                ),
              ),
            ),
          ],
        ),
        Card(child: TextField()),
      ],
    ),
    onKey: (key) {
      switch (key.label) {
        case "q":
          if (key.ctrl) {
            Radartui.exitApp();
          }
          break;
        case "\t": // 탭키 누르면
          FocusManager.instance.focusNext();
          break;
        case '\x1b[Z': // shift + tab 은 보통 ESC [ Z 시퀀스
          FocusManager.instance.focusPrevious();
          break;
      }
      FocusManager.instance.onKey(key);
    },
  );
}
