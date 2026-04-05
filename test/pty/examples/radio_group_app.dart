import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const Column(
      children: [
        Radio<String>(value: 'a', groupValue: 'a', onChanged: null),
        Radio<String>(value: 'b', groupValue: 'a', onChanged: null),
        Radio<String>(value: 'c', groupValue: 'a', onChanged: null),
      ],
    ),
    args,
  );
}
