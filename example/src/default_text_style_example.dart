import 'dart:async';
import 'package:radartui/radartui.dart';

class DefaultTextStyleExample extends StatefulWidget {
  const DefaultTextStyleExample();

  @override
  State<DefaultTextStyleExample> createState() =>
      _DefaultTextStyleExampleState();
}

class _DefaultTextStyleExampleState extends State<DefaultTextStyleExample> {
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription = ServicesBinding.instance.keyboard.keyEvents.listen((
      key,
    ) {
      if (key.code == KeyCode.escape) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(1),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                'DefaultTextStyle Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          DefaultTextStyle(
            style: TextStyle(color: Color.cyan, bold: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Inherited cyan bold style'),
                Text('All children share this style'),
                Text('No explicit style needed'),
              ],
            ),
          ),
          SizedBox(height: 2),
          DefaultTextStyle(
            style: TextStyle(color: Color.green, italic: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Green italic style'),
                Text(
                  'Explicit blue overrides default',
                  style: TextStyle(color: Color.blue),
                ),
                Text('Back to green italic'),
              ],
            ),
          ),
          SizedBox(height: 2),
          DefaultTextStyle(
            style: TextStyle(color: Color.yellow),
            child: DefaultTextStyle(
              style: TextStyle(color: Color.magenta, underline: true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nested: magenta underline wins'),
                  Text('Inner DefaultTextStyle overrides outer'),
                ],
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Press ESC to return',
            style: TextStyle(color: Color.brightBlack, italic: true),
          ),
        ],
      ),
    );
  }
}
