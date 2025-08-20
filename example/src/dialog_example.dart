import '../../lib/radartui.dart';

class DialogExample extends StatefulWidget {
  @override
  State<DialogExample> createState() => _DialogExampleState();
}

class _DialogExampleState extends State<DialogExample> {
  String _lastResult = 'Press buttons to show dialogs!';
  final String _instruction = 'Use Tab to navigate, Enter to select, Escape to exit';

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      _handleKeyEvent(key);
    });
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape) {
      Navigator.of(context).pop();
      return;
    }
  }

  Future<void> _showSimpleDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder:
          (BuildContext context) => Dialog(
            title: 'Simple Dialog',
            child: const Column(
              children: [
                Text('This is a simple dialog with a title.'),
                Text('It demonstrates basic dialog functionality.'),
              ],
            ),
            actions: [
              Button(
                text: 'OK',
                onPressed: () => Navigator.pop(context, 'OK pressed'),
              ),
              Button(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context, 'Cancel pressed'),
                style: const ButtonStyle(
                  backgroundColor: Color.red,
                  focusBackgroundColor: Color.brightRed,
                ),
              ),
            ],
          ),
    );

    setState(() {
      _lastResult = result ?? 'Dialog dismissed without result';
    });
  }

  Future<void> _showColoredDialog() async {
    final result = await showDialog<String>(
      context: context,
      barrierColor: Color.brightBlack,
      builder:
          (BuildContext context) => Dialog(
            title: 'Colored Dialog',
            titleStyle: const TextStyle(color: Color.cyan, bold: true),
            backgroundColor: Color.blue,
            child: const Column(
              children: [
                Text(
                  'This dialog has custom colors.',
                  style: TextStyle(color: Color.white),
                ),
                Text(
                  'Notice the blue background!',
                  style: TextStyle(color: Color.yellow),
                ),
              ],
            ),
            actions: [
              Button(
                text: 'Close',
                onPressed:
                    () => Navigator.pop(context, 'Colored dialog closed'),
                style: const ButtonStyle(
                  backgroundColor: Color.green,
                  focusBackgroundColor: Color.brightGreen,
                  foregroundColor: Color.black,
                ),
              ),
            ],
          ),
    );

    setState(() {
      _lastResult = result ?? 'Colored dialog dismissed';
    });
  }

  Future<void> _showConstrainedDialog() async {
    final result = await showDialog<int>(
      context: context,
      builder:
          (BuildContext context) => Dialog(
            title: 'Constrained Dialog',
            padding: const EdgeInsets.all(1),
            child: const Column(
              children: [
                Text('Size constrained dialog.'),
                Text('Max width: 40, height: 8'),
              ],
            ),
            actions: [
              Button(
                text: 'Return 42',
                onPressed: () => Navigator.pop(context, 42),
                style: const ButtonStyle(
                  backgroundColor: Color.yellow,
                  focusBackgroundColor: Color.brightYellow,
                  foregroundColor: Color.black,
                ),
              ),
              Button(
                text: 'Return Nothing',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );

    setState(() {
      _lastResult =
          result != null ? 'Number returned: $result' : 'No number returned';
    });
  }

  Future<void> _showNonDismissibleDialog() async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => Dialog(
            title: 'Non-Dismissible Dialog',
            titleStyle: const TextStyle(color: Color.red, bold: true),
            child: const Column(
              children: [
                Text('This dialog cannot be dismissed'),
                Text('with the Escape key.'),
                Text('You must click the button!'),
              ],
            ),
            actions: [
              Button(
                text: 'Must Click This',
                onPressed: () => Navigator.pop(context, 'Explicitly closed'),
                style: const ButtonStyle(
                  backgroundColor: Color.magenta,
                  focusBackgroundColor: Color.brightMagenta,
                ),
              ),
            ],
          ),
    );

    setState(() {
      _lastResult = result ?? 'Non-dismissible dialog closed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Dialog Widget Examples',
          style: TextStyle(color: Color.cyan, bold: true),
        ),
        const SizedBox(height: 1),
        Text(
          'Last Result: $_lastResult',
          style: const TextStyle(color: Color.yellow),
        ),
        const SizedBox(height: 1),
        Text(
          _instruction,
          style: const TextStyle(color: Color.brightBlack, italic: true),
        ),
        const SizedBox(height: 2),

        Button(text: 'Show Simple Dialog', onPressed: _showSimpleDialog),
        const SizedBox(height: 1),

        Button(
          text: 'Show Colored Dialog',
          onPressed: _showColoredDialog,
          style: const ButtonStyle(
            backgroundColor: Color.blue,
            focusBackgroundColor: Color.brightBlue,
          ),
        ),
        const SizedBox(height: 1),

        Button(
          text: 'Show Constrained Dialog',
          onPressed: _showConstrainedDialog,
          style: const ButtonStyle(
            backgroundColor: Color.yellow,
            focusBackgroundColor: Color.brightYellow,
            foregroundColor: Color.black,
          ),
        ),
        const SizedBox(height: 1),

        Button(
          text: 'Show Non-Dismissible Dialog',
          onPressed: _showNonDismissibleDialog,
          style: const ButtonStyle(
            backgroundColor: Color.red,
            focusBackgroundColor: Color.brightRed,
          ),
        ),

        const SizedBox(height: 2),
        const Text(
          'Features Demonstrated:',
          style: TextStyle(color: Color.green, bold: true),
        ),
        const SizedBox(height: 1),
        const Text('• Title and actions support'),
        const Text('• Barrier color customization'),
        const Text('• Size constraints with BoxConstraints'),
        const Text('• Return values from dialogs'),
        const Text('• Dismissible vs non-dismissible modes'),
        const Text('• Escape key handling (when barrierDismissible: true)'),
        const Text('• Custom styling and padding'),
      ],
    );
  }
}
