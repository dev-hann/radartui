
import 'package:radartui/src/foundation/key.dart';
import 'package:radartui/src/widgets/element.dart';

/// Describes the configuration for an [Element].
///
/// Widgets are the central class in the framework. They are immutable and describe
/// a part of the user interface.
abstract class Widget {
  const Widget({this.key});

  final Key? key;

  /// Creates the [Element] for this widget at a given slot in the tree.
  Element createElement();
}
