import 'package:radartui/src/foundation/axis.dart';
import 'package:radartui/src/widgets/basic/flex.dart';
import 'package:radartui/src/widgets/framework.dart';

class Row extends Flex {
  const Row({required List<Widget> children})
    : super(children: children, direction: Axis.horizontal);
}
