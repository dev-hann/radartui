import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const StatusBar(
      left: Text('NORMAL'),
      center: Text('radartui'),
      right: Text('100%'),
      backgroundColor: Color.blue,
    ),
    args,
  );
}
