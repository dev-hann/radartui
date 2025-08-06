
import 'package:radartui/src/widgets/framework.dart';

/// A widget that does not require mutable state.
abstract class StatelessWidget extends Widget {
  const StatelessWidget({super.key});

  @override
  StatelessElement createElement() => StatelessElement(this);

  /// Describes the part of the user interface represented by this widget.
  Widget build(BuildContext context);
}

/// A widget that has mutable state.
abstract class StatefulWidget extends Widget {
  const StatefulWidget({super.key});

  @override
  StatefulElement createElement() => StatefulElement(this);

  /// Creates the mutable state for this widget at a given location in the tree.
  State createState();
}

/// The logic and internal state for a [StatefulWidget].
abstract class State<T extends StatefulWidget> {
  /// The widget that this state is associated with.
  T get widget => _widget!;
  T? _widget;

  /// The location of this widget in the tree.
  BuildContext get context => _element!;
  StatefulElement? _element;

  /// Called when this object is inserted into the tree.
  void initState() {}

  /// Notifies the framework that the internal state of this object has changed.
  void setState(void Function() fn) {
    // TODO: This should trigger a rebuild of the widget.
    // 1. Call the function `fn`.
    // 2. Mark this element as dirty.
    // 3. Schedule a new frame with the scheduler.
  }

  /// Describes the part of the user interface represented by this widget.
  Widget build(BuildContext context);

  /// Called when this object is removed from the tree permanently.
  void dispose() {}
}
