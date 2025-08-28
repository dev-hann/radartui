import '../../lib/radartui.dart';

class RadioExample extends StatefulWidget {
  const RadioExample();

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  String? _selectedTheme = 'dark';
  int? _selectedPriority = 2;
  String? _selectedLanguage = 'dart';

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
                'Radio Button Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          
          // Theme Selection
          Container(
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Theme Selection (Tab + Space/Enter):',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                
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
                
                const SizedBox(height: 1),
                
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
                
                const SizedBox(height: 1),
                
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
                    const Text('Auto Theme (Green)'),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 2),
          
          // Priority Selection
          Container(
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Priority Level:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                
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
                
                const SizedBox(height: 1),
                
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
                
                const SizedBox(height: 1),
                
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
              ],
            ),
          ),
          
          const SizedBox(height: 2),
          
          // Programming Language Selection
          Container(
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Programming Language:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                
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
                
                const SizedBox(height: 1),
                
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
              ],
            ),
          ),
          
          const SizedBox(height: 2),
          
          // Disabled Radio Example
          const Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: const Column(
              children: [
                Text(
                  'Disabled Radio Buttons:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                
                Row(
                  children: [
                    Radio<String>(
                      value: 'disabled1',
                      groupValue: 'disabled2',
                      onChanged: null, // Disabled
                    ),
                    SizedBox(width: 2),
                    Text('Disabled Unselected'),
                  ],
                ),
                
                SizedBox(height: 1),
                
                Row(
                  children: [
                    Radio<String>(
                      value: 'disabled2',
                      groupValue: 'disabled2',
                      onChanged: null, // Disabled
                    ),
                    SizedBox(width: 2),
                    Text('Disabled Selected'),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 2),
          
          // Status Display
          Container(
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Current Selection:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
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
          ),
          
          const SizedBox(height: 2),
          
          // Navigation hint
          const Text(
            'Use Tab to navigate, Space/Enter to select',
            style: TextStyle(color: Color.brightGreen, italic: true),
          ),
          const Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
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