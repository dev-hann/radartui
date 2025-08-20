import '../../../radartui.dart';

class Row extends Flex {
  const Row({required List<Widget> children})
    : super(children: children, direction: Axis.horizontal);
}

class Column extends Flex {
  const Column({required List<Widget> children})
    : super(children: children, direction: Axis.vertical);
}