import '../framework.dart';
import 'focus.dart';
import '../../services/key_parser.dart';
import '../../scheduler/binding.dart';
import 'dart:async';

class FocusScopeWidget extends StatefulWidget {
  final Widget child;
  final bool handleKeyboard;

  const FocusScopeWidget({required this.child, this.handleKeyboard = true});

  @override
  State<FocusScopeWidget> createState() => _FocusScopeWidgetState();
}

class _FocusScopeWidgetState extends State<FocusScopeWidget> {
  late FocusScope _focusScope;
  StreamSubscription<KeyEvent>? _keySubscription;

  @override
  void initState() {
    super.initState();
    _focusScope = FocusScope();

    // 전역 FocusManager에 등록
    FocusManager.setCurrentScope(_focusScope);

    if (widget.handleKeyboard) {
      _setupKeyboardListener();
    }
  }

  void _setupKeyboardListener() {
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((
      event,
    ) {
      _handleKeyEvent(event);
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    switch (event.key) {
      case 'Tab':
        _focusScope.nextFocus();
        break;
      case 'Shift+Tab':
        _focusScope.previousFocus();
        break;
      // 다른 키 이벤트는 현재 포커스된 위젯에서 처리하도록 둠
    }
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
