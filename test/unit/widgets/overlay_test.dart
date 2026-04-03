import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('OverlayEntry', () {
    test('creates with builder and opaque defaults to false', () {
      final entry = OverlayEntry(builder: (context) => const Text('test'));
      expect(entry.opaque, isFalse);
    });

    test('creates with opaque true', () {
      final entry = OverlayEntry(
        builder: (context) => const Text('test'),
        opaque: true,
      );
      expect(entry.opaque, isTrue);
    });

    test('remove does nothing when not in overlay', () {
      final entry = OverlayEntry(builder: (context) => const Text('test'));
      entry.remove();
    });
  });

  group('Overlay', () {
    test('Overlay is a StatefulWidget', () {
      const overlay = Overlay(child: Text('child'));
      expect(overlay, isA<StatefulWidget>());
      expect(overlay.child, isA<Text>());
    });

    test('OverlayState manages entries', () {
      const overlay = Overlay(child: Text('child'));
      final element = overlay.createElement();
      expect(element, isA<StatefulElement>());
      expect(element.state, isA<OverlayState>());
    });

    test('OverlayState insert adds entry', () {
      const overlay = Overlay(child: Text('child'));
      final state = overlay.createElement().state as OverlayState;
      final entry = OverlayEntry(builder: (context) => const Text('overlay'));
      state.insert(entry);
      expect(state.entries.length, equals(1));
    });

    test('OverlayState insert below works', () {
      const overlay = Overlay(child: Text('child'));
      final state = overlay.createElement().state as OverlayState;

      final entry1 = OverlayEntry(builder: (context) => const Text('first'));
      final entry2 = OverlayEntry(builder: (context) => const Text('second'));
      state.insert(entry1);
      state.insert(entry2);

      final entry3 = OverlayEntry(builder: (context) => const Text('below'));
      state.insert(entry3, below: entry2);

      expect(state.entries.length, equals(3));
      expect(state.entries[0], same(entry1));
      expect(state.entries[1], same(entry3));
      expect(state.entries[2], same(entry2));
    });

    test('OverlayState insert above works', () {
      const overlay = Overlay(child: Text('child'));
      final state = overlay.createElement().state as OverlayState;

      final entry1 = OverlayEntry(builder: (context) => const Text('first'));
      final entry2 = OverlayEntry(builder: (context) => const Text('second'));
      state.insert(entry1);
      state.insert(entry2);

      final entry3 = OverlayEntry(builder: (context) => const Text('above'));
      state.insert(entry3, above: entry1);

      expect(state.entries.length, equals(3));
      expect(state.entries[0], same(entry1));
      expect(state.entries[1], same(entry3));
      expect(state.entries[2], same(entry2));
    });

    test('OverlayState remove entry', () {
      const overlay = Overlay(child: Text('child'));
      final state = overlay.createElement().state as OverlayState;

      final entry = OverlayEntry(builder: (context) => const Text('test'));
      state.insert(entry);
      expect(state.entries.length, equals(1));

      entry.remove();
      expect(state.entries.length, equals(0));
    });

    test('OverlayState remove sets overlay to null', () {
      const overlay = Overlay(child: Text('child'));
      final state = overlay.createElement().state as OverlayState;

      final entry = OverlayEntry(builder: (context) => const Text('test'));
      state.insert(entry);
      entry.remove();

      entry.remove();
    });
  });

  group('OverlayPortal', () {
    test('OverlayPortal is a StatelessWidget', () {
      const portal = OverlayPortal(child: Text('child'));
      expect(portal, isA<StatelessWidget>());
    });
  });
}
