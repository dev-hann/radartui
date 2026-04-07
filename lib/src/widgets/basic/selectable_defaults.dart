import '../../../radartui.dart';

/// Default builder for selected items in selectable widgets.
///
/// Prefixes that item with a '>' character to indicate selection.
/// Used by [ListView] and [GridView] when no custom builder is provided.
Widget defaultSelectedBuilder<T>(T item) {
  return Text('> $item');
}

/// Default builder for unselected items in selectable widgets.
///
/// Prefixes that item with two spaces for alignment with selected items.
/// Used by [ListView] and [GridView] when no custom builder is provided.
Widget defaultUnselectedBuilder<T>(T item) {
  return Text('  $item');
}

/// Wraps an index within bounds of a list.
///
/// Handles wrap-around navigation where moving past the last item
/// returns to the first, and vice versa. Returns a value in the
/// range [0, totalItems - 1].
///
/// Examples:
/// - `wrapSelectableIndex(5, 5)` returns `0`
/// - `wrapSelectableIndex(-1, 5)` returns `4`
/// - `wrapSelectableIndex(2, 5)` returns `2`
int wrapSelectableIndex(int index, int totalItems) {
  final wrapped = index % totalItems;
  return wrapped < 0 ? wrapped + totalItems : wrapped;
}
