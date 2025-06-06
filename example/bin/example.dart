import 'package:radartui/radartui.dart';
import 'package:radartui/widget/text_field.dart';

void main(List<String> arguments) {
  Radartui.runApp(
    MyView(),
    onKey: (key) {
      switch (key.label) {
        case "q":
          Radartui.exitApp();
          break;
      }
    },
  );
}

class MyView extends StatelessWidget {
  @override
  Widget build() {
    return Column(
      children: [
        Text("Hello"),
        Text("Hello2"),
        Text("Hello3"),
        // TextField(controller: TextEditingController(text: "Hello")),
      ],
    );
  }
}
