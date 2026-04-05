import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(const Toggle(value: true, label: 'Enabled'), args);
}
