import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

void main(List<String> args) {
  runPtyApp(
    const Form(
      child: Column(
        children: [
          TextFormField(placeholder: 'Enter name'),
        ],
      ),
    ),
    args,
  );
}
