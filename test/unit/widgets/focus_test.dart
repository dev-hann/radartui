import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('FocusNode', () {
    test('FocusNode creation does not auto-register to any scope', () {
      final node = FocusNode();
      expect(node.hasFocus, isFalse);
      node.dispose();
    });

    test('FocusNode hasFocus defaults to false', () {
      final node = FocusNode();
      expect(node.hasFocus, isFalse);
      node.dispose();
    });

    test('FocusNode can be added to scope explicitly', () {
      final scope = FocusScope();
      final node = FocusNode();
      
      scope.addNode(node);
      
      expect(scope.nodes.contains(node), isTrue);
      scope.dispose();
    });

    test('FocusNode can be removed from scope', () {
      final scope = FocusScope();
      final node = FocusNode();
      
      scope.addNode(node);
      expect(scope.nodes.contains(node), isTrue);
      
      scope.removeNode(node);
      expect(scope.nodes.contains(node), isFalse);
      scope.dispose();
    });

    test('FocusNode._setFocus changes hasFocus', () {
      final scope = FocusScope();
      final node = FocusNode();
      
      scope.addNode(node);
      scope.activate();
      
      expect(node.hasFocus, isTrue);
      
      scope.nextFocus();
      
      scope.dispose();
    });
  });

  group('FocusScope', () {
    test('FocusScope starts inactive', () {
      final scope = FocusScope();
      expect(scope.isActive, isFalse);
      scope.dispose();
    });

    test('FocusScope activate sets focus to first node', () {
      final scope = FocusScope();
      final node1 = FocusNode();
      final node2 = FocusNode();
      
      scope.addNode(node1);
      scope.addNode(node2);
      
      expect(node1.hasFocus, isFalse);
      expect(node2.hasFocus, isFalse);
      
      scope.activate();
      
      expect(scope.isActive, isTrue);
      expect(node1.hasFocus, isTrue);
      expect(node2.hasFocus, isFalse);
      
      scope.dispose();
    });

    test('FocusScope nextFocus moves focus forward', () {
      final scope = FocusScope();
      final node1 = FocusNode();
      final node2 = FocusNode();
      final node3 = FocusNode();
      
      scope.addNode(node1);
      scope.addNode(node2);
      scope.addNode(node3);
      scope.activate();
      
      expect(node1.hasFocus, isTrue);
      
      scope.nextFocus();
      expect(node1.hasFocus, isFalse);
      expect(node2.hasFocus, isTrue);
      
      scope.nextFocus();
      expect(node2.hasFocus, isFalse);
      expect(node3.hasFocus, isTrue);
      
      scope.dispose();
    });

    test('FocusScope nextFocus wraps around', () {
      final scope = FocusScope();
      final node1 = FocusNode();
      final node2 = FocusNode();
      
      scope.addNode(node1);
      scope.addNode(node2);
      scope.activate();
      
      expect(node1.hasFocus, isTrue);
      
      scope.nextFocus();
      expect(node2.hasFocus, isTrue);
      
      scope.nextFocus();
      expect(node1.hasFocus, isTrue);
      
      scope.dispose();
    });

    test('FocusScope previousFocus moves focus backwards', () {
      final scope = FocusScope();
      final node1 = FocusNode();
      final node2 = FocusNode();
      
      scope.addNode(node1);
      scope.addNode(node2);
      scope.activate();
      
      expect(node1.hasFocus, isTrue);
      
      scope.previousFocus();
      expect(node1.hasFocus, isFalse);
      expect(node2.hasFocus, isTrue);
      
      scope.dispose();
    });

    test('FocusScope removeNode adjusts focus to next node', () {
      final scope = FocusScope();
      final node1 = FocusNode();
      final node2 = FocusNode();
      
      scope.addNode(node1);
      scope.addNode(node2);
      scope.activate();
      
      expect(node1.hasFocus, isTrue);
      
      scope.removeNode(node1);
      
      expect(node2.hasFocus, isTrue);
      expect(scope.nodes.length, equals(1));
      
      scope.dispose();
    });

    test('FocusScope setFocus sets focus to specific node', () {
      final scope = FocusScope();
      final node1 = FocusNode();
      final node2 = FocusNode();
      
      scope.addNode(node1);
      scope.addNode(node2);
      scope.activate();
      
      expect(node1.hasFocus, isTrue);
      
      scope.setFocus(node2);
      
      expect(node1.hasFocus, isFalse);
      expect(node2.hasFocus, isTrue);
      
      scope.dispose();
    });

    test('FocusScope currentFocus returns focused node', () {
      final scope = FocusScope();
      final node1 = FocusNode();
      final node2 = FocusNode();
      
      scope.addNode(node1);
      scope.addNode(node2);
      scope.activate();
      
      expect(scope.currentFocus, equals(node1));
      
      scope.nextFocus();
      expect(scope.currentFocus, equals(node2));
      
      scope.dispose();
    });

    test('FocusScope deactivate clears all focus', () {
      final scope = FocusScope();
      final node1 = FocusNode();
      
      scope.addNode(node1);
      scope.activate();
      
      expect(node1.hasFocus, isTrue);
      
      scope.deactivate();
      
      expect(scope.isActive, isFalse);
      expect(node1.hasFocus, isFalse);
      
      scope.dispose();
    });
  });

  group('Focus widget', () {
    test('Focus widget creates with child', () {
      const focus = Focus(
        child: Text('test'),
      );
      expect(focus.child, isA<Text>());
    });

    test('Focus widget accepts optional focusNode', () {
      final node = FocusNode();
      final focus = Focus(
        focusNode: node,
        child: const Text('test'),
      );
      expect(focus.focusNode, equals(node));
    });

    test('Focus widget accepts optional onKeyEvent', () {
      final focus = Focus(
        onKeyEvent: (_) {},
        child: const Text('test'),
      );
      expect(focus.onKeyEvent, isNotNull);
    });
  });
}
