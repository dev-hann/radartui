
import 'package:radartui/src/widgets/state.dart';

/// A widget that displays a string of text.
class Text extends StatelessWidget {
  final String data;
  // TODO: Add a Style property.

  const Text(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    // Text is a leaf widget, so it doesn't build other widgets.
    // It will be associated with a RenderObject that knows how to paint text.
    // We will need a corresponding RenderObjectWidget for this.
    return /* RenderTextWidget(...) */;
  }
}

/// A widget that displays its children in a vertical array.
class Column extends StatelessWidget {
  final List<Widget> children;

  const Column({this.children = const [], super.key});

  @override
  Widget build(BuildContext context) {
    // This will be a RenderObjectWidget that uses a RenderFlex as its RenderObject.
    return /* RenderFlexWidget(...) */;
  }
}

/// A widget that displays its children in a horizontal array.
class Row extends StatelessWidget {
  final List<Widget> children;

  const Row({this.children = const [], super.key});

  @override
  Widget build(BuildContext context) {
    // This will also be a RenderObjectWidget that uses a RenderFlex.
    return /* RenderFlexWidget(...) */;
  }
}
