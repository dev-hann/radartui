import '../../../radartui.dart';

Widget defaultSelectedBuilder<T>(T item) {
  return Text('> $item');
}

Widget defaultUnselectedBuilder<T>(T item) {
  return Text('  $item');
}

int wrapSelectableIndex(int index, int totalItems) {
  final wrapped = index % totalItems;
  return wrapped < 0 ? wrapped + totalItems : wrapped;
}
