import 'package:radartui/enum/axis.dart';
import 'package:radartui/widget/flex.dart';

class Row extends Flex {
  Row({super.key, required super.children}) : super(direction: Axis.horizontal);
}


