import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(const Dialog(title: 'Confirm', child: Text('Are you sure?')), args);
}
