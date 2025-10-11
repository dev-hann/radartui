import '../../lib/radartui.dart';

class FocusExample extends StatefulWidget {
  const FocusExample();

  @override
  State<FocusExample> createState() => _FocusExampleState();
}

class _FocusExampleState extends State<FocusExample> {
  String selectedAction = '';
  String selectedFile = '';
  String selectedOption = '';

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.code == KeyCode.escape) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Text(
            'Focus Example - Use Tab/Shift+Tab to switch between lists',
          ),
          const SizedBox(height: 1),
          Row(
            children: [
              // 첫 번째 ListView: Actions
              Container(
                padding: const EdgeInsets.all(1),
                child: Column(
                  children: [
                    const Text('Actions:'),
                    ListView(
                      items: ['Create', 'Edit', 'Delete', 'Copy', 'Move'],
                      onItemSelected: (index, item) {
                        setState(() {
                          selectedAction = item;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 2),

              // 두 번째 ListView: Files
              Container(
                padding: const EdgeInsets.all(1),
                child: Column(
                  children: [
                    const Text('Files:'),
                    ListView(
                      items: [
                        'main.dart',
                        'config.json',
                        'README.md',
                        'test.dart',
                      ],
                      onItemSelected: (index, item) {
                        setState(() {
                          selectedFile = item;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 2),

              // 세 번째 ListView: Options
              Container(
                padding: const EdgeInsets.all(1),
                child: Column(
                  children: [
                    const Text('Options:'),
                    ListView(
                      items: ['Confirm', 'Preview', 'Backup', 'Skip'],
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

          const SizedBox(height: 2),

          // 선택된 항목들 표시
          Container(
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text('═══ Current Selection ═══'),
                Text('Action: $selectedAction'),
                Text('File: $selectedFile'),
                Text('Option: $selectedOption'),
                const SizedBox(height: 1),
                const Text('Controls:'),
                const Text('• Tab/Shift+Tab: Switch focus between lists'),
                const Text('• ↑/↓ or j/k: Navigate within focused list'),
                const Text('• Enter/Space: Select item'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
