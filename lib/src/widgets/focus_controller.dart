import 'dart:async';

import 'package:radartui/src/scheduler/binding.dart';
import 'package:radartui/src/services/key_parser.dart';
import 'package:radartui/src/widgets/basic/focus.dart';

class FocusController {
  final FocusScope _focusScope = FocusScope();
  StreamSubscription<KeyEvent>? _keySubscription;

  void activate() {
    FocusManager.setCurrentScope(_focusScope);
    _keySubscription ??= SchedulerBinding.instance.keyboard.keyEvents.listen(
      _handleKeyEvent,
    );
  }

  void deactivate() {
    if (FocusManager.currentScope == _focusScope) {
      FocusManager.setCurrentScope(null);
    }
    _keySubscription?.cancel();
    _keySubscription = null;
  }

  void _handleKeyEvent(KeyEvent event) {
    switch (event.key) {
      case 'Tab':
        _focusScope.nextFocus();
        break;
      case 'Shift+Tab':
        _focusScope.previousFocus();
        break;
      default:
        _focusScope.currentFocus?.onKeyEvent?.call(event);
        break;
    }
  }

  FocusScope get scope => _focusScope;

  void dispose() {
    deactivate();
  }
}
