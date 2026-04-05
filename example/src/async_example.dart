import 'dart:async';
import 'package:radartui/radartui.dart';

class AsyncExample extends StatefulWidget {
  const AsyncExample();

  @override
  State<AsyncExample> createState() => _AsyncExampleState();
}

class _AsyncExampleState extends State<AsyncExample> {
  late Future<String> _dataFuture;
  late Stream<int> _counterStream;
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _dataFuture = Future.delayed(
      const Duration(seconds: 2),
      () => 'Data loaded successfully!',
    );
    _counterStream = Stream.periodic(
      const Duration(seconds: 1),
      (int count) => count,
    ).take(5);
    _keySubscription =
        ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      _handleKeyEvent(key);
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Container(
            width: 50,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                '⚡ Async Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'FutureBuilder (loads after 2s):',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          const SizedBox(height: 1),
          Container(
            width: 45,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: FutureBuilder<String>(
              future: _dataFuture,
              builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Loading...',
                    style: TextStyle(color: Color.yellow),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Color.red),
                  );
                }
                return Text(
                  snapshot.data ?? 'No data',
                  style: const TextStyle(color: Color.green, bold: true),
                );
              },
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'StreamBuilder (counts 0-4, 1s interval):',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          const SizedBox(height: 1),
          Container(
            width: 45,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: StreamBuilder<int>(
              stream: _counterStream,
              initialData: -1,
              builder: (BuildContext ctx, AsyncSnapshot<int> snapshot) {
                final int count = snapshot.data ?? 0;
                final bool isDone =
                    snapshot.connectionState == ConnectionState.done;
                if (isDone) {
                  return Text(
                    'Stream complete! Final count: $count',
                    style: const TextStyle(color: Color.green, bold: true),
                  );
                }
                return Text(
                  'Streaming... count: $count',
                  style: const TextStyle(color: Color.white),
                );
              },
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}
