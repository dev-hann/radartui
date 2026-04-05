import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const Container(
      width: 20,
      height: 3,
      border: Border.all,
      child: Text('Box'),
    ),
    args,
  );
}
