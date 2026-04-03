import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('BindingBase', () {
    tearDown(() {
      TestBinding.maybeInstance?.unmount();
    });

    test('creates instance on construction', () {
      expect(TestBinding.maybeInstance, isNull);
      final binding = TestBinding.ensureInitialized();
      expect(TestBinding.instance, same(binding));
    });

    test('checkInstance throws when not initialized', () {
      TestBinding? nil;
      expect(() => BindingBase.checkInstance(nil), throwsStateError);
    });
  });

  group('SchedulerBinding', () {
    late TestBinding binding;

    setUp(() {
      binding = TestBinding.ensureInitialized();
    });

    tearDown(() {
      binding.unmount();
    });

    test('scheduleFrame schedules handleFrame', () async {
      var callbackCalled = false;
      binding.addPostFrameCallback((_) {
        callbackCalled = true;
      });

      binding.scheduleFrame();
      await Future<void>.delayed(Duration.zero);

      expect(callbackCalled, isTrue);
    });

    test('does not schedule duplicate frames', () async {
      var callCount = 0;
      binding.addPostFrameCallback((_) {
        callCount++;
      });

      binding.scheduleFrame();
      binding.scheduleFrame();
      binding.scheduleFrame();
      await Future<void>.delayed(Duration.zero);

      expect(callCount, equals(1));
    });
  });

  group('ServicesBinding', () {
    late TestBinding binding;

    setUp(() {
      binding = TestBinding.ensureInitialized();
    });

    tearDown(() {
      binding.unmount();
    });

    test('provides keyboard', () {
      expect(binding.keyboard, isA<TestKeyboard>());
    });

    test('provides terminal', () {
      expect(binding.terminal, isA<TestTerminal>());
    });
  });

  group('WidgetsBinding', () {
    late TestBinding binding;

    setUp(() {
      binding = TestBinding.ensureInitialized();
    });

    tearDown(() {
      binding.unmount();
    });

    test('runWidget creates root element', () {
      binding.runWidget(const Text('Test'));
      expect(binding.rootElement, isNotNull);
    });

    test('rootElement is null before runWidget', () {
      expect(binding.rootElement, isNull);
    });

    test('unmount clears root element', () {
      binding.runWidget(const Text('Test'));
      expect(binding.rootElement, isNotNull);
      binding.unmount();
      expect(binding.rootElement, isNull);
    });
  });

  group('TestBinding', () {
    test('uses custom terminal size', () {
      final binding = TestBinding(width: 100, height: 50);
      expect(binding.terminal.width, equals(100));
      expect(binding.terminal.height, equals(50));
      binding.unmount();
    });

    test('pump rebuilds and relayouts', () async {
      final binding = TestBinding.ensureInitialized();
      binding.runWidget(const Text('Test'));
      await binding.pumpAndSettle();
      expect(binding.terminal.contains('Test'), isTrue);
    });
  });
}
