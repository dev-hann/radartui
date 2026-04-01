import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

class _TestNode {
  const _TestNode(this.name, [this.children = const []]);
  final String name;
  final List<_TestNode> children;
}

void main() {
  group('TreeController', () {
    test('starts with empty expanded set', () {
      final controller = TreeController();
      expect(controller.expandedKeys, isEmpty);
      expect(controller.isExpanded('a'), isFalse);
      controller.dispose();
    });

    test('starts with initial expanded keys', () {
      final controller = TreeController(initialExpandedKeys: {'a', 'b'});
      expect(controller.isExpanded('a'), isTrue);
      expect(controller.isExpanded('b'), isTrue);
      expect(controller.isExpanded('c'), isFalse);
      controller.dispose();
    });

    test('toggleExpansion adds and removes keys', () {
      final controller = TreeController();
      controller.toggleExpansion('a');
      expect(controller.isExpanded('a'), isTrue);
      controller.toggleExpansion('a');
      expect(controller.isExpanded('a'), isFalse);
      controller.dispose();
    });

    test('toggleExpansion notifies listeners', () {
      final controller = TreeController();
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.toggleExpansion('a');
      expect(notifyCount, equals(1));
      controller.toggleExpansion('a');
      expect(notifyCount, equals(2));
      controller.removeListener(() => notifyCount++);
      controller.dispose();
    });

    test('expand adds key and notifies once', () {
      final controller = TreeController();
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.expand('a');
      expect(controller.isExpanded('a'), isTrue);
      expect(notifyCount, equals(1));
      controller.expand('a');
      expect(notifyCount, equals(1));
      controller.dispose();
    });

    test('collapse removes key and notifies once', () {
      final controller = TreeController(initialExpandedKeys: {'a'});
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.collapse('a');
      expect(controller.isExpanded('a'), isFalse);
      expect(notifyCount, equals(1));
      controller.collapse('a');
      expect(notifyCount, equals(1));
      controller.dispose();
    });

    test('expandAll adds all keys', () {
      final controller = TreeController();
      controller.expandAll(['a', 'b', 'c']);
      expect(controller.isExpanded('a'), isTrue);
      expect(controller.isExpanded('b'), isTrue);
      expect(controller.isExpanded('c'), isTrue);
      controller.dispose();
    });

    test('collapseAll clears all keys', () {
      final controller = TreeController(initialExpandedKeys: {'a', 'b'});
      controller.collapseAll();
      expect(controller.expandedKeys, isEmpty);
      expect(controller.isExpanded('a'), isFalse);
      controller.dispose();
    });

    test('expandedKeys returns a copy', () {
      final controller = TreeController(initialExpandedKeys: {'a'});
      final keys = controller.expandedKeys;
      keys.add('b');
      expect(controller.isExpanded('b'), isFalse);
      controller.dispose();
    });

    test('dispose clears keys', () {
      final controller = TreeController(initialExpandedKeys: {'a'});
      controller.dispose();
      expect(controller.expandedKeys, isEmpty);
    });
  });

  group('TreeView', () {
    group('constructor', () {
      test('creates with required parameters', () {
        const child = _TestNode('child');
        const root = _TestNode('root', [child]);
        final treeView = TreeView<_TestNode>(
          roots: const [root],
          builder: (node, depth, isExpanded) => Text(node.name),
          getChildren: (node) => node.children,
          nodeKey: (node) => node.name,
        );
        expect(treeView.roots, hasLength(1));
        expect(treeView.controller, isNull);
        expect(treeView.focusNode, isNull);
      });

      test('creates with custom controller', () {
        final controller = TreeController();
        final treeView = TreeView<_TestNode>(
          roots: const [_TestNode('root')],
          builder: (node, depth, isExpanded) => Text(node.name),
          getChildren: (node) => node.children,
          nodeKey: (node) => node.name,
          controller: controller,
        );
        expect(treeView.controller, same(controller));
        controller.dispose();
      });

      test('creates with custom focusNode', () {
        final focusNode = FocusNode();
        final treeView = TreeView<_TestNode>(
          roots: const [_TestNode('root')],
          builder: (node, depth, isExpanded) => Text(node.name),
          getChildren: (node) => node.children,
          nodeKey: (node) => node.name,
          focusNode: focusNode,
        );
        expect(treeView.focusNode, same(focusNode));
        focusNode.dispose();
      });

      test('creates with isExpandable override', () {
        final treeView = TreeView<_TestNode>(
          roots: const [_TestNode('root')],
          builder: (node, depth, isExpanded) => Text(node.name),
          getChildren: (node) => node.children,
          nodeKey: (node) => node.name,
          isExpandable: (node) => false,
        );
        expect(treeView.isExpandable, isNotNull);
        expect(treeView.isExpandable!(const _TestNode('x')), isFalse);
      });

      test('creates with onNodeSelected callback', () {
        _TestNode? selected;
        final treeView = TreeView<_TestNode>(
          roots: const [_TestNode('root')],
          builder: (node, depth, isExpanded) => Text(node.name),
          getChildren: (node) => node.children,
          nodeKey: (node) => node.name,
          onNodeSelected: (node) => selected = node,
        );
        expect(treeView.onNodeSelected, isNotNull);
        treeView.onNodeSelected!(const _TestNode('root'));
        expect(selected?.name, equals('root'));
      });
    });

    group('controller integration', () {
      test('controller toggleExpansion changes expanded state', () {
        final controller = TreeController();
        controller.toggleExpansion('root');
        expect(controller.isExpanded('root'), isTrue);
        controller.toggleExpansion('root');
        expect(controller.isExpanded('root'), isFalse);
        controller.dispose();
      });

      test('controller respects initialExpandedKeys', () {
        final controller = TreeController(initialExpandedKeys: {'root'});
        expect(controller.isExpanded('root'), isTrue);
        controller.dispose();
      });

      test('expandAll with list of keys expands everything', () {
        final controller = TreeController();
        controller.expandAll(['a', 'b', 'c']);
        expect(controller.expandedKeys.length, equals(3));
        controller.dispose();
      });

      test('collapseAll removes all expansions', () {
        final controller = TreeController(initialExpandedKeys: {'a', 'b'});
        expect(controller.expandedKeys.length, equals(2));
        controller.collapseAll();
        expect(controller.expandedKeys.length, equals(0));
        controller.dispose();
      });
    });
  });
}
