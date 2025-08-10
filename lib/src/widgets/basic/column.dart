import 'package:radartui/src/foundation/axis.dart';
import 'package:radartui/src/widgets/basic/flex.dart';

class Column extends Flex {
  const Column({required List<Widget> children})
    : super(children: children, direction: Axis.vertical);
}
