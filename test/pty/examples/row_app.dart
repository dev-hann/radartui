import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const Row(
      children: [
        Text('A'),
        Text('B'),
        Text('C'),
      ],
    ),
    args,
  );
}
