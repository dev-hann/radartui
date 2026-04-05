import '../../../radartui.dart';

/// Centers its child within itself.
///
/// Equivalent to `Align(alignment: Alignment.center, child: child)`.
class Center extends StatelessWidget {
  /// Creates a [Center] widget with the given optional [child].
  const Center({super.key, this.child});

  /// The widget to center within the available space.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: child);
  }
}
