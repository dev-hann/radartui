import 'package:radartui/enum/axis.dart';
import 'package:radartui/widget/flex.dart';

class Column extends Flex {
  Column({super.key, required super.children}) : super(direction: Axis.vertical);
}


