import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const Stack(
      children: [
        Positioned(left: 0, top: 0, child: Text('BG')),
        Positioned(left: 5, top: 1, child: Text('FG')),
      ],
    ),
    args,
  );
}
