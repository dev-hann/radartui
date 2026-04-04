import '../foundation.dart';

class ScrollController extends ChangeNotifier {
  int _offset = 0;

  int get offset => _offset;

  set offset(int value) {
    if (_offset != value) {
      _offset = value;
      notifyListeners();
    }
  }

  void animateTo(int newOffset) {
    offset = newOffset;
  }
}
