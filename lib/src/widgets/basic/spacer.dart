import '../../../radartui.dart';

/// Takes up empty space in a [Flex] container (Row or Column).
///
/// Expands to fill available space proportionally to its [flex] factor.
/// Has no visual representation.
class Spacer extends StatelessWidget {
  /// Creates a [Spacer] with the given [flex] factor (default 1).
  const Spacer({super.key, this.flex = 1});

  /// The flex factor controlling how much space this spacer occupies.
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: const SizedBox.shrink());
  }
}
