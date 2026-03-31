abstract class Curve {
  const Curve();

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

class Curves {
  const Curves._();

  static const Curve linear = _Linear();
  static const Curve easeIn = _EaseIn();
  static const Curve easeOut = _EaseOut();
}
