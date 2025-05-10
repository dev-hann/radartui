import 'package:radartui/radartui.dart';
import 'package:radartui/widget/button.dart';
import 'package:radartui/widget/expanded.dart';
import 'package:radartui/widget/focus_manager.dart';
import 'package:radartui/widget/row.dart';
import 'package:radartui/widget/text_field.dart';
import 'package:radartui/widget/text_field_controller.dart';
import 'package:radartui/view/view.dart';

void main(List<String> arguments) {
  Radartui.runApp(
    MyApp(),
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

class MyApp extends View {
  final controller = TextEditingController(text: "Hello");
  String text = "1234";
  @override
  Widget build() {
    print("text: $text");
    return Column(
      children: [
        Text(text),
        Card(
          child: Row(
            children: [
              TextField(controller: controller),
              Button(
                label: "Send",
                onPressed: () {
                  print(controller.text);
                  text = controller.text;
                  Future.microtask(() {
                    update();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
