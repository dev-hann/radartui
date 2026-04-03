import 'dart:async';
import 'package:radartui/radartui.dart';

class RadioExample extends StatefulWidget {
  const RadioExample();

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  String? _selectedTheme = 'dark';
  int? _selectedPriority = 2;
  String? _selectedLanguage = 'dart';
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription = ServicesBinding.instance.keyboard.keyEvents.listen((
      key,
    ) {
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
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Radio Button Example',
            style: TextStyle(color: Color.brightCyan, bold: true),
          ),
          const SizedBox(height: 1),
          const Text(
            'Theme Selection:',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          Row(
            children: [
              Radio<String>(
                value: 'dark',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value;
                  });
                },
              ),
              const SizedBox(width: 2),
              const Text('Dark Theme'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'light',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value;
                  });
                },
              ),
              const SizedBox(width: 2),
              const Text('Light Theme'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'auto',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value;
                  });
                },
                activeColor: Color.green,
              ),
              const SizedBox(width: 2),
              const Text('Auto Theme'),
            ],
          ),
          const SizedBox(height: 1),
          const Text(
            'Priority Level:',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: _selectedPriority,
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
                activeColor: Color.red,
              ),
              const SizedBox(width: 2),
              const Text('High Priority'),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                value: 2,
                groupValue: _selectedPriority,
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
                activeColor: Color.yellow,
              ),
              const SizedBox(width: 2),
              const Text('Medium Priority'),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                value: 3,
                groupValue: _selectedPriority,
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
                activeColor: Color.green,
              ),
              const SizedBox(width: 2),
              const Text('Low Priority'),
            ],
          ),
          const SizedBox(height: 1),
          const Text(
            'Programming Language:',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          Row(
            children: [
              Radio<String>(
                value: 'dart',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
              ),
              const SizedBox(width: 2),
              const Text('Dart'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'rust',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
              ),
              const SizedBox(width: 2),
              const Text('Rust'),
            ],
          ),
          const SizedBox(height: 1),
          const Text(
            'Disabled Radio Buttons:',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          const Row(
            children: [
              Radio<String>(
                value: 'disabled1',
                groupValue: 'disabled2',
                onChanged: null,
              ),
              SizedBox(width: 2),
              Text('Disabled Unselected'),
            ],
          ),
          const Row(
            children: [
              Radio<String>(
                value: 'disabled2',
                groupValue: 'disabled2',
                onChanged: null,
              ),
              SizedBox(width: 2),
              Text('Disabled Selected'),
            ],
          ),
          const SizedBox(height: 1),
          const Text(
            'Current Selection:',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          Text(
            'Theme: ${_selectedTheme?.toUpperCase() ?? "NONE"}',
            style: const TextStyle(color: Color.brightWhite),
          ),
          Text(
            'Priority: ${_getPriorityText(_selectedPriority)}',
            style: const TextStyle(color: Color.brightWhite),
          ),
          Text(
            'Language: ${_selectedLanguage?.toUpperCase() ?? "NONE"}',
            style: const TextStyle(color: Color.brightWhite),
          ),
        ],
      ),
    );
  }

  String _getPriorityText(int? priority) {
    switch (priority) {
      case 1:
        return 'HIGH';
      case 2:
        return 'MEDIUM';
      case 3:
        return 'LOW';
      default:
        return 'NONE';
    }
  }
}
