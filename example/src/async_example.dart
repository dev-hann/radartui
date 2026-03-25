import 'dart:async';
import 'package:radartui/radartui.dart';

class AsyncExample extends StatefulWidget {
  const AsyncExample();

  @override
  State<AsyncExample> createState() => _AsyncExampleState();
}

class _AsyncExampleState extends State<AsyncExample> {
  late Stream<int> _counterStream;
  Future<String>? _dataFuture;

  @override
  void initState() {
    super.initState();
    _counterStream = _createCounterStream();
    _dataFuture = _fetchData();
    ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.code == KeyCode.escape) {
        Navigator.of(context).pop();
      } else if (key.code == KeyCode.char && key.char == 'r') {
        _refreshFuture();
      }
    });
  }

  Stream<int> _createCounterStream() {
    return Stream.periodic(const Duration(seconds: 1), (count) => count).take(10);
  }

  Future<String> _fetchData() {
    return Future.delayed(const Duration(seconds: 2), () => 'Data loaded successfully!');
  }

  void _refreshFuture() {
    setState(() {
      _dataFuture = _fetchData();
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
            color: Color.magenta,
            child: Center(
              child: Text(
                'FutureBuilder & StreamBuilder Demo',
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
                  'FutureBuilder (loads after 2 seconds):',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                FutureBuilder<String>(
                  future: _dataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Row(
                        children: [
                          LoadingIndicator(type: IndicatorType.spinner, color: Color.yellow),
                          SizedBox(width: 2),
                          Text('Loading...', style: TextStyle(color: Color.yellow)),
                        ],
                      );
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}', style: const TextStyle(color: Color.red));
                    }
                    if (snapshot.hasData) {
                      return Text(
                        'Result: ${snapshot.data}',
                        style: const TextStyle(color: Color.green, bold: true),
                      );
                    }
                    return const Text('No data', style: TextStyle(color: Color.brightBlack));
                  },
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
                  'StreamBuilder (counts 0-9 every second):',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                StreamBuilder<int>(
                  stream: _counterStream,
                  initialData: 0,
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    final isDone = snapshot.connectionState == ConnectionState.done;
                    
                    return Row(
                      children: [
                        if (!isDone)
                          const LoadingIndicator(type: IndicatorType.dots, color: Color.cyan)
                        else
                          const Text('Done!', style: TextStyle(color: Color.green, bold: true)),
                        const SizedBox(width: 2),
                        Text(
                          'Count: $count',
                          style: TextStyle(
                            color: isDone ? Color.green : Color.white,
                            bold: isDone,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          isDone ? '(completed)' : '(streaming...)',
                          style: const TextStyle(color: Color.brightBlack),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 2),
          
          const Container(
            width: 60,
            color: Color.blue,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Controls:',
                  style: TextStyle(color: Color.white, bold: true),
                ),
                Text('R: Refresh Future | ESC: Return', style: TextStyle(color: Color.white)),
              ],
            ),
          ),
          
          const SizedBox(height: 2),
          
          const Text(
            'FutureBuilder: One-time async data loading',
            style: TextStyle(color: Color.yellow),
          ),
          const Text(
            'StreamBuilder: Continuous async data stream',
            style: TextStyle(color: Color.yellow),
          ),
        ],
      ),
    );
  }
}
