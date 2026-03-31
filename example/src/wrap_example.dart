import 'package:radartui/radartui.dart';

class WrapExample extends StatefulWidget {
  const WrapExample();

  @override
  State<WrapExample> createState() => _WrapExampleState();
}

class _WrapExampleState extends State<WrapExample> {
  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.code == KeyCode.escape) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Container(
            width: 60,
            height: 3,
            color: Color.cyan,
            child: Center(
              child: Text(
                'Wrap Widget Demo',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Wrap with chips (wraps to next line):',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                Wrap(
                  spacing: 1,
                  runSpacing: 1,
                  children: [
                    _buildChip('Dart', Color.blue),
                    _buildChip('Flutter', Color.cyan),
                    _buildChip('Rust', Color.red),
                    _buildChip('Go', Color.green),
                    _buildChip('Python', Color.yellow),
                    _buildChip('TypeScript', Color.blue),
                    _buildChip('Kotlin', Color.magenta),
                    _buildChip('Swift', Color.red),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Wrap with center alignment:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                Wrap(
                  spacing: 2,
                  runSpacing: 1,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildChip('A', Color.red),
                    _buildChip('B', Color.green),
                    _buildChip('C', Color.blue),
                    _buildChip('D', Color.yellow),
                    _buildChip('E', Color.magenta),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Wrap with spaceBetween:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                Wrap(
                  spacing: 1,
                  runSpacing: 1,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    _buildChip('Left', Color.green),
                    _buildChip('Center', Color.yellow),
                    _buildChip('Right', Color.red),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          const Container(
            width: 60,
            color: Color.yellow,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text('Properties:',
                    style: TextStyle(color: Color.black, bold: true)),
                Text('spacing: horizontal gap between items',
                    style: TextStyle(color: Color.black)),
                Text('runSpacing: vertical gap between rows',
                    style: TextStyle(color: Color.black)),
                Text('alignment: start/end/center/spaceBetween',
                    style: TextStyle(color: Color.black)),
              ],
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Press ESC to return',
            style: TextStyle(color: Color.brightGreen, italic: true),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      color: color,
      child: Text(label, style: const TextStyle(color: Color.white)),
    );
  }
}
