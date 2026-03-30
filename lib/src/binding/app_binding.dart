import '../services.dart';
import 'binding_base.dart';
import 'renderer_binding.dart';
import 'scheduler_binding.dart';
import 'services_binding.dart';
import 'widgets_binding.dart';

class AppBinding extends BindingBase
    with SchedulerBinding, ServicesBinding, RendererBinding, WidgetsBinding {
  AppBinding([TerminalBackend? terminalBackend])
      : _terminalBackend = terminalBackend ?? RealTerminalBackend(),
        _terminal = _TerminalImpl() {
    _terminal.setBackend(_terminalBackend);
    outputBuffer = OutputBuffer(_terminal);
  }
  final TerminalBackend _terminalBackend;
  late final _TerminalImpl _terminal;

  @override
  final RawKeyboard keyboard = RawKeyboard();

  @override
  late final OutputBuffer outputBuffer;

  @override
  Terminal get terminal => _terminal;

  static WidgetsBinding ensureInitialized() {
    if (!WidgetsBinding.isInitialized) {
      AppBinding();
    }
    return WidgetsBinding.instance;
  }
}

class _TerminalImpl implements Terminal {
  TerminalBackend? _backend;

  void setBackend(TerminalBackend backend) {
    _backend = backend;
  }

  @override
  int get width => _backend?.width ?? 80;

  @override
  int get height => _backend?.height ?? 24;

  @override
  void clear() => _backend?.clear();

  @override
  void hideCursor() => _backend?.hideCursor();

  @override
  void showCursor() => _backend?.showCursor();

  @override
  void setCursorPosition(int x, int y) => _backend?.setCursorPosition(x, y);

  @override
  void reset() => clear();

  @override
  TerminalBackend get backend => _backend ?? RealTerminalBackend();

  @override
  void write(String data) => _backend?.write(data);
}
