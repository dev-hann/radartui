import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const Radio<String>(value: 'a', groupValue: 'a', onChanged: null),
    args,
  );
}
