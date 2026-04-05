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
}
