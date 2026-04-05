import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(const SizedBox(width: 15, height: 3, child: Text('Sized')), args);
}
