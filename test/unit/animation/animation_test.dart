import 'package:radartui/src/animation/animation.dart';
import 'package:test/test.dart';

void main() {
  group('Animation', () {
    test('AnimationStatus enum has correct values', () {
      expect(AnimationStatus.dismissed.index, equals(0));
      expect(AnimationStatus.forward.index, equals(1));
      expect(AnimationStatus.reverse.index, equals(2));
      expect(AnimationStatus.completed.index, equals(3));
    });
  });

  group('AnimationListeners', () {
    test('addListener and removeListener work correctly', () {
      final listeners = AnimationListeners<int>();
      int callCount = 0;

      void listener() => callCount++;

      listeners.addListener(listener);
      listeners.notifyListeners();
      expect(callCount, equals(1));

      listeners.removeListener(listener);
      listeners.notifyListeners();
      expect(callCount, equals(1));
    });

    test('multiple listeners are all called', () {
      final listeners = AnimationListeners<int>();
      int count1 = 0;
      int count2 = 0;

      listeners.addListener(() => count1++);
      listeners.addListener(() => count2++);
      listeners.notifyListeners();

      expect(count1, equals(1));
      expect(count2, equals(1));
    });
  });
}
