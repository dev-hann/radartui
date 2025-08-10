import 'dart:async';

import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

class FocusExample extends StatefulWidget {
  const FocusExample();

  @override
  State<FocusExample> createState() => _FocusExampleState();
}

class _FocusExampleState extends State<FocusExample> {
  String selectedAction = '';
  String selectedFile = '';
  String selectedOption = '';
  StreamSubscription? _keySubscription;

  final _focusController = FocusController();
  final _node1 = FocusNode();
  final _node2 = FocusNode();
  final _node3 = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusController.activate();
    _focusController.scope.addNode(_node1);
    _focusController.scope.addNode(_node2);
    _focusController.scope.addNode(_node3);
    
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.key == 'Escape') {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    _node1.dispose();
    _node2.dispose();
    _node3.dispose();
    _focusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          Text('Focus Example - Use Tab/Shift+Tab to switch between lists'),
          SizedBox(height: 1),
          Row(
            children: [
              // 첫 번째 ListView: Actions
              Container(
                padding: EdgeInsets.all(1),
                child: Column(
                  children: [
                    Text('Actions:'),
                    ListView(
                      focusNode: _node1,
                      items: ['Create', 'Edit', 'Delete', 'Copy', 'Move'],
                      focusedBorder: '[====== Actions ======]',
                      unfocusedBorder: '                       ',
                      onItemSelected: (index, item) {
                        setState(() {
                          selectedAction = item;
                        });
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(width: 2),

              // 두 번째 ListView: Files
              Container(
                padding: EdgeInsets.all(1),
                child: Column(
                  children: [
                    Text('Files:'),
                    ListView(
                      focusNode: _node2,
                      items: [
                        'main.dart',
                        'config.json',
                        'README.md',
                        'test.dart',
                      ],
                      focusedBorder: '[====== Files ========]',
                      unfocusedBorder: '                       ',
                      onItemSelected: (index, item) {
                        setState(() {
                          selectedFile = item;
                        });
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(width: 2),

              // 세 번째 ListView: Options
              Container(
                padding: EdgeInsets.all(1),
                child: Column(
                  children: [
                    Text('Options:'),
                    ListView(
                      focusNode: _node3,
                      items: ['Confirm', 'Preview', 'Backup', 'Skip'],
                      focusedBorder: '[====== Options ======]',
                      unfocusedBorder: '                       ',
                      onItemSelected: (index, item) {
                        setState(() {
                          selectedOption = item;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2),

          // 선택된 항목들 표시
          Container(
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text('═══ Current Selection ═══'),
                Text('Action: $selectedAction'),
                Text('File: $selectedFile'),
                Text('Option: $selectedOption'),
                SizedBox(height: 1),
                Text('Controls:'),
                Text('• Tab/Shift+Tab: Switch focus between lists'),
                Text('• ↑/↓ or j/k: Navigate within focused list'),
                Text('• Enter/Space: Select item'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}