import '../../../radartui.dart';

/// Centers its child within itself.
///
/// Equivalent to `Align(alignment: Alignment.center, child: child)`.
class Center extends StatelessWidget {
  const Center({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: child);
  }
}
