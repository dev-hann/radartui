import 'basic/stack.dart';
import 'framework.dart';

/// An entry in an [Overlay], analogous to Flutter's [OverlayEntry].
class OverlayEntry {
  /// Creates an [OverlayEntry].
  OverlayEntry({required this.builder, this.opaque = false});

  /// The builder that creates this entry's widget.
  final Widget Function(BuildContext) builder;

  /// Whether this entry covers the entire overlay.
  final bool opaque;
  OverlayState? _overlay;

  /// Whether this entry is currently mounted in an overlay.
  bool get mounted => _overlay != null;

  /// Removes this entry from its overlay.
  void remove() {
    _overlay?._remove(this);
  }
}

/// A widget that stacks its child and overlay entries, analogous to Flutter's [Overlay].
class Overlay extends StatefulWidget {
  /// Creates an [Overlay].
  const Overlay({super.key, required this.child});

  /// The widget rendered below all overlay entries.
  final Widget child;

  /// Returns the [OverlayState] of the nearest [Overlay] ancestor.
  static OverlayState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_OverlayScope>()?._state;
  }

  @override
  State<Overlay> createState() => OverlayState();
}

/// The mutable state for an [Overlay] widget.
class OverlayState extends State<Overlay> {
  final List<OverlayEntry> _entries = [];

  /// An unmodifiable view of the current overlay entries.
  List<OverlayEntry> get entries => List<OverlayEntry>.unmodifiable(_entries);

  /// Inserts [entry] into the overlay, optionally positioned relative to [below] or [above].
  void insert(OverlayEntry entry, {OverlayEntry? below, OverlayEntry? above}) {
    entry._overlay = this;
    if (below != null) {
      final int index = _entries.indexOf(below);
      if (index == -1) {
        _entries.add(entry);
      } else {
        _entries.insert(index, entry);
      }
    } else if (above != null) {
      final int index = _entries.indexOf(above);
      if (index == -1) {
        _entries.add(entry);
      } else {
        _entries.insert(index + 1, entry);
      }
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

/// A convenience widget that wraps its child in an [Overlay].
class OverlayPortal extends StatelessWidget {
  /// Creates an [OverlayPortal].
  const OverlayPortal({super.key, required this.child});

  /// The child widget rendered inside the overlay.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Overlay(child: child);
  }
}
