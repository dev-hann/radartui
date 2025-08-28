import '../../lib/radartui.dart';

class CheckboxExample extends StatefulWidget {
  const CheckboxExample();

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool _option1 = false;
  final bool _option2 = true;
  final bool _option3 = false;
  final bool _option4 = true;

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
                '☑️ Checkbox Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),

          // Basic Checkboxes
          Container(
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Interactive Checkboxes (Tab + Space/Enter):',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    Checkbox(
                      value: _option1,
                      onChanged: (value) {
                        setState(() {
                          _option1 = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(width: 2),
                    Text('Enable notifications ${_option1.toString()}'),
                  ],
                ),
                const SizedBox(height: 1),
                // Row(
                //   children: [
                //     Checkbox(
                //       value: _option2,
                //       onChanged: (value) {
                //         _option2 = value ?? false;
                //         setState(() {});
                //       },
                //     ),
                //     const SizedBox(width: 2),
                //     const Text('Auto-save documents'),
                //   ],
                // ),
                // const SizedBox(height: 1),
                // Row(
                //   children: [
                //     Checkbox(
                //       value: _option3,
                //       onChanged: (value) {
                //         setState(() {
                //           _option3 = value ?? false;
                //         });
                //       },
                //       activeColor: Color.green,
                //     ),
                //     const SizedBox(width: 2),
                //     const Text('Green themed checkbox'),
                //   ],
                // ),
                // const SizedBox(height: 1),
                // Row(
                //   children: [
                //     Checkbox(
                //       value: _option4,
                //       onChanged: (value) {
                //         setState(() {
                //           _option4 = value ?? false;
                //         });
                //       },
                //       activeColor: Color.red,
                //       checkColor: Color.yellow,
                //     ),
                //     const SizedBox(width: 2),
                //     const Text('Custom colors checkbox'),
                //   ],
                // ),
              ],
            ),
          ),

          const SizedBox(height: 2),

          // Disabled Checkboxes
          // const Container(
          //   color: Color.brightBlack,
          //   padding: EdgeInsets.all(1),
          //   child: const Column(
          //     children: [
          //       Text(
          //         'Disabled Checkboxes:',
          //         style: TextStyle(color: Color.cyan, bold: true),
          //       ),
          //       SizedBox(height: 1),
          //       Row(
          //         children: [
          //           Checkbox(
          //             value: false,
          //             onChanged: null, // Disabled
          //           ),
          //           SizedBox(width: 2),
          //           Text('Disabled unchecked'),
          //         ],
          //       ),
          //       SizedBox(height: 1),
          //       Row(
          //         children: [
          //           Checkbox(
          //             value: true,
          //             onChanged: null, // Disabled
          //           ),
          //           SizedBox(width: 2),
          //           Text('Disabled checked'),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 2),

          // Status Display
          Container(
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Current Selection Status:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                Text(
                  'Notifications: ${_option1 ? "ON" : "OFF"}',
                  style: TextStyle(
                    color: _option1 ? Color.green : Color.red,
                  ),
                ),
                Text(
                  'Auto-save: ${_option2 ? "ON" : "OFF"}',
                  style: TextStyle(
                    color: _option2 ? Color.green : Color.red,
                  ),
                ),
                Text(
                  'Green theme: ${_option3 ? "ON" : "OFF"}',
                  style: TextStyle(
                    color: _option3 ? Color.green : Color.red,
                  ),
                ),
                Text(
                  'Custom colors: ${_option4 ? "ON" : "OFF"}',
                  style: TextStyle(
                    color: _option4 ? Color.green : Color.red,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 2),

          // Navigation hint
          const Text(
            'Use Tab to navigate, Space/Enter to toggle',
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
}
