import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Hello ',
            style: TextStyle(color: Color.red),
          ),
          TextSpan(text: 'World', style: TextStyle(bold: true)),
        ],
      ),
    ),
    args,
  );
}
