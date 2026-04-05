import 'package:radartui/radartui.dart';
import '../pty_app_runner.dart';

class Node {
  const Node(this.name, [this.children = const []]);
  final String name;
  final List<Node> children;
}

void main(List<String> args) {
  runPtyApp(
    TreeView<Node>(
      roots: const [
        Node('Root', [Node('Child1'), Node('Child2')]),
      ],
      builder: (node, depth, isExpanded) =>
          Text('${'  ' * depth}${isExpanded ? '▼' : '▶'} ${node.name}'),
      getChildren: (node) => node.children,
      nodeKey: (node) => node.name,
      isExpandable: (node) => node.children.isNotEmpty,
    ),
    args,
  );
}
