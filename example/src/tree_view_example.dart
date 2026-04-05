import 'dart:async';
import 'package:radartui/radartui.dart';

class TreeViewExample extends StatefulWidget {
  const TreeViewExample();

  @override
  State<TreeViewExample> createState() => _TreeViewExampleState();
}

class _FileNode {
  const _FileNode(this.name, {this.children = const []});
  final String name;
  final List<_FileNode> children;
}

class _TreeViewExampleState extends State<TreeViewExample> {
  StreamSubscription? _keySubscription;

  static const List<_FileNode> _roots = [
    _FileNode('project', children: [
      _FileNode('src', children: [
        _FileNode('main.dart'),
        _FileNode('utils.dart'),
      ]),
      _FileNode('docs', children: [
        _FileNode('readme.md'),
      ]),
      _FileNode('test', children: [
        _FileNode('widget_test.dart'),
      ]),
    ]),
  ];

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
                '🌳 TreeView Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 44,
            height: 14,
            color: Color.brightBlack,
            child: TreeView<_FileNode>(
              roots: _roots,
              controller: TreeController(
                initialExpandedKeys: {'project', 'src'},
              ),
              nodeKey: (_FileNode node) => node.name,
              getChildren: (_FileNode node) => node.children,
              isExpandable: (_FileNode node) => node.children.isNotEmpty,
              builder: (
                _FileNode node,
                int depth,
                bool isExpanded,
              ) {
                final String prefix = '  ' * depth;
                final bool hasChildren = node.children.isNotEmpty;
                final String icon = hasChildren ? '📂 ' : '📄 ';
                return Text(
                  '$prefix$icon${node.name}',
                  style: TextStyle(
                    color: hasChildren ? Color.cyan : Color.white,
                  ),
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
