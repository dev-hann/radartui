import '../foundation.dart';

/// Controls scroll position and notifies listeners of changes, analogous to
/// Flutter's [ScrollController].
class ScrollController extends ChangeNotifier {
  int _offset = 0;

  /// The current scroll offset in cells.
  int get offset => _offset;

  /// Sets the scroll offset, notifying listeners if the value changes.
  set offset(int value) {
    if (_offset != value) {
      _offset = value;
      notifyListeners();
    }
  }

  /// Scrolls to the given [newOffset].
  void animateTo(int newOffset) {
    offset = newOffset;
  }

  /// Adjusts [offset] so that [index] is visible within a viewport of
  /// [viewportHeight] rows.
  void ensureVisible(int index, int viewportHeight) {
    if (viewportHeight <= 0) return;

    final int bottomVisible = _offset + viewportHeight - 1;

    if (index < _offset) {
      offset = index;
    } else if (index > bottomVisible) {
      offset = index - viewportHeight + 1;
    }
  }
}
