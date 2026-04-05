import '../../../radartui.dart';

/// Takes up empty space in a [Flex] container (Row or Column).
///
/// Expands to fill available space proportionally to its [flex] factor.
/// Has no visual representation.
class Spacer extends StatelessWidget {
  const Spacer({super.key, this.flex = 1});
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: const SizedBox.shrink());
  }
}
