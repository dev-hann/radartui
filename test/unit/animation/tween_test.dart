import 'package:radartui/src/animation/animation_controller.dart';
import 'package:radartui/src/animation/tween.dart';
import 'package:radartui/src/foundation/color.dart';
import 'package:test/test.dart';

void main() {
  group('Tween', () {
    test('lerp returns begin at t=0', () {
      final tween = _TestTween(begin: 0.0, end: 100.0);
      expect(tween.lerp(0.0), equals(0.0));
    });

    test('lerp returns end at t=1', () {
      final tween = _TestTween(begin: 0.0, end: 100.0);
      expect(tween.lerp(1.0), equals(100.0));
    });

    test('lerp interpolates linearly', () {
      final tween = _TestTween(begin: 0.0, end: 100.0);
      expect(tween.lerp(0.5), equals(50.0));
    });

    test('animate wraps parent animation', () {
      final controller = AnimationController(initialValue: 0.5);
      final tween = _TestTween(begin: 0.0, end: 100.0);
      final animation = tween.animate(controller);

      expect(animation.value, equals(50.0));
    });
  });

  group('ColorTween', () {
    test('lerp returns begin color when t < 0.5', () {
      const tween = ColorTween(begin: Color.blue, end: Color.red);
      expect(tween.lerp(0.0), equals(Color.blue));
      expect(tween.lerp(0.49), equals(Color.blue));
    });

    test('lerp returns end color when t >= 0.5', () {
      const tween = ColorTween(begin: Color.blue, end: Color.red);
      expect(tween.lerp(0.5), equals(Color.red));
      expect(tween.lerp(1.0), equals(Color.red));
    });
  });
}

class _TestTween extends Tween<double> {
  _TestTween({required super.begin, required super.end});

  @override
  double lerp(double t) => begin + (end - begin) * t;
}
