import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const Padding(padding: EdgeInsets.all(2), child: Text('Padded')),
    args,
  );
}
