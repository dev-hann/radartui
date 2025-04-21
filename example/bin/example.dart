import 'package:radartui/radartui.dart';

void main(List<String> arguments) {
  Radartui.runApp(
    Card(
      child: Column(
        children: [
          Text("1234567890"),
          Text("123456789012345678901", textAlign: TextAlign.center),
          // Text("Hello, World!"),
          // Text("Hello, World!2"),
          // Text("Hello, World!311111111123"),
        ],
      ),
    ),

    // Text(
    //   'Hello, World!',
    //   style: Style(
    //     foreground: Color.red(),
    //     background: Color.blue(),
    //     bold: true,
    //     underLine: true,
    //     strikethru: true,
    //   ),
    // ),
    onKey: (key) {
      switch (key) {
        case "q":
          Radartui.exitApp();
      }
    },
  );
}
