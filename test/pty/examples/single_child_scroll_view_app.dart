import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const SingleChildScrollView(
      child: Column(children: [Text('Line 1'), Text('Line 2'), Text('Line 3')]),
    ),
    args,
  );
}
