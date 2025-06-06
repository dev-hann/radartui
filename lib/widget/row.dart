import 'package:radartui/enum/axis.dart';
import 'package:radartui/widget/flex.dart';

class Row extends Flex {
  Row({required super.children}) : super(direction: Axis.horizontal);
}

class RowOld extends FlexOld {
  RowOld({required super.children}) : super(direction: Axis.horizontal);
}
