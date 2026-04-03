import 'basic/stack.dart';
import 'framework.dart';

class OverlayEntry {
  OverlayEntry({required this.builder, this.opaque = false});

  final Widget Function(BuildContext) builder;
  final bool opaque;
  OverlayState? _overlay;

  bool get mounted => _overlay != null;

  void remove() {
    _overlay?._remove(this);
  }
}

class Overlay extends StatefulWidget {
  const Overlay({super.key, required this.child});

  final Widget child;

  static OverlayState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_OverlayScope>()?._state;
  }

  @override
  State<Overlay> createState() => OverlayState();
}

class OverlayState extends State<Overlay> {
  final List<OverlayEntry> _entries = [];

  List<OverlayEntry> get entries => List<OverlayEntry>.unmodifiable(_entries);

  void insert(OverlayEntry entry, {OverlayEntry? below, OverlayEntry? above}) {
    entry._overlay = this;
    if (below != null) {
      final index = _entries.indexOf(below);
      _entries.insert(index, entry);
    } else if (above != null) {
      final index = _entries.indexOf(above);
      _entries.insert(index + 1, entry);
    } else {
      _entries.add(entry);
    }
    setState(() {});
  }

  void _remove(OverlayEntry entry) {
    _entries.remove(entry);
    entry._overlay = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _OverlayScope(
      state: this,
      child: Stack(
        children: [
          widget.child,
          ..._entries.map((entry) => entry.builder(context)),
        ],
      ),
    );
  }
}

class _OverlayScope extends InheritedWidget {
  const _OverlayScope({required OverlayState state, required super.child})
    : _state = state;

  final OverlayState _state;

  @override
  bool updateShouldNotify(_OverlayScope oldWidget) => false;
}

class OverlayPortal extends StatelessWidget {
  const OverlayPortal({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Overlay(child: child);
  }
}
