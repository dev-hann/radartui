import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(const Row(children: [Text('Left'), Spacer(), Text('Right')]), args);
}
