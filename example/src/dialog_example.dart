import 'dart:async';
import 'package:radartui/radartui.dart';

class DialogExample extends StatefulWidget {
  const DialogExample();

  @override
  State<DialogExample> createState() => _DialogExampleState();
}

class _DialogExampleState extends State<DialogExample> {
  String _dialogResult = 'No dialog shown';
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
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

  Future<void> _showConfirmDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext ctx) => Dialog(
        title: 'Confirm Action',
        child: const Text('Are you sure you want to proceed?'),
        actions: [
          Button(
            text: 'Yes',
            onPressed: () => Navigator.pop(ctx, 'Confirmed'),
            style: const ButtonStyle(
              backgroundColor: Color.green,
              focusBackgroundColor: Color.brightGreen,
            ),
          ),
          Button(
            text: 'No',
            onPressed: () => Navigator.pop(ctx, 'Cancelled'),
            style: const ButtonStyle(
              backgroundColor: Color.red,
              focusBackgroundColor: Color.brightRed,
            ),
          ),
        ],
      ),
    );
    setState(() {
      _dialogResult = result ?? 'Dialog dismissed';
    });
  }

  Future<void> _showInfoDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext ctx) => Dialog(
        title: 'Information',
        backgroundColor: Color.blue,
        child: const Column(
          children: [
            Text(
              'This is an info dialog.',
              style: TextStyle(color: Color.white),
            ),
            Text(
              'Press ESC or the button to close.',
              style: TextStyle(color: Color.yellow),
            ),
          ],
        ),
        actions: [
          Button(
            text: 'OK',
            onPressed: () => Navigator.pop(ctx, 'OK'),
          ),
        ],
      ),
    );
    setState(() {
      _dialogResult = 'Info dialog closed';
    });
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
                '💬 Dialog Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Button(
                text: 'Show Confirm Dialog',
                onPressed: _showConfirmDialog,
                style: const ButtonStyle(
                  backgroundColor: Color.green,
                  focusBackgroundColor: Color.brightGreen,
                ),
              ),
              const SizedBox(width: 2),
              Button(
                text: 'Show Info Dialog',
                onPressed: _showInfoDialog,
                style: const ButtonStyle(
                  backgroundColor: Color.cyan,
                  focusBackgroundColor: Color.brightCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Result: $_dialogResult',
            style: const TextStyle(color: Color.yellow),
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
