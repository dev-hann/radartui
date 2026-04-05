import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const GridView<String>(
      items: ['A', 'B', 'C', 'D', 'E', 'F'],
      crossAxisCount: 3,
    ),
    args,
  );
}
