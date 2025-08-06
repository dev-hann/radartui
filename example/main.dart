
import 'package:radartui/radartui.dart';

void main() {
  // This is the entry point of the example application.
  runApp(const MyApp());
}

/// The root widget of the example application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Build a simple UI to demonstrate the framework.
    return Column(
      children: [
        Text('Hello, Radartui!'),
        // Add more widgets here.
      ],
    );
  }
}
