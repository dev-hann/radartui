import 'dart:async';

import 'package:radartui/radartui_test.dart';
import 'package:radartui/src/animation/animation.dart';
import 'package:radartui/src/animation/animation_controller.dart';
import 'package:test/test.dart';

void main() {
  group('AnimationController', () {
    late TestBinding binding;

    setUp(() {
      binding = TestBinding.ensureInitialized();
    });

    tearDown(() {
      binding.unmount();
    });
    test('initial value is set correctly', () {
      final controller = AnimationController(initialValue: 0.5);
      expect(controller.value, equals(0.5));
    });

    test('default bounds are 0.0 to 1.0', () {
      final controller = AnimationController();
      expect(controller.lowerBound, equals(0.0));
      expect(controller.upperBound, equals(1.0));
    });

    test('reset sets value to lowerBound', () {
      final controller = AnimationController(initialValue: 0.5);
      controller.reset();
      expect(controller.value, equals(0.0));
    });

    test('forward changes status to forward', () {
      final controller = AnimationController();
      controller.forward();
      expect(controller.status, equals(AnimationStatus.forward));
    });

    test('reverse changes status to reverse', () {
      final controller = AnimationController(initialValue: 1.0);
      controller.reverse();
      expect(controller.status, equals(AnimationStatus.reverse));
    });

    test('stop freezes at current value', () {
      final controller = AnimationController(initialValue: 0.5);
      controller.stop();
      expect(controller.value, equals(0.5));
    });

    test('listeners are notified on value change', () async {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 50),
      );
      var notified = false;

      controller.addListener(() {
        notified = true;
      });

      controller.forward();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(notified, isTrue);
    });

    test('status listeners are notified on status change', () {
      final controller = AnimationController();
      AnimationStatus? lastStatus;

      controller.addStatusListener((status) {
        lastStatus = status;
      });

      controller.forward();
      expect(lastStatus, equals(AnimationStatus.forward));
    });

    test('dispose stops animation and clears listeners', () {
      final controller = AnimationController();
      controller.forward();
      controller.dispose();

      expect(controller.status, equals(AnimationStatus.dismissed));
    });
  });
}
