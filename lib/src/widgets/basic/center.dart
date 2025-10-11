import '../../../radartui.dart';

class Center extends StatelessWidget {
  const Center({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: child,
    );
  }
}