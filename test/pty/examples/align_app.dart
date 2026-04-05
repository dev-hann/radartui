import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const Align(alignment: Alignment.centerRight, child: Text('Right')),
    args,
  );
}
