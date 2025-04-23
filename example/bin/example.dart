import 'package:radartui/radartui.dart';
import 'package:radartui/widget/focus_manager.dart';

void main(List<String> arguments) {
  Radartui.runApp(
    Card(child: ListView(items: ["1234567890", "234", "4567"])),

    onKey: (key) {
      switch (key.label) {
        case "q":
          Radartui.exitApp();
          break;
        // case "\t":
        //   FocusManager.instance.focusNext();
        //   break;
      }
      print("example.onKey :${key.type}");
      FocusManager.instance.onKey(key);
    },
  );
}
