import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const Row(
      children: [
        Expanded(child: Text('Left')),
        Text('Right'),
      ],
    ),
    args,
  );
}
