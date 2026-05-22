import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('ChangeNotifier', () {
    group('addListener', () {
      test('adds a listener', () {
        final notifier = ChangeNotifier();
        expect(notifier.hasListeners, isFalse);
        notifier.addListener(() {});
        expect(notifier.hasListeners, isTrue);
      });

      test('adds multiple listeners', () {
        final notifier = ChangeNotifier();
        notifier.addListener(() {});
        notifier.addListener(() {});
        expect(notifier.hasListeners, isTrue);
      });
    });

    group('removeListener', () {
      test('removes a registered listener', () {
        final notifier = ChangeNotifier();
        void listener() {}
        notifier.addListener(listener);
        expect(notifier.hasListeners, isTrue);
        notifier.removeListener(listener);
        expect(notifier.hasListeners, isFalse);
      });

      test('ignores unregistered listener', () {
        final notifier = ChangeNotifier();
        notifier.removeListener(() {});
        expect(notifier.hasListeners, isFalse);
      });

      test('removes only the specified listener', () {
        final notifier = ChangeNotifier();
        int callCount1 = 0;
        int callCount2 = 0;
        void listener1() {
          callCount1++;
        }

        void listener2() {
          callCount2++;
        }

        notifier.addListener(listener1);
        notifier.addListener(listener2);
        notifier.removeListener(listener1);
        notifier.notifyListeners();
        expect(callCount1, equals(0));
        expect(callCount2, equals(1));
      });
    });

    group('notifyListeners', () {
      test('calls all registered listeners', () {
        final notifier = ChangeNotifier();
        int callCount = 0;
        notifier.addListener(() {
          callCount++;
        });
        notifier.addListener(() {
          callCount++;
        });
        notifier.notifyListeners();
        expect(callCount, equals(2));
      });

      test('does not call removed listeners', () {
        final notifier = ChangeNotifier();
        int callCount = 0;
        void listener() {
          callCount++;
        }

        notifier.addListener(listener);
        notifier.removeListener(listener);
        notifier.notifyListeners();
        expect(callCount, equals(0));
      });

      test(
          'snapshot semantics: listener added during notification is not called',
          () {
        final notifier = ChangeNotifier();
        int callCount = 0;
        void lateListener() {
          callCount++;
        }

        notifier.addListener(() {
          notifier.addListener(lateListener);
        });
        notifier.notifyListeners();
        expect(callCount, equals(0));
      });

      test(
          'snapshot semantics: listener removed during notification is still called',
          () {
        final notifier = ChangeNotifier();
        int callCount = 0;
        void listener() {
          callCount++;
        }

        notifier.addListener(() {
          notifier.removeListener(listener);
        });
        notifier.addListener(listener);
        notifier.notifyListeners();
        expect(callCount, equals(1));
      });
    });

    group('dispose', () {
      test('clears all listeners', () {
        final notifier = ChangeNotifier();
        notifier.addListener(() {});
        notifier.addListener(() {});
        notifier.dispose();
        expect(notifier.hasListeners, isFalse);
      });

      test('notified listeners are not called after dispose', () {
        final notifier = ChangeNotifier();
        int callCount = 0;
        notifier.addListener(() {
          callCount++;
        });
        notifier.dispose();
        notifier.notifyListeners();
        expect(callCount, equals(0));
      });
    });

    group('hasListeners', () {
      test('returns false initially', () {
        final notifier = ChangeNotifier();
        expect(notifier.hasListeners, isFalse);
      });

      test('returns true after adding a listener', () {
        final notifier = ChangeNotifier();
        notifier.addListener(() {});
        expect(notifier.hasListeners, isTrue);
      });

      test('returns false after removing all listeners', () {
        final notifier = ChangeNotifier();
        void listener() {}
        notifier.addListener(listener);
        notifier.removeListener(listener);
        expect(notifier.hasListeners, isFalse);
      });
    });
  });
}
