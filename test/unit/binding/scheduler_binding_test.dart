import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('SchedulerBinding persistent frame callbacks', () {
    late TestBinding binding;

    setUp(() {
      binding = TestBinding.ensureInitialized();
    });

    tearDown(() {
      binding.unmount();
    });

    test('addPersistentFrameCallback registers callback', () async {
      var callCount = 0;

      binding.addPersistentFrameCallback((duration) {
        callCount++;
      });

      binding.scheduleFrame();
      await Future<void>.delayed(Duration.zero);

      expect(callCount, equals(1));
    });

    test('persistent callbacks are called on every frame', () async {
      var callCount = 0;

      binding.addPersistentFrameCallback((duration) {
        callCount++;
      });

      binding.scheduleFrame();
      await Future<void>.delayed(Duration.zero);

      binding.scheduleFrame();
      await Future<void>.delayed(Duration.zero);

      expect(callCount, equals(2));
    });
  });
}
