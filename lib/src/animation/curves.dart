/// A mapping of a unit-time value (0.0–1.0) to another unit-time value.
abstract class Curve {
  const Curve();

  /// Returns the transformed value for the given input [t] (0.0–1.0).
  double transform(double t);
}

class _Linear extends Curve {
  const _Linear();

  @override
  double transform(double t) => t;
}

class _EaseIn extends Curve {
  const _EaseIn();

  @override
  double transform(double t) => t * t;
}

class _EaseOut extends Curve {
  const _EaseOut();

  @override
  double transform(double t) => t * (2 - t);
}

/// Standard animation curves for common easing behaviors.
class Curves {
  const Curves._();

  /// A curve where the value maps linearly from 0.0 to 1.0.
  static const Curve linear = _Linear();

  /// A curve that starts slowly and accelerates.
  static const Curve easeIn = _EaseIn();

  /// A curve that starts quickly and decelerates.
  static const Curve easeOut = _EaseOut();
}
