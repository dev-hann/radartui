import 'package:radartui/radartui.dart';
import 'package:radartui/widget/focus_manager.dart';
import 'package:radartui/widget/row.dart';

void main(List<String> arguments) {
  Radartui.runApp(
    Card(
      child: Row(
        children: [
          Card(
            child: Card(child: ListView(items: ["1234567890", "234", "4567"])),
          ),
          Card(child: ListView(items: ["1234567890", "234", "4567"])),
        ],
      ),
    ),
    onKey: (key) {
      switch (key.label) {
        case "q":
          Radartui.exitApp();
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
