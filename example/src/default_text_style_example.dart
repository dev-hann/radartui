import 'package:radartui/radartui.dart';

class DefaultTextStyleExample extends StatelessWidget {
  const DefaultTextStyleExample();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        children: [
          const Container(
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
          const SizedBox(height: 2),
          DefaultTextStyle(
            style: const TextStyle(color: Color.cyan, bold: true),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Inherited cyan bold style'),
                Text('All children share this style'),
                Text('No explicit style needed'),
              ],
            ),
          ),
          const SizedBox(height: 2),
          DefaultTextStyle(
            style: const TextStyle(color: Color.green, italic: true),
            child: const Column(
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
          const SizedBox(height: 2),
          DefaultTextStyle(
            style: const TextStyle(color: Color.yellow),
            child: DefaultTextStyle(
              style: const TextStyle(color: Color.magenta, underline: true),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nested: magenta underline wins'),
                  Text('Inner DefaultTextStyle overrides outer'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Press ESC to return',
            style: TextStyle(color: Color.brightBlack, italic: true),
          ),
        ],
      ),
    );
  }
}
