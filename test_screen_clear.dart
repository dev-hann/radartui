import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

void main() {
  runApp(const ScreenClearTestApp());
}

class ScreenClearTestApp extends StatelessWidget {
  const ScreenClearTestApp();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      routes: {
        '/': (context) => const PageOne(),
        '/page2': (context) => const PageTwo(),
      },
    );
  }
}

class PageOne extends StatefulWidget {
  const PageOne();

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 10,
      color: Color.red,
      child: Column(
        children: [
          const Text(
            'PAGE ONE - This is a long page with content',
            style: TextStyle(color: Color.white, bold: true),
          ),
          const SizedBox(height: 2),
          const Text(
            'Content that should be cleared when navigating',
            style: TextStyle(color: Color.yellow),
          ),
          const SizedBox(height: 2),
          const Text(
            'Press Enter to go to Page Two',
            style: TextStyle(color: Color.green, italic: true),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.keyboard.keyEvents.listen((keyEvent) {
      if (keyEvent.code == KeyCode.enter) {
        Navigator.pushNamed(context, '/page2');
      }
    });
  }
}

class PageTwo extends StatefulWidget {
  const PageTwo();

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 6,
      color: Color.blue,
      child: Column(
        children: [
          const Text(
            'PAGE TWO - Smaller page',
            style: TextStyle(color: Color.white, bold: true),
          ),
          const SizedBox(height: 1),
          const Text(
            'Previous content should be cleared',
            style: TextStyle(color: Color.cyan),
          ),
          const SizedBox(height: 1),
          const Text(
            'Press Enter to go back',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.keyboard.keyEvents.listen((keyEvent) {
      if (keyEvent.code == KeyCode.enter) {
        Navigator.pop(context);
      }
    });
  }
}