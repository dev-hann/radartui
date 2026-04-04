import 'dart:io';

import 'package:radartui/radartui.dart';

class Node {
  const Node(this.name, [this.children = const []]);
  final String name;
  final List<Node> children;
}

void main(List<String> args) {
  final bool isPtyTest = args.contains('--pty-test');
  final AppBinding binding = AppBinding.ensureInitialized() as AppBinding;
  if (!isPtyTest) {
    binding.initializeServices();
  }

  final widget = TreeView<Node>(
    roots: const [
      Node('Root', [Node('Child1'), Node('Child2')]),
    ],
    builder: (node, depth, isExpanded) =>
        Text('${'  ' * depth}${isExpanded ? '▼' : '▶'} ${node.name}'),
    getChildren: (node) => node.children,
    nodeKey: (node) => node.name,
    isExpandable: (node) => node.children.isNotEmpty,
  );

  binding.attachRootWidget(widget);

  if (isPtyTest) {
    binding.renderFrame();
    exit(0);
  } else {
    binding.runApp(widget);
  }
}
