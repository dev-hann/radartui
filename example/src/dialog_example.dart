import 'package:radartui/radartui.dart';

void main() {
  runApp(DialogExampleApp());
}

class DialogExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dialog Example',
      home: DialogExampleScreen(),
    );
  }
}

class DialogExampleScreen extends StatefulWidget {
  @override
  State<DialogExampleScreen> createState() => _DialogExampleScreenState();
}

class _DialogExampleScreenState extends State<DialogExampleScreen> {
  String _lastResult = 'No dialog shown yet';

  Future<void> _showSimpleDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        title: 'Simple Dialog',
        child: Text('This is a simple dialog with a title.'),
        actions: [
          TextButton(
            onPressed: () => dismissDialog('OK pressed'),
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () => dismissDialog('Cancel pressed'),
            child: Text('Cancel'),
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
      barrierColor: Colors.black54,
      builder: (BuildContext context) => Dialog(
        title: 'Colored Dialog',
        titleStyle: TextStyle(color: Colors.blue),
        backgroundColor: Colors.lightBlue,
        child: Text('This dialog has custom colors and a barrier.'),
        actions: [
          TextButton(
            onPressed: () => dismissDialog('Colored dialog closed'),
            child: Text('Close'),
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
      builder: (BuildContext context) => Dialog(
        title: 'Constrained Dialog',
        constraints: BoxConstraints(
          maxWidth: 300,
          maxHeight: 200,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('This dialog has size constraints.'),
            Text('Width: max 300, Height: max 200'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => dismissDialog(42),
            child: Text('Return Number'),
          ),
          TextButton(
            onPressed: () => dismissDialog(),
            child: Text('Return Nothing'),
          ),
        ],
      ),
    );
    
    setState(() {
      _lastResult = result != null ? 'Number returned: $result' : 'No number returned';
    });
  }

  Future<void> _showNonDismissibleDialog() async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false, // Cannot dismiss with Escape key
      builder: (BuildContext context) => Dialog(
        title: 'Non-Dismissible Dialog',
        child: Text('This dialog cannot be dismissed with Escape key.'),
        actions: [
          TextButton(
            onPressed: () => dismissDialog('Explicitly closed'),
            child: Text('Must Click This'),
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
    return Scaffold(
      appBar: AppBar(title: Text('Dialog Examples')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Last Result: $_lastResult'),
            SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _showSimpleDialog,
              child: Text('Show Simple Dialog'),
            ),
            SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: _showColoredDialog,
              child: Text('Show Colored Dialog'),
            ),
            SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: _showConstrainedDialog,
              child: Text('Show Constrained Dialog'),
            ),
            SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: _showNonDismissibleDialog,
              child: Text('Show Non-Dismissible Dialog'),
            ),
            
            SizedBox(height: 30),
            Text(
              'Features Demonstrated:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('• Title and actions support'),
            Text('• Barrier color customization'),
            Text('• Size constraints with BoxConstraints'),
            Text('• Return values from dialogs'),
            Text('• Dismissible vs non-dismissible modes'),
            Text('• Escape key handling (when barrierDismissible: true)'),
            Text('• Custom styling and padding'),
          ],
        ),
      ),
    );
  }
}