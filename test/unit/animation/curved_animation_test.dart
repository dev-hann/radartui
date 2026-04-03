import 'package:radartui/radartui_test.dart';
import 'package:radartui/src/animation/animation_controller.dart';
import 'package:radartui/src/animation/curved_animation.dart';
import 'package:radartui/src/animation/curves.dart';
import 'package:test/test.dart';

void main() {
  group('CurvedAnimation', () {
    late TestBinding binding;

    setUp(() {
      binding = TestBinding.ensureInitialized();
    });

    tearDown(() {
      binding.unmount();
    });

    test('applies curve to parent value', () {
      final controller = AnimationController(initialValue: 0.5);
      final curved = CurvedAnimation(parent: controller, curve: Curves.linear);

      expect(curved.value, equals(0.5));
    });

    test('easeIn curve transforms value', () {
      final controller = AnimationController(initialValue: 0.5);
      final curved = CurvedAnimation(parent: controller, curve: Curves.easeIn);

      expect(curved.value, closeTo(0.25, 0.001));
    });

    test('easeOut curve transforms value', () {
      final controller = AnimationController(initialValue: 0.5);
      final curved = CurvedAnimation(parent: controller, curve: Curves.easeOut);

      expect(curved.value, closeTo(0.75, 0.001));
    });

    test('status matches parent status', () {
      final controller = AnimationController();
      final curved = CurvedAnimation(parent: controller, curve: Curves.linear);

      controller.forward();
      expect(curved.status, equals(controller.status));
    });
  });
}
