import 'package:radartui/radartui.dart';
import 'package:radartui/widget/button.dart';
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
    },
  );
}

class MyApp extends View {
  final controller = TextEditingController(text: "Hello");
  final items = List.generate(10, (index) => "Item $index");
  String text = "Hello";
  @override
  Widget build() {
    return Column(
      children: [
        // Text(text),
        ListView(focusID: 'list_view', items: items),
        Row(
          children: [
            TextField(focusID: 'text_field', controller: controller),
            Button(
              focusID: 'button',
              label: "Send",
              onPressed: () {
                Future.microtask(() {
                  update();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
