import '../../../radartui.dart';

Widget defaultSelectedBuilder<T>(T item) {
  return Text('> $item');
}

Widget defaultUnselectedBuilder<T>(T item) {
  return Text('  $item');
}
